import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/services/device_location_service.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/key_details_service.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/app/services/update_emi_service.dart';
import 'package:zlock_smart_finance/model/key_details_response.dart';
import 'package:zlock_smart_finance/model/update_emi_response.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_page.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_response.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_service.dart';

import 'package:zlock_smart_finance/app/services/device_command_service.dart';
import 'package:zlock_smart_finance/model/device_command_model.dart';



import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:zlock_smart_finance/app/request/add_key_request.dart';
import 'package:zlock_smart_finance/app/services/add_key_api_service.dart';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:zlock_smart_finance/app/services/upload_doc_service.dart';
import 'package:zlock_smart_finance/app/utils/imei_scanner_screen.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/dashboard_retailer.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/change_emi_status_bottom.dart';

enum CustomerDetailV2EmiStatus { paid, unpaid }

extension CustomerDetailV2EmiStatusX on CustomerDetailV2EmiStatus {
  String get label =>
      this == CustomerDetailV2EmiStatus.paid ? "Paid" : "Unpaid";
}

// class CustomerDetailV2EmiRow {
//   final String emiId;
//   String date;
//   String amount;
//   CustomerDetailV2EmiStatus status;
//   DateTime? paidDate;
//
//   CustomerDetailV2EmiRow({
//     required this.emiId,
//     required this.date,
//     required this.amount,
//     required this.status,
//     this.paidDate,
//   });
// }

class CustomerDetailV2EmiRow {
  final int emiNumber;

  String date;
  String amount;
  CustomerDetailV2EmiStatus status;
  DateTime? paidDate;

  CustomerDetailV2EmiRow({
    required this.emiNumber,
    required this.date,
    required this.amount,
    required this.status,
    this.paidDate,
  });
}
class CustomerDetailV2Controller extends GetxController {

  final box = GetStorage();

  final selectedTab = 0.obs;

  final customerId = ''.obs;

  final isDetailsLoading = false.obs;
  final customer = Rxn<CustomerDetailV2Item>();

  final autoLock = false.obs;
  final addOverdueAmount = true.obs;

  final isLocking = false.obs;
  final isUnlocking = false.obs;

  final selectedStatus = CustomerDetailV2EmiStatus.unpaid.obs;
  final selectedPayDate = Rxn<DateTime>();

  final emis = <CustomerDetailV2EmiRow>[].obs;
  final emiSchedule = RxList<EmiScheduleItem>();

  final _service = CustomerDetailV2Service();
  final _commandService = DeviceCommandService();

  final _dateFmt = DateFormat('dd/MM/yy');
  final _moneyFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  String get actualDeviceId {
    return customer.value?.device?.id.trim() ?? "";
  }


  // ✅ Details data
  final details = Rxn<KeyDetailsData>();

  final _detailsService = KeyDetailsService();

  final _emiService = EmiService();
  final isUpdatingEmi = false.obs; // optional loader

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  RxString lastUpdatedText = "Updating...".obs;
  Timer? _locationTimer;
  DateTime? _lastFetchTime;

  final RxList<Map<String, dynamic>> simHistory =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    debugPrint("📥 CustomerDetailV2Controller args => $args");

    if (args is Map) {
      customerId.value =
          (args["customerId"] ?? args["deviceId"] ?? "").toString();
    }

    debugPrint("📌 customerId => ${customerId.value}");
    debugPrint("📌 customerDeviceId => $actualDeviceId");

    fetchCustomerDetails();
    _loadSavedCommands();

  }
  void _loadSavedCommands() {
    commands.forEach((key, rxBool) {
      final saved = box.read(key);
      if (saved != null) {
        rxBool.value = saved;
      }
    });
  }

  final DeviceLocationService locationService =
  DeviceLocationService(Dio());

  RxString deviceAddress = "Fetching location...".obs;
  RxBool isLocationLoading = false.obs;

  Future<void> fetchDeviceLocation() async {
    if (actualDeviceId.isEmpty) {
      deviceAddress.value = "Location not found";
      return;
    }

    try {
      isLocationLoading.value = true;

      final location =
      await locationService.getDeviceLocation(actualDeviceId);

      if (location == null) {
        deviceAddress.value = "Location not found";
        return;
      }

      latitude.value = location.latitude;
      longitude.value = location.longitude;

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
          location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        deviceAddress.value =
        "${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        deviceAddress.value =
        "${location.latitude}, ${location.longitude}";
      }

      /// ✅ TIME UPDATE
      // _lastFetchTime = DateTime.now();
      // _updateTimeText();

    } catch (e) {
      deviceAddress.value = "Location not found";
    } finally {
      isLocationLoading.value = false;
    }
  }

  Timer? _locationRefreshTimer;

  void startAutoLocationRefresh({int intervalMinutes = 5}) {
    // Cancel any existing timer
    _locationRefreshTimer?.cancel();

    // Start a new periodic timer
    _locationRefreshTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
          (_) => fetchDeviceLocation(),
    );
  }

  void stopAutoLocationRefresh() {
    _locationRefreshTimer?.cancel();
    _locationRefreshTimer = null;
  }
  Future<void> fetchCustomerDetails() async {

    final id = customerId.value.trim();
    if (id.isEmpty) {
      debugPrint("❌ customerId missing");
      return;
    }

    if (isDetailsLoading.value) return;

    isDetailsLoading.value = true;
    try {
      final resp = await _service.getCustomerById(customerId: id);
      customer.value = resp;
      await fetchEmiSchedule();

      /// ✅ SYNC COMMAND STATES FROM API
      commands["ACTIVE_RESTRICTION"]?.value =
          resp?.keyActions?.restriction ?? false;

      commands["Lock Device"]?.value =
          resp?.keyActions?.lockDevice ?? false;

      commands["Social Media"]?.value =
          resp?.keyActions?.socialMediaLock ?? false;

      _buildEmiRows();

      debugPrint("✅ Customer detail loaded");
      debugPrint("✅ Actual device id => $actualDeviceId");

      debugPrint("✅ Full customer => ${customer.value}");
      debugPrint("✅ Device object => ${customer.value?.device}");
      debugPrint("✅ Device _id => ${customer.value?.device?.id}");
      debugPrint("✅ Device device_id => ${customer.value?.device?.deviceId}");

    } finally {
      isDetailsLoading.value = false;
    }
  }

  String? get productImage {
    final image = customer.value?.profileImage?.trim() ?? "";
    return image.isEmpty ? null : image;
  }

  String get customerName => customer.value?.name ?? "-";
  String get customerPhone => customer.value?.phone ?? "-";
  String get customerEmail => customer.value?.email ?? "-";
  String get deviceStatus => isActiveDevice ? "ACTIVE" : "INACTIVE";
  String get brandModel => customer.value?.device?.deviceName ?? "-";
  String get imei1 => customer.value?.imei1 ?? "-";
  String get imei2 => customer.value?.imei2 ?? "-";

  String get loanId => customer.value?.id ?? "-";
  double get productPrice => (customer.value?.emi?.totalAmount ?? 0).toDouble();
  double get downPayment => (customer.value?.emi?.downPayment ?? 0).toDouble();
  String get downPaymentDate => customer.value?.createdAt ?? "-";
  double get loanAmount => (customer.value?.emi?.loanAmount ?? 0).toDouble();

  String get loanBy =>
      (customer.value?.loanBy?.isNotEmpty == true)
          ? customer.value!.loanBy!
          : (customer.value?.emi?.loanProvider?.isNotEmpty == true
          ? customer.value!.emi!.loanProvider!
          : "-");

  int get tenure => customer.value?.emi?.tenureMonths ?? 0;
  double get processingFee => 0;
  double get emiAmount => (customer.value?.emi?.emiAmount ?? 0).toDouble();
  String get firstEmiDate => customer.value?.emi?.startDate ?? "-";

  int get paidEmi => customer.value?.emi?.totalEmiPaid ?? 0;
  int get totalEmi => customer.value?.emi?.tenureMonths ?? 0;

  double get progress {
    if (totalEmi <= 0) return 0.0;
    return (paidEmi / totalEmi).clamp(0.0, 1.0);
  }

  double get progressPercentage {
    if (totalEmi <= 0) return 0;
    return (paidEmi / totalEmi) * 100;
  }

  bool get isActiveDevice => customer.value?.isActive == true;

  bool get isDeviceActiveByRemove {
    final remove = customer.value?.keyActions?.remove;

    /// ✅ FINAL LOGIC
    /// remove = true  → INACTIVE
    /// remove = false → ACTIVE

    return remove == false;
  }

  String get agreementUrl => "";
  bool isDocLoading(String key) => false;

  String _fmtDate(String? iso, {String fallback = "-"}) {
    if (iso == null || iso.trim().isEmpty || iso == "-") return fallback;
    try {
      return _dateFmt.format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return fallback;
    }
  }

  String _fmtMoney(num v) => _moneyFmt.format(v);

  // void _buildEmiRows() {
  //   final emi = customer.value?.emi;
  //   if (emi == null) {
  //     emis.clear();
  //     return;
  //   }
  //
  //   final total = emi.tenureMonths ?? 0;
  //   final paid = emi.totalEmiPaid ?? 0;
  //   final list = <CustomerDetailV2EmiRow>[];
  //
  //   for (int i = 0; i < total; i++) {
  //     final isPaid = i < paid;
  //
  //     list.add(
  //       CustomerDetailV2EmiRow(
  //         emiId: "${customer.value?.id ?? ''}_$i",
  //         date: _fmtDate(emi.startDate),
  //         amount: _fmtMoney(emi.emiAmount ?? 0),
  //         status: isPaid
  //             ? CustomerDetailV2EmiStatus.paid
  //             : CustomerDetailV2EmiStatus.unpaid,
  //       ),
  //     );
  //   }
  //
  //   emis.assignAll(list);
  // }

  void _buildEmiRows() {
    final list = <CustomerDetailV2EmiRow>[];

    for (final emi in emiSchedule) {
      list.add(
        CustomerDetailV2EmiRow(
          emiNumber: emi.emiNumber,
          date: emi.dueDate == null
              ? "-"
              : _fmtDate(emi.dueDate),

          amount: _fmtMoney(
            emi.emiAmount,
          ),

          status: emi.status.toLowerCase() == "paid"
              ? CustomerDetailV2EmiStatus.paid
              : CustomerDetailV2EmiStatus.unpaid,

          paidDate: emi.paidDate == null
              ? null
              : DateTime.tryParse(
            emi.paidDate!,
          ),
        ),
      );
    }

    emis.assignAll(list);
  }
  // void openChangeStatusSheet(BuildContext context, int index) {
  //   selectedStatus.value = emis[index].status;
  //   selectedPayDate.value = emis[index].paidDate;
  // }

  Future<void> pickPayDate(BuildContext context) async {
    final initial = selectedPayDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: initial,
    );

    if (picked != null) selectedPayDate.value = picked;
  }

  void refreshEmiFromDetails() => _buildEmiRows();

  final Map<String, RxBool> commands = {
    'Location': false.obs,
    'Mobile No': false.obs,
    'Lock Device': false.obs,
    // 'Sim Lock': false.obs,
    // 'Offline Lock': false.obs,
    // 'Offline Unlock': false.obs,
    'Offline Location': false.obs,
    // 'Volume': false.obs,
    // 'Wallpaper': false.obs,
    'Audio': false.obs,
    'WhatsApp': false.obs,
    'WA Business': false.obs,
    'Facebook': false.obs,
    'Instagram': false.obs,
    'Arattai': false.obs,
    'YouTube': false.obs,
    'Remove Key': false.obs,
    "Social Media": false.obs,
    // 'Active Restriction': false.obs,
    // 'Deactive Restriction': false.obs,
    'ACTIVE_RESTRICTION': false.obs,
    // 'DEACTIVE_RESTRICTION': false.obs,

    'Scheduler Lock': false.obs,


  };
  // final orderedCommands = [
  //   "Lock Device",
  //   "Location",
  //   "Mobile No",
  //   "Scheduler Lock", // ✅ ADD HERE
  //   "Active Restriction",
  //   "Offline Lock",
  //   "Offline Unlock",
  //   "App Update",
  //
  //   "Audio",
  // ];

  final orderedCommands = [
    "Lock Device",
    "Location",
    "Mobile No",

    // "Scheduler Lock", // hidden temporarily

    "Active Restriction",
    "Offline Lock",
    "Offline Unlock",

    // "App Update", // hidden temporarily

    "Audio",
  ];
  List<String> socialApps = [
    "WhatsApp",
    "WA Business",
    "Facebook",
    "Instagram",
    "YouTube",
    "Arattai",
  ];

  final Map<String, String> displayToInternalCommand = {
    "Lock Device": "Lock Device",
    // "Sim Lock": "Sim Lock",
    "Offline Lock": "Offline Lock",
    "Offline Unlock": "Offline Unlock", // ✅ ADD

    // "Volume": "Volume",
    // "Wallpaper": "Wallpaper",
    "Audio": "Audio",
    "Active Restriction": "ACTIVE_RESTRICTION",
    // "Deactive Restriction": "DEACTIVE_RESTRICTION",
  };
  // List<String> mainCommands = [
  //   "Lock Device",
  //   "Sim Lock",
  //   "Offline Lock",
  //   "Volume",
  //   "Wallpaper",
  //   "Audio",
  //   /// ✅ NEW
  //   "ACTIVE RESTRICTION",
  //   "DEACTIVE RESTRICTION",
  // ];

  bool get isRunningKey => customer.value?.deviceType == "running";

  // late List<String> mainCommands = displayToInternalCommand.keys.toList();
  List<String> get mainCommands {
    final list = displayToInternalCommand.keys.toList();
    //
    // if (!isRunningKey) {
    //   list.remove("Active Restriction");
    //   // list.remove("Deactive Restriction");
    // }

    return list;
  }
  // List<String> specialCommands = [
  //   "Location",
  //   "Mobile No",
  //   "Offline Lock",
  //   "Offline Unlock",
  //   "Remove Key",
  //
  //   "Scheduler Lock",
  //   "App Update",
  //   "Audio", // ✅ ADD THIS
  //
  //
  // ];

  List<String> specialCommands = [
    "Location",
    "Mobile No",
    "Offline Lock",
    "Offline Unlock",
    "Remove Key",

    // "Scheduler Lock", // hidden temporarily
    // "App Update",     // hidden temporarily

    "Audio",
  ];

  final Set<String> noToggleCommands = {'Location', 'Mobile No', 'Remove Key'};
  final RxMap<String, bool> commandLoading = <String, bool>{}.obs;

  bool isCommandLoading(String key) => commandLoading[key] == true;

  String iconFor(String key) {
    return "assets/icons/commands/${key.toLowerCase().replaceAll(' ', '_')}.svg";
  }

  final Map<String, Map<bool, String>> _commandMap = {
    "Location": {true: "GET_LOCATION", false: "GET_LOCATION"},
    "Offline Location": {true: "GET_LOCATION", false: "GET_LOCATION"},
    "Lock Device": {true: "LOCK_DEVICE", false: "UNLOCK_DEVICE"},
    // "Sim Lock": {true: "LOCK_SIM", false: "UNLOCK_SIM"},
    // "Offline Lock": {true: "LOCK_DEVICE", false: "UNLOCK_DEVICE"},
    // "Offline Unlock": {true: "UNLOCK_DEVICE", false: "LOCK_DEVICE"},
    "Mobile No": {true: "GET_MOBILE_NUMBER", false: "GET_MOBILE_NUMBER"},
    // "Volume": {true: "VOLUME_ON", false: "VOLUME_OFF"},
    // "Wallpaper": {true: "CHANGE_WALLPAPER", false: "RESET_WALLPAPER"},
    // "Audio": {true: "RECORD_AUDIO", false: "STOP_AUDIO"},
    "Audio": {true: "PLAY_SOUND", false: "STOP_SOUND"},
    "WhatsApp": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "WA Business": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Facebook": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Instagram": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Arattai": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "YouTube": {true: "APP_BLOCK", false: "APP_UNBLOCK"},

    /// ✅ NEW
    "Remove Key": {true: "UNENROLL_DEVICE", false: "UNENROLL_DEVICE"},
    "Social Media": {
      true: "SOCIALMEDIA_LOCK",
      false: "SOCIALMEDIA_UNLOCK",
    },

    // "ACTIVE_RESTRICTION": {
    //   true: "ACTIVE_RESTRICTION",
    //   false: "DEACTIVE_RESTRICTION",
    // },
    //
    // "DEACTIVE_RESTRICTION": {
    //   true: "DEACTIVE_RESTRICTION",
    //   false: "ACTIVE_RESTRICTION",
    // },
    "ACTIVE_RESTRICTION": {
      true: "ACTIVE_RESTRICTION",
      false: "DEACTIVE_RESTRICTION",
    },
    "Scheduler Lock": {
      true: "SCHEDULER_LOCK",
      false: "SCHEDULER_LOCK",
    },
    "App Update": {
      true: "UPDATE_APP",
      false: "UPDATE_APP",
    },
  };

  final Map<String, String> _packageMap = {
    "WhatsApp": "com.whatsapp",
    "WA Business": "com.whatsapp.w4b",
    "Facebook": "com.facebook.katana",
    "Instagram": "com.instagram.android",
    "YouTube": "com.google.android.youtube",
    "Arattai": "com.arattai",
  };

  final Set<String> comingSoonCommands = {
    "Sim Lock",
    // "Offline Lock",
    "Volume",
    "Wallpaper",
    // "Audio",
  };

  Future<void> onCommandToggle(String key, bool value) async {
    final id = actualDeviceId;

    debugPrint("🟡 TOGGLE CLICKED");
    debugPrint("➡️ Command UI Name : $key");
    debugPrint("➡️ Switch State    : ${value ? "ON" : "OFF"}");
    debugPrint("➡️ Device ID       : $id");

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Device ID missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final map = _commandMap[key];
    if (map == null) {
      debugPrint("❌ NO COMMAND MAP FOUND FOR: $key");
      Get.snackbar(
        "Error",
        "Command mapping not found: $key",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final commandType = map[value];
    debugPrint("➡️ Command Type    : $commandType");

    if (commandType == null || commandType.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Command type missing for $key",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isCommandLoading(key)) return;

    final oldValue = commands[key]?.value ?? false;
    commands[key]?.value = value;
    commandLoading[key] = true;

    try {
      Map<String, dynamic>? payload;

      if (commandType == "APP_BLOCK" || commandType == "APP_UNBLOCK") {
        final pkg = _packageMap[key];
        if (pkg != null && pkg.isNotEmpty) {
          payload = {
            "package_name": pkg,
          };
        }
      }

      final req = DeviceCommandRequest(
        deviceId: id,
        commandType: commandType,
        payload: payload,
      );

      debugPrint("📤 FINAL REQUEST JSON => ${req.toJson()}");

      final resp = await _commandService.sendCommand(req);

      debugPrint("✅ RESPONSE MESSAGE => ${resp.message}");
      debugPrint("✅ RESPONSE SUCCESS => ${resp.success}");
      debugPrint("✅ RESPONSE COMMAND TYPE => ${resp.command?.commandType}");
      debugPrint("✅ RESPONSE DEVICE ID => ${resp.command?.deviceId}");
      debugPrint("✅ RESPONSE STATUS => ${resp.command?.status}");

      if (!resp.success) {
        commands[key]?.value = oldValue;
        Get.snackbar(
          "Error",
          resp.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      box.write(key, value); // ✅ ADD THIS

      Get.snackbar(
        "Success",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      commands[key]?.value = oldValue;
      debugPrint("❌ onCommandToggle ERROR => $e");

      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      commandLoading[key] = false;
    }
  }





  // If you toggle overdue switch in UI call this

  void openChangeStatusSheet(BuildContext context, int index) {
    // prefill
    selectedStatus.value = emis[index].status;
    selectedPayDate.value = emis[index].paidDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => ChangeStatusSheet2(ctrl: this, index: index),
    );
  }

  String _apiStatusFromUi(CustomerDetailV2EmiStatus s) {
    // ✅ UI unpaid => API PENDING (as per your requirement)
    return (s == CustomerDetailV2EmiStatus.paid) ? "PAID" : "PENDING";
  }

  String _toApiPaidAt(DateTime dt) {
    // backend accepts ISO. send UTC ISO string
    return dt.toUtc().toIso8601String();
  }

  Future<void> fetchEmiSchedule() async {
    try {
      final id = customerId.value.trim();

      final res = await ApiClient.dio.get(
        RetailerAPI.getCustomerEmi(id),
      );

      final response =
      EmiScheduleResponse.fromJson(res.data);

      emiSchedule.assignAll(
        response.data?.schedule ?? [],
      );

      _buildEmiRows();
    } catch (e) {
      debugPrint("❌ EMI FETCH ERROR => $e");
    }
  }
  // Future<void> updateEmiFromSheet(int index) async {
  //   if (index < 0 || index >= emis.length) {
  //     Get.snackbar("Error", "Invalid EMI index", snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //
  //   final row = emis[index];
  //   final emiId = row.emiId.trim();
  //   if (emiId.isEmpty) {
  //     Get.snackbar("Error", "EMI ID missing", snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //
  //   // ✅ if marking PAID then paid date must be selected
  //   if (selectedStatus.value == CustomerDetailV2EmiStatus.paid && selectedPayDate.value == null) {
  //     Get.snackbar("Error", "Please choose EMI pay date", snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //
  //   if (isUpdatingEmi.value) return;
  //   isUpdatingEmi.value = true;
  //
  //   try {
  //     // find original overdueAmount from details list (null safe)
  //     final item = details.value?.emi?.list
  //         .firstWhereOrNull((e) => e.id == emiId);
  //
  //     final overdue = addOverdueAmount.value ? (item?.overdueAmount ?? 0) : 0;
  //
  //     final body = <String, dynamic>{
  //       "paymentMode": "CASH", // (future me dropdown se)
  //       "status": _apiStatusFromUi(selectedStatus.value),
  //       "overdueAmount": overdue,
  //       // paidAt only when date selected
  //       if (selectedPayDate.value != null) "paidAt": _toApiPaidAt(selectedPayDate.value!),
  //     };
  //
  //     final resp = await _emiService.updateEmi(emiId: emiId, body: body);
  //
  //     if (resp == null || resp.status != 200) {
  //       Get.snackbar("Error", resp?.message ?? "Failed to update EMI",
  //           snackPosition: SnackPosition.BOTTOM);
  //       return;
  //     }
  //
  //     // ✅ SUCCESS: refresh details (and rebuild EMI list + progress)
  //     await fetchKeyDetails();
  //
  //     Get.snackbar("Success", resp.message, snackPosition: SnackPosition.BOTTOM);
  //   } finally {
  //     isUpdatingEmi.value = false;
  //   }
  // }

  Future<void> updateEmiFromSheet(int index) async {
    if (index < 0 || index >= emis.length) {
      Get.snackbar(
        "Error",
        "Invalid EMI index",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final row = emis[index];

    if (selectedStatus.value == CustomerDetailV2EmiStatus.paid &&
        selectedPayDate.value == null) {
      Get.snackbar(
        "Error",
        "Please choose EMI pay date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isUpdatingEmi.value) return;
    isUpdatingEmi.value = true;

    try {
      final body = <String, dynamic>{
        "id": customerId.value.trim(), // customer id
        "emi_number": row.emiNumber,
        "status": selectedStatus.value ==
            CustomerDetailV2EmiStatus.paid
            ? "paid"
            : "pending", // pending = unpaid

        "paid_amount": row.amount
            .replaceAll("₹", "")
            .replaceAll(",", "")
            .trim(),

        "payment_mode": "cash",
        "transaction_id": "",
      };

      debugPrint("✅ UPDATE EMI BODY => $body");

      final resp = await _emiService.updateEmi(
        body: body,
      );

      if (resp == null) {
        Get.snackbar(
          "Error",
          resp?.message ?? "Failed to update EMI",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      /// Refresh latest EMI schedule
      await fetchEmiSchedule();

      Get.snackbar(
        "Success",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint("❌ UPDATE EMI ERROR => $e");

      Get.snackbar(
        "Error",
        "Failed to update EMI",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdatingEmi.value = false;
    }
  }
  Future<void> fetchKeyDetails() async {
    final k = actualDeviceId.trim();
    if (k.isEmpty) {
      debugPrint("❌ keyId missing for details API");
      return;
    }

    if (isDetailsLoading.value) return;

    isDetailsLoading.value = true;

    try {
      final resp = await _detailsService.getKeyDetails(k);

      if (resp == null || resp.status != 200 || resp.data == null) {
        debugPrint("❌ Failed to load key details");
        details.value = null;
        emis.clear(); // ✅ clear table
        return;
      }

      details.value = resp.data;
      debugPrint("✅ DETAILS LOADED for keyId=$k");

      // ✅ IMPORTANT: Build EMI rows right after details set
      _buildEmiRows();

    } finally {
      isDetailsLoading.value = false;
    }
  }

  Future<void> lockNow() async {
    final id = actualDeviceId;

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Device ID missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLocking.value) return;
    isLocking.value = true;

    try {
      final req = DeviceCommandRequest(
        deviceId: id,
        commandType: "LOCK_DEVICE",
      );

      debugPrint("📤 LOCK REQUEST => ${req.toJson()}");

      final resp = await _commandService.sendCommand(req);

      if (!resp.success) {
        Get.snackbar(
          "Error",
          resp.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        "Success",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLocking.value = false;
    }
  }

  Future<void> unlockNow() async {
    final id = actualDeviceId;

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Device ID missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isUnlocking.value) return;
    isUnlocking.value = true;

    try {
      final req = DeviceCommandRequest(
        deviceId: id,
        commandType: "UNLOCK_DEVICE",
      );

      debugPrint("📤 UNLOCK REQUEST => ${req.toJson()}");

      final resp = await _commandService.sendCommand(req);

      if (!resp.success) {
        Get.snackbar(
          "Error",
          resp.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        "Success",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUnlocking.value = false;
    }
  }

  final isGeneratingAgreement = false.obs;
  final agreementPath = "".obs;



  Future<void> generateAgreementFromCustomerDetail() async {
    if (isGeneratingAgreement.value) return;

    try {
      isGeneratingAgreement.value = true;

      Uint8List? signBytes;

      /// ✅ 1. GET SIGNATURE FROM API
      final signatureUrl = customer.value?.signature ?? "";

      if (signatureUrl.isNotEmpty) {
        try {
          final response = await Dio().get(
            signatureUrl,
            options: Options(responseType: ResponseType.bytes),
          );

          signBytes = Uint8List.fromList(response.data);
        } catch (e) {
          debugPrint("❌ Signature load error: $e");
        }
      }

      /// ❌ अगर signature nahi mila
      if (signBytes == null || signBytes.isEmpty) {
        Get.snackbar(
          "Error",
          "Signature not available",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final pdf = pw.Document();

      String line(String v, {int len = 30}) {
        if (v.trim().isEmpty) return "_" * len;
        return v;
      }

      final now = DateTime.now();
      final dateStr =
          "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

      final logo = pw.MemoryImage(
        (await rootBundle.load('assets/images/lock_pe.png'))
            .buffer
            .asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(28, 30, 28, 30),
          build: (context) => [
            /// 🔹 LOGO
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Image(logo, height: 70),
                  pw.SizedBox(height: 10),
                ],
              ),
            ),

            pw.Text(
              "EMI Device Purchase – Short Terms & Conditions (Locker App Enabled)",
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 10),

            /// ✅ DYNAMIC DATA FROM CONTROLLER
            pw.Text("Retailer: ${line(loanBy)}"),
            pw.SizedBox(height: 4),
            pw.Text("Customer Name: ${line(customerName)}"),
            pw.SizedBox(height: 4),
            pw.Text("Customer Contact No.: ${line(customerPhone)}"),

            pw.SizedBox(height: 12),

            _sectionTitle("1. EMI Agreement"),
            _para("The customer is purchasing the device on an EMI basis and agrees to make all EMI payments on time as per the agreed payment schedule."),

            _sectionTitle("2. Ownership"),
            _para("Ownership of the device shall remain with the retailer until the full EMI amount is paid. Ownership will be transferred to the customer only after complete payment."),

            _sectionTitle("3. Locker App & Device Lock"),
            _para("The device comes with a pre-installed Locker App.\nIn case of late or unpaid EMI, the retailer has the right to lock the device. The device will be unlocked only after pending payments are cleared."),

            _sectionTitle("4. App Permissions"),
            _para("The customer agrees to allow the following permissions required by the Locker App:\n\n"
                "1. Location Access     2. SIM Card Information     3. IMEI / Device ID Access\n\n"
                "These permissions will be used only for payment security, device tracking, and recovery purposes."),

            _sectionTitle("5. App Removal / Tampering"),
            _para("The customer shall not remove, disable, reset, or tamper with the Locker App.\n"
                "Any such action will be treated as a serious violation of this agreement and may result in legal action."),

            _sectionTitle("6. Device Usage Responsibility"),
            _para("Proper use and safety of the device are the customer’s responsibility.\n"
                "The retailer will not be responsible for any damage, misuse, or illegal activity involving the device."),

            _sectionTitle("7. Data, Theft & Reset"),
            _para("The retailer, company, and app developer shall not be responsible for data loss, theft, factory reset, technical issues, or third-party interference."),

            _sectionTitle("8. Repeated Default"),
            _para("In case of repeated EMI defaults, the retailer may:\n"
                "(1) Permanently lock the Device   (2) Repossess the Device   (3) Initiate legal recovery proceedings"),

            _sectionTitle("9. EMI Completion"),
            _para("After full EMI payment:\n"
                "• The device will be fully unlocked\n"
                "• Ownership will be transferred to the customer\n"
                "• The Locker App will be removed upon request"),

            _sectionTitle("10. Legal & Jurisdiction"),
            _para("This agreement shall be governed by the applicable local laws.\n"
                "In case of any dispute, both parties shall first attempt mutual resolution before proceeding with legal action."),

            pw.SizedBox(height: 14),

            pw.Text(
                "Model & OS: ${line(brandModel)} (Android)\nActivated On: $dateStr"),
            pw.SizedBox(height: 10),
            pw.Text("IMEI No: ${line(imei1, len: 20)}"),

            pw.SizedBox(height: 24),

            /// 🔹 SIGNATURE SECTION
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Powered By:"),
                    pw.Image(logo, height: 45),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Customer Signature:"),
                    pw.SizedBox(height: 6),
                    pw.Container(
                      width: 160,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(signBytes!),
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Text("Retailers Signature: _________________________"),

            pw.SizedBox(height: 20),

            pw.Center(
              child: pw.Text(
                "For any queries or support kindly call: 8810422690",
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      );

      /// ✅ SAVE FILE
      final dir = await getExternalStorageDirectory();
      final folder = Directory("${dir!.path}/Agreements");

      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final file =
      File("${folder.path}/Agreement_${now.millisecondsSinceEpoch}.pdf");

      await file.writeAsBytes(await pdf.save());

      Get.snackbar("Success", "Agreement Generated",
          snackPosition: SnackPosition.BOTTOM);

      await OpenFilex.open(file.path);

    } catch (e) {
      debugPrint("❌ PDF Error: $e");

      Get.snackbar("Error", "Agreement generation failed",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGeneratingAgreement.value = false;
    }
  }
  Future<void> sendRemoveKeyCommand() async {

    final id = actualDeviceId.trim();

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Device ID missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isCommandLoading("Remove Key")) return;

    commandLoading["Remove Key"] = true;

    final resp = await _commandService.sendCommand(
      DeviceCommandRequest(
        deviceId: id,
        commandType: "UNENROLL_DEVICE",
        payload: null,
      ),
    );

    commandLoading["Remove Key"] = false;

    if (!resp.success) {
      Get.snackbar(
        "Error",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      "Success",
      resp.message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  Future<void> getLocationCommand() async {

    final id = actualDeviceId.trim();

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Device ID missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isCommandLoading("Remove Key")) return;

    commandLoading["Remove Key"] = true;

    final resp = await _commandService.sendCommand(
      DeviceCommandRequest(
        deviceId: id,
        commandType: "GET_LOCATION",
        payload: null,
      ),
    );

    // ✅ IMPORTANT LINE (YAHI ADD KARNA HAI)
    updateFromApiTime(resp.command?.createdAt);


    commandLoading["Remove Key"] = false;

    if (!resp.success) {
      Get.snackbar(
        "Error",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      "Success",
      resp.message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> sendUpdateAppCommand(DeviceCommandRequest req) async {
    try {
      await _commandService.sendCommand(req);
    } catch (e) {
      debugPrint("❌ UPDATE APP ERROR => $e");
      rethrow;
    }
  }

  // Future<List<String>> fetchSimNumbers() async {
  //   final id = actualDeviceId;
  //
  //   debugPrint("📱 Device ID => $id");
  //
  //   if (id.isEmpty) {
  //     Get.snackbar("Error", "Device ID missing");
  //     return [];
  //   }
  //
  //   try {
  //     /// 🔹 SEND COMMAND
  //     await _commandService.sendCommand(
  //       DeviceCommandRequest(
  //         deviceId: id,
  //         commandType: "GET_NUMBER",
  //       ),
  //     );
  //
  //     /// ⏳ WAIT
  //     await Future.delayed(const Duration(seconds: 3));
  //
  //     final dio = Dio();
  //
  //     final response = await dio.get(
  //       "https://lockpepro.com/api/mdm/devices/$id/sim-info",
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer ${box.read("token")}",
  //           "Accept": "application/json",
  //         },
  //       ),
  //     );
  //
  //     if (response.data is! Map) return [];
  //
  //     final data = response.data;
  //
  //     if (data["success"] != true) return [];
  //
  //     final simInfo = data["current_sim_info"] ?? {};
  //
  //     List<String> numbers = [];
  //
  //     /// 🔥 DYNAMIC SIM PARSER (BEST)
  //     for (int i = 1; i <= 5; i++) {
  //       final key = "sim${i}_number";
  //
  //       if (simInfo.containsKey(key)) {
  //         final value = simInfo[key]?.toString().trim();
  //
  //         if (value != null &&
  //             value.isNotEmpty &&
  //             value != "null") {
  //           numbers.add(value);
  //         }
  //       }
  //     }
  //
  //     debugPrint("📲 NUMBERS => $numbers");
  //
  //     return numbers;
  //   } catch (e) {
  //     debugPrint("❌ ERROR => $e");
  //     return [];
  //   }
  // }

  Future<List<String>> fetchSimNumbers() async {
    final id = actualDeviceId;

    debugPrint("📱 Device ID => $id");

    if (id.isEmpty) {
      Get.snackbar("Error", "Device ID missing");
      return [];
    }

    try {
      /// 🔹 SEND COMMAND
      await _commandService.sendCommand(
        DeviceCommandRequest(
          deviceId: id,
          commandType: "GET_NUMBER",
        ),
      );

      /// ⏳ WAIT
      await Future.delayed(const Duration(seconds: 3));

      final dio = Dio();

      final response = await dio.get(
        "https://lockpepro.com/api/mdm/devices/$id/sim-info",
        options: Options(
          headers: {
            "Authorization": "Bearer ${box.read("token")}",
            "Accept": "application/json",
          },
        ),
      );

      debugPrint("✅ FULL API RESPONSE => ${response.data}");

      if (response.data is! Map) {
        debugPrint("❌ RESPONSE IS NOT MAP");
        return [];
      }

      final data = response.data;

      debugPrint("✅ SUCCESS => ${data["success"]}");

      if (data["success"] != true) {
        debugPrint("❌ API SUCCESS FALSE");
        return [];
      }

      /// 🔥 FIXED KEY
      final simInfo = data["current_sim_info"] ?? {};
      /// 🔥 STORE HISTORY
      simHistory.assignAll(
        List<Map<String, dynamic>>.from(
          data["sim_history"] ?? [],
        ),
      );

      debugPrint(
        "📜 SIM HISTORY COUNT => ${simHistory.length}",
      );

      debugPrint("📲 SIM INFO => $simInfo");

      List<String> numbers = [];

      /// 🔥 DYNAMIC SIM PARSER
      for (int i = 1; i <= 5; i++) {
        final key = "sim${i}_number";

        debugPrint("🔍 CHECKING KEY => $key");

        if (simInfo.containsKey(key)) {
          final value = simInfo[key]?.toString().trim();

          debugPrint("📞 VALUE => $value");

          if (value != null &&
              value.isNotEmpty &&
              value != "null") {
            numbers.add(value);

            debugPrint("✅ ADDED NUMBER => $value");
          }
        }
      }

      debugPrint("📲 FINAL NUMBERS => $numbers");

      return numbers;
    } catch (e) {
      debugPrint("❌ ERROR => $e");
      return [];
    }
  }
  Future<void> scheduleLockApi(String scheduleAt) async {
    try {
      final deviceId = actualDeviceId;

      if (deviceId.isEmpty) {
        debugPrint("❌ DEVICE ID MISSING");
        Get.snackbar("Error", "Device ID missing");
        return;
      }

      final payload = {
        "device_id": deviceId,
        "command_type": "LOCK_DEVICE",
        "schedule_type": "one_time",
        "scheduled_at": scheduleAt,
        "label": "Scheduled Lock",
        "delivery_method": "fcm"
      };

      debugPrint("📤 API URL => https://lockpepro.com/api/scheduled-commands");
      debugPrint("📤 PAYLOAD => $payload");

      final dio = Dio();

      final res = await dio.post(
        "https://lockpepro.com/api/scheduled-commands",
        data: payload,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",

            /// 🔥 IMPORTANT (if auth required)
            "Authorization": "Bearer ${box.read("token")}",
          },
        ),
      );

      debugPrint("✅ STATUS CODE => ${res.statusCode}");
      debugPrint("✅ RESPONSE => ${res.data}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Get.snackbar("Success", "Lock Scheduled Successfully");
        /// ✅ CLOSE POPUP FIRST
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        /// ✅ SMALL DELAY (VERY IMPORTANT)
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.snackbar(
            "Success",
            "Lock scheduled successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        Get.snackbar("Error", "Failed to schedule");
      }
    } catch (e) {
      debugPrint("❌ FULL ERROR => $e");

      if (e is DioException) {
        debugPrint("❌ ERROR DATA => ${e.response?.data}");
        debugPrint("❌ STATUS => ${e.response?.statusCode}");
      }

      Get.snackbar("Error", "Scheduler failed");
    }
  }

  Future<void> sendOfflineCommandApi({
    required String number,
    required bool isLock,
  }) async {
    try {
      final payload = {
        "phone": number,
        "deviceName": brandModel,
      };

      final url = isLock
          ? "/sms/send-lock"
          : "/sms/send-unlock";

      debugPrint("📤 OFFLINE URL => $url");
      debugPrint("📤 BODY => $payload");

      final res = await Dio().post(
        "https://lockpepro.com/api$url",
        data: payload,
      );

      debugPrint("✅ RESPONSE => ${res.data}");

      // Get.snackbar(
      //   "Success",
      //   isLock ? "Device Locked" : "Device Unlocked",
      // );
    } catch (e) {
      debugPrint("❌ OFFLINE ERROR => $e");
      Get.snackbar("Error", "Failed");
    }
  }


  Future<void> handleOfflineCommand(bool isLock) async {
    final id = actualDeviceId;

    debugPrint("🟡 OFFLINE COMMAND CLICKED");
    debugPrint("➡️ Type: ${isLock ? "LOCK" : "UNLOCK"}");
    debugPrint("➡️ Device ID: $id");

    if (id.isEmpty) {
      Get.snackbar("Error", "Device ID missing");
      return;
    }

    // /// 🔹 OPEN UI FIRST
    // Get.find<CustomerDetailV2Page>()
    //     .showOfflineNumberDialog(isLock: isLock);
  }


  Future<void> handleOfflineFlow(bool isLock) async {
    if (actualDeviceId.isEmpty) {
      Get.snackbar("Error", "Device ID missing");
      return;
    }

    List<String> numbers = [];

    try {
      numbers = await fetchSimNumbers();
      debugPrint("📱 SIM => $numbers");
    } catch (e) {
      debugPrint("❌ SIM ERROR => $e");
    }

    // showNumberInputPopup(numbers, isLock);
  }

  Future<bool> sendAudioAlert(String message) async {
    try {

      if (actualDeviceId.isEmpty) {
        Get.snackbar(
          "Error",
          "Device ID missing",
        );
        return false;
      }

      final response = await Dio().post(
        "https://lockpepro.com/api/play-alert",
        data: {
          "device_id": actualDeviceId,
          "message": message,
        },
      );

      debugPrint("✅ AUDIO RESPONSE => ${response.data}");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {

        // Get.snackbar(
        //   "Success",
        //   response.data["message"] ?? "Voice alert sent",
        // );

        return true;
      }

      Get.snackbar(
        "Error",
        response.data["message"] ?? "Failed to send alert",
      );

      return false;

    } catch (e) {

      debugPrint("❌ AUDIO ALERT ERROR => $e");

      Get.snackbar(
        "Error",
        "Something went wrong",
      );

      return false;
    }
  }

  Future<void> viewDoc(String url) async {
    final cleanUrl = url.trim();

    debugPrint("📄 Document Clicked URL => $cleanUrl");

    if (cleanUrl.isEmpty) {
      Get.snackbar(
        "Error",
        "Document URL missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final uri = Uri.parse(cleanUrl);

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );

      if (!launched) {
        Get.snackbar(
          "Error",
          "Unable to open document",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("❌ Document open error => $e");

      Get.snackbar(
        "Error",
        "Invalid document URL",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> downloadAndOpenDoc({
    required String url,
    String? fileName,
    String loadingKey = "agreement",
  }) async {
    Get.snackbar(
      "Info",
      "Agreement not available in this API",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _para(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          fontSize: 11,
          height: 1.4,
        ),
      ),
    );
  }

  void updateFromApiTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      lastUpdatedText.value = "Updated just now";
      return;
    }

    try {
      DateTime parsed = DateTime.parse(createdAt).toLocal();

      String formatted =
      DateFormat("dd MMM yyyy, hh:mm a").format(parsed);

      // 👇 FINAL TEXT (like real apps)
      lastUpdatedText.value = "Updated on $formatted";

      // 🧪 DEBUG PRINT (IMPORTANT)
      print("🕒 API TIME RAW: $createdAt");
      print("🕒 LOCAL TIME: $parsed");
      print("🕒 FORMATTED: $formatted");

    } catch (e) {
      lastUpdatedText.value = "Updated just now";
    }
  }
}
extension _DocType on String {
  String get _cleanUrl => split('?').first;
  String get ext {
    final u = _cleanUrl.toLowerCase();
    final parts = u.split('.');
    return parts.length > 1 ? parts.last : "";
  }

  bool get isPdf => ext == "pdf";
  bool get isDoc => ext == "doc" || ext == "docx";
  bool get isImage => ["png", "jpg", "jpeg", "webp"].contains(ext);
}


