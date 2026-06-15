import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/services/device_location_service.dart';
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

enum CustomerDetailV2EmiStatus { paid, unpaid }

extension CustomerDetailV2EmiStatusX on CustomerDetailV2EmiStatus {
  String get label =>
      this == CustomerDetailV2EmiStatus.paid ? "Paid" : "Unpaid";
}

class CustomerDetailV2EmiRow {
  final String emiId;
  String date;
  String amount;
  CustomerDetailV2EmiStatus status;
  DateTime? paidDate;

  CustomerDetailV2EmiRow({
    required this.emiId,
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


  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  RxString lastUpdatedText = "Updating...".obs;
  Timer? _locationTimer;
  DateTime? _lastFetchTime;

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

  void _buildEmiRows() {
    final emi = customer.value?.emi;
    if (emi == null) {
      emis.clear();
      return;
    }

    final total = emi.tenureMonths ?? 0;
    final paid = emi.totalEmiPaid ?? 0;
    final list = <CustomerDetailV2EmiRow>[];

    for (int i = 0; i < total; i++) {
      final isPaid = i < paid;

      list.add(
        CustomerDetailV2EmiRow(
          emiId: "${customer.value?.id ?? ''}_$i",
          date: _fmtDate(emi.startDate),
          amount: _fmtMoney(emi.emiAmount ?? 0),
          status: isPaid
              ? CustomerDetailV2EmiStatus.paid
              : CustomerDetailV2EmiStatus.unpaid,
        ),
      );
    }

    emis.assignAll(list);
  }

  void openChangeStatusSheet(BuildContext context, int index) {
    selectedStatus.value = emis[index].status;
    selectedPayDate.value = emis[index].paidDate;
  }

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
    'Offline Lock': false.obs,
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

  };
  final orderedCommands = [
    "Lock Device",
    "Location",
    "Mobile No",
    "Active Restriction",
    "Offline Lock",
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
  List<String> specialCommands = [
    "Location",
    "Mobile No",
    "Remove Key",
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
    "Offline Lock": {true: "LOCK_DEVICE", false: "UNLOCK_DEVICE"},
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
    "Offline Lock",
    "Volume",
    "Wallpaper",
    "Audio",
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



  // Future<void> generateAgreementFromCustomerDetail() async {
  //   if (isGeneratingAgreement.value) return;
  //
  //   try {
  //     isGeneratingAgreement.value = true;
  //
  //     // final Uint8List? signBytes = await signatureController.toPngBytes();
  //     //
  //     // if (signBytes == null || signBytes.isEmpty) {
  //     //   Get.snackbar("Error", "Signature required",
  //     //       snackPosition: SnackPosition.BOTTOM);
  //     //   return;
  //     // }
  //     Uint8List? signBytes;
  //
  //     final signatureUrl = customer.value?.signature ?? "";
  //
  //     if (signatureUrl.isNotEmpty) {
  //       try {
  //         final response = await Dio().get(
  //           signatureUrl,
  //           options: Options(responseType: ResponseType.bytes),
  //         );
  //
  //         signBytes = Uint8List.fromList(response.data);
  //       } catch (e) {
  //         debugPrint("❌ Signature load error: $e");
  //       }
  //     }
  //
  //     if (signBytes == null || signBytes.isEmpty) {
  //       Get.snackbar(
  //         "Error",
  //         "Signature not available",
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       return;
  //     }
  //
  //     final pdf = pw.Document();
  //
  //     String line(String v, {int len = 30}) {
  //       if (v.trim().isEmpty) return "_" * len;
  //       return v;
  //     }
  //
  //     final now = DateTime.now();
  //     final dateStr =
  //         "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  //
  //     final logo = pw.MemoryImage(
  //       (await rootBundle.load('assets/images/lock_pe.png'))
  //           .buffer
  //           .asUint8List(),
  //     );
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageFormat: PdfPageFormat.a4,
  //         margin: const pw.EdgeInsets.all(24),
  //         build: (context) => [
  //
  //           /// 🔹 LOGO
  //           pw.Center(child: pw.Image(logo, height: 60)),
  //           pw.SizedBox(height: 10),
  //
  //           pw.Text(
  //             "EMI Device Purchase Agreement",
  //             style: pw.TextStyle(
  //               fontSize: 14,
  //               fontWeight: pw.FontWeight.bold,
  //             ),
  //           ),
  //
  //           pw.SizedBox(height: 12),
  //
  //           /// ✅ REAL DATA FROM CONTROLLER
  //           pw.Text("Customer Name: ${line(customerName)}"),
  //           pw.Text("Mobile: ${line(customerPhone)}"),
  //           pw.Text("Email: ${line(customerEmail)}"),
  //           pw.Text("Loan ID: ${line(loanId)}"),
  //
  //           pw.SizedBox(height: 10),
  //
  //           pw.Text("Device: ${line(brandModel)}"),
  //           pw.Text("IMEI: ${line(imei1)}"),
  //
  //           pw.SizedBox(height: 10),
  //
  //           pw.Text("Loan Amount: ₹ ${loanAmount.toStringAsFixed(0)}"),
  //           pw.Text("EMI Amount: ₹ ${emiAmount.toStringAsFixed(0)}"),
  //           pw.Text("Tenure: $tenure months"),
  //
  //           pw.SizedBox(height: 20),
  //
  //           pw.Text("Agreement Date: $dateStr"),
  //
  //           pw.SizedBox(height: 30),
  //
  //           /// 🔹 SIGNATURE
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Column(
  //                 children: [
  //                   pw.Text("Customer Signature"),
  //                   pw.Container(
  //                     width: 150,
  //                     height: 60,
  //                     child: pw.Image(
  //                       pw.MemoryImage(signBytes!),
  //                       fit: pw.BoxFit.contain,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               pw.Column(
  //                 children: [
  //                   pw.Text("Authorized Signature"),
  //                   pw.SizedBox(height: 60),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     final dir = await getExternalStorageDirectory();
  //     final file = File("${dir!.path}/Agreement_${now.millisecondsSinceEpoch}.pdf");
  //
  //     await file.writeAsBytes(await pdf.save());
  //
  //     Get.snackbar("Success", "Agreement Generated",
  //         snackPosition: SnackPosition.BOTTOM);
  //
  //     await OpenFilex.open(file.path);
  //
  //   } catch (e) {
  //     Get.snackbar("Error", "PDF generation failed",
  //         snackPosition: SnackPosition.BOTTOM);
  //   } finally {
  //     isGeneratingAgreement.value = false;
  //   }
  // }

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

  // void updateLastUpdated(String createdAt) {
  //   try {
  //     DateTime utcTime = DateTime.parse(createdAt);
  //
  //     // Convert to local time (important)
  //     DateTime localTime = utcTime.toLocal();
  //
  //     // Format nicely
  //     String formatted = DateFormat('dd MMM yyyy, hh:mm a').format(localTime);
  //
  //     lastUpdatedText.value = "Updated on $formatted";
  //   } catch (e) {
  //     lastUpdatedText.value = "Updated just now";
  //   }
  // }

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