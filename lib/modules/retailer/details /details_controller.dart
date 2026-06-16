// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:zlock_smart_finance/app/services/device_service.dart';
//
// // ================= CONTROLLER =================
// class DetailsController extends GetxController {
//   var selectedTab = 0.obs; // 0: Customer, 1: Commands, 2: EMI
//
//   // ✅ device info (screen open time pass karna best)
//   // final deviceId = ''.obs; // set from arguments
//   final deviceId = '6968d5fb2fb0f8102ebbc3be'.obs; // set from arguments
//   final isLocking = false.obs;
//   final isUnlocking = false.obs;
//
//   final _deviceService = DeviceService();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // ✅ Expecting: Get.to(DetailsScreen(), arguments: {"deviceId": "..."} );
//     // final args = Get.arguments;
//     // if (args is Map) {
//     //   deviceId.value = (args["deviceId"] ?? "").toString();
//     // }
//
//     debugPrint("📌 DetailsController deviceId: ${deviceId.value}");
//   }
//
//   Future<void> lockNow() async {
//     final id = deviceId.value.trim();
//     if (id.isEmpty) {
//       Get.snackbar("Error", "Device ID missing",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     if (isLocking.value) return;
//
//     isLocking.value = true;
//
//     final resp = await _deviceService.lockDevice(
//       deviceId: id,
//       reason: "EMI overdue for 10 days", // or make dynamic if you want
//     );
//
//     isLocking.value = false;
//
//     if (!resp.success) {
//       Get.snackbar("Error", resp.message,
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     Get.snackbar("Success", resp.message,
//         snackPosition: SnackPosition.BOTTOM);
//   }
//
//   Future<void> unlockNow() async {
//     final id = deviceId.value.trim();
//     if (id.isEmpty) {
//       Get.snackbar("Error", "Device ID missing",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     if (isUnlocking.value) return;
//
//     isUnlocking.value = true;
//
//     final resp = await _deviceService.unlockDevice(
//       deviceId: id,
//       reason: "EMI paid",
//     );
//
//     isUnlocking.value = false;
//
//     if (!resp.success) {
//       Get.snackbar("Error", resp.message,
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     Get.snackbar("Success", resp.message,
//         snackPosition: SnackPosition.BOTTOM);
//   }
//   // Commands toggles
//   // final Map<String, RxBool> commands = {
//   //   'Location': false.obs,
//   //   'Mobile No': false.obs,
//   //   'Lock Device': false.obs,
//   //   'Sim Lock': false.obs,
//   //   'Offline Lock': false.obs,
//   //   'Offline Unlock': false.obs,
//   //   'Offline Location': false.obs,
//   //   // 'Restriction Off': false.obs,
//   //   // 'Restriction On': false.obs,
//   //   // 'Factory Reset': false.obs,
//   //   // 'File Transfer': false.obs,
//   //   'Volume': false.obs,
//   //   // 'Debugging': false.obs,
//   //   // 'Outgoing': false.obs,
//   //   // 'Uninstall App': false.obs,
//   //   'Wallpaper': false.obs,
//   //   'Audio': false.obs,
//   //   'WhatsApp': false.obs,
//   //   'WA Business': false.obs,
//   //   'Facebook': false.obs,
//   //   'Instagram': false.obs,
//   //   'Arattai': false.obs,
//   //   'YouTube': false.obs,
//   // };
//   final Map<String, RxBool> commands = {
//     'Location': false.obs,
//     'Mobile No': false.obs,
//     'Lock Device': false.obs,
//     'Sim Lock': false.obs,
//     'Offline Lock': false.obs,
//     'Offline Unlock': false.obs,
//     'Offline Location': false.obs,
//     'Volume': false.obs,
//     'Wallpaper': false.obs,
//     'Audio': false.obs,
//     'WhatsApp': false.obs,
//     'WA Business': false.obs,
//     'Facebook': false.obs,
//     'Instagram': false.obs,
//     'Arattai': false.obs,
//     'YouTube': false.obs,
//   };
//
//   // String iconFor(String key) {
//   //   return "assets/icons/commands/${key.toLowerCase().replaceAll(' ', '_')}.svg";
//   // }
//
//   String iconFor(String key) {
//     final path = "assets/icons/commands/${key.toLowerCase().replaceAll(' ', '_')}.svg";
//     debugPrint("ICON PATH => $key : $path");
//     return path;
//   }
//
// }
//

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/services/device_command_service.dart';
import 'package:zlock_smart_finance/app/services/device_service.dart';
import 'package:zlock_smart_finance/app/services/key_details_service.dart';
import 'package:zlock_smart_finance/app/services/remove_key_api_service.dart';
import 'package:zlock_smart_finance/app/services/update_emi_service.dart';
import 'package:zlock_smart_finance/app/utils/change_emi_status_bottom.dart';
import 'package:zlock_smart_finance/model/device_command_model.dart';
import 'package:zlock_smart_finance/model/key_details_response.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/dashboard_retailer.dart';
import 'package:zlock_smart_finance/modules/retailer/edit_key/edit_key.dart';

// ================= CONTROLLER =================
class DetailsController extends GetxController {
  var selectedTab = 0.obs; // 0: Customer, 1: Commands, 2: EMI

  // final deviceId = '6968d5fb2fb0f8102ebbc3be'.obs; // set from arguments
  final keyId = ''.obs;     // ✅ for details api
  final deviceId = ''.obs;  // ✅ for commands/lock/unlock

  final isLocking = false.obs;
  final isUnlocking = false.obs;

  final _deviceService = DeviceService();

  final autoLock = false.obs;
  final addOverdueAmount = true.obs;

  // ✅ Details data
  final isDetailsLoading = false.obs;
  final details = Rxn<KeyDetailsData>();

  final _detailsService = KeyDetailsService();

  final _emiService = EmiService();
  final isUpdatingEmi = false.obs; // optional loader


  @override
  void onInit() {
    super.onInit();

    // ✅ Expecting: Get.to(DetailsScreen(), arguments: {"deviceId": "..."} );
    // final args = Get.arguments;
    // if (args is Map) {
    //   deviceId.value = (args["deviceId"] ?? "").toString();
    // }
    //

    final args = Get.arguments;
    debugPrint("📥 DetailsController args => $args");

    if (args is Map) {
      keyId.value = (args["keyId"] ?? "").toString();
      deviceId.value = (args["deviceId"] ?? "").toString();
    }

    debugPrint("📌 DetailsController keyId: ${keyId.value}");
    debugPrint("📌 DetailsController deviceId: ${deviceId.value}");

    fetchKeyDetails(); // ✅ auto call

    debugPrint("📌 DetailsController deviceId: ${deviceId.value}");

  }

  Future<void> fetchKeyDetails() async {
    final k = keyId.value.trim();
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

  // ✅ convenience getters (UI clean)
  String? get productImage {
    final images = details.value?.device?.productImage;
    if (images is List && images!.isNotEmpty) {
      return images.first.toString().trim();
    }
    return null;
  }

  // String get productImage => details.value?.device?.productImage ?? "-";
  String get customerName => details.value?.customer?.fullName ?? "-";
  String get customerPhone => details.value?.customer?.phone ?? "-";
  String get deviceStatus => details.value?.device?.status ?? "-";
  String get brandModel => details.value?.device?.brandModel ?? "-";
  String get imei1 => details.value?.device?.imei1 ?? "-";

  // EMI Section
  String get loanId => details.value?.loan?.id ?? "-";
  double get productPrice => details.value?.loan?.productPrice ?? 0;
  double get downPayment => details.value?.loan?.downPayment ?? 0;
  String get downPaymentDate => details.value?.loan?.createdAt ?? "-";
  double get loanAmount => details.value?.loan?.balancePayment ?? 0;
  String get loanBy => details.value?.keyInfo?.loanProvider?? "";
  int get tenure => details.value?.loan?.tenureMonths ?? 0;
  double get processingFee => details.value?.loan?.processingFee ?? 0;
  double get emiAmount => details.value?.loan?.emiAmount ?? 0;
  String get firstEmiDate => details.value?.loan?.loanStartDate ?? "-";
  String get guarantorName => details.value?.customer?.phone ?? "-";

  double get progressPercentage =>
      details.value?.emi?.progress?.percentage.toDouble() ?? 0.0;

  /// 🔹 LinearProgressIndicator value (0.0 – 1.0)
  double get progress {
    final p = progressPercentage;
    if (p <= 0) return 0.0;
    if (p <= 1) return p;        // API sends 0–1
    return (p / 100).clamp(0.0, 1.0); // API sends 0–100
  }

  int get paidEmi =>
      details.value?.emi?.progress?.paidEmi ?? 0;

  int get totalEmi =>
      details.value?.emi?.progress?.totalEmi ?? 0;
  bool get isActiveDevice {
    final s = (details.value?.device?.status ?? "").toUpperCase();
    return s == "ACTIVE" || s == "RUNNING";
  }


  final emis = <EmiRowModel>[].obs;

  // ✅ formatters
  final _dateFmt = DateFormat('dd/MM/yy'); // screenshot format
  final _moneyFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  String _fmtDate(String iso, {String fallback = "-"}) {
    if (iso.trim().isEmpty || iso == "-") return fallback;
    try {
      return _dateFmt.format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return fallback;
    }
  }

  String _fmtMoney(num v) => _moneyFmt.format(v);

  EmiStatus _mapStatus(String apiStatus) {
    final s = apiStatus.toUpperCase().trim();
    if (s == "PAID") return EmiStatus.paid;
    // ✅ PENDING => Unpaid (and any unknown => Unpaid)
    return EmiStatus.unpaid;
  }

  void _buildEmiRows() {
    final list = details.value?.emi?.list ?? <EmiItem>[];

    emis.assignAll(
      list.map((item) {
        // ✅ overdue include only if toggle ON (no UI change)
        final total = addOverdueAmount.value
            ? (item.amount + item.overdueAmount)
            : item.amount;

        return EmiRowModel(
          emiId: item.id,
          date: _fmtDate(item.dueDate),
          amount: _fmtMoney(total),
          status: _mapStatus(item.status),
        );
      }).toList(),
    );
  }

  // If you toggle overdue switch in UI call this
  void refreshEmiFromDetails() => _buildEmiRows();

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
      builder: (_) => ChangeStatusSheet(ctrl: this, index: index),
    );
  }

  String _apiStatusFromUi(EmiStatus s) {
    // ✅ UI unpaid => API PENDING (as per your requirement)
    return (s == EmiStatus.paid) ? "PAID" : "PENDING";
  }

  String _toApiPaidAt(DateTime dt) {
    // backend accepts ISO. send UTC ISO string
    return dt.toUtc().toIso8601String();
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
  //   if (selectedStatus.value == EmiStatus.paid && selectedPayDate.value == null) {
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

  Future<void> lockNow() async {
    final id = deviceId.value.trim();
    if (id.isEmpty) {
      Get.snackbar("Error", "Device ID missing",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isLocking.value) return;

    isLocking.value = true;

    final resp = await _deviceService.lockDevice(
      deviceId: id,
      reason: "EMI overdue for 10 days", // or make dynamic if you want
    );

    isLocking.value = false;

    if (!resp.success) {
      Get.snackbar("Error", resp.message,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar("Success", resp.message,
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> unlockNow() async {
    final id = deviceId.value.trim();
    if (id.isEmpty) {
      Get.snackbar("Error", "Device ID missing",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isUnlocking.value) return;

    isUnlocking.value = true;

    final resp = await _deviceService.unlockDevice(
      deviceId: id,
      reason: "EMI paid",
    );

    isUnlocking.value = false;

    if (!resp.success) {
      Get.snackbar("Error", resp.message,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar("Success", resp.message,
        snackPosition: SnackPosition.BOTTOM);
  }

  // ✅ per-command loader (so user spam na kare)
  final RxMap<String, bool> commandLoading = <String, bool>{}.obs;

  final _commandService = DeviceCommandService();

  // UI commands (same as your list)
  final Map<String, RxBool> commands = {
    'Location': false.obs,
    'Mobile No': false.obs,
    'Lock Device': false.obs,
    'Sim Lock': false.obs,
    'Offline Lock': false.obs,
    'Offline Unlock': false.obs,
    'Offline Location': false.obs,
    'Volume': false.obs,
    'Wallpaper': false.obs,
    'Audio': false.obs,
    'WhatsApp': false.obs,
    'WA Business': false.obs,
    'Facebook': false.obs,
    'Instagram': false.obs,
    'Arattai': false.obs,
    'YouTube': false.obs,

    'Remove Key': false.obs,

  };

  // final Set<String> noToggleCommands = {'Location', 'Mobile No'};
  final Set<String> noToggleCommands = {'Location', 'Mobile No', 'Remove Key'};

  // UI key -> API (ON/OFF)
  // IMPORTANT: commandType.
  final Map<String, Map<bool, String>> _commandMap = {
    "Location": {true: "LOCATION_ON", false: "LOCATION_OFF"},
    "Offline Location": {true: "OFFLINE_LOCATION_ON", false: "OFFLINE_LOCATION_OFF"},
    "Offline Lock": {true: "OFFLINE_LOCK", false: "OFFLINE_UNLOCK"}, // if backend supports
    "Offline Unlock": {true: "OFFLINE_UNLOCK", false: "OFFLINE_LOCK"}, // optional
    "Lock Device": {true: "DEVICE_LOCK", false: "DEVICE_UNLOCK"},
    "Sim Lock": {true: "SIM_LOCK", false: "SIM_UNLOCK"},
    "Mobile No": {true: "MOBILE_NO_ON", false: "MOBILE_NO_OFF"},
    "Volume": {true: "VOLUME_ON", false: "VOLUME_OFF"},
    "Wallpaper": {true: "WALLPAPER_ON", false: "WALLPAPER_OFF"},
    "Audio": {true: "AUDIO_ON", false: "AUDIO_OFF"},

    // Social apps (example) - agar backend APP_BLOCK style use karta hai:
    "WhatsApp": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "WA Business": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Facebook": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Instagram": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "Arattai": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
    "YouTube": {true: "APP_BLOCK", false: "APP_UNBLOCK"},
  };

  //  for APP_BLOCK payload packageName mapping (only for those commands)
  final Map<String, String> _packageMap = {
    "WhatsApp": "com.whatsapp",
    "WA Business": "com.whatsapp.w4b",
    "Facebook": "com.facebook.katana",
    "Instagram": "com.instagram.android",
    "YouTube": "com.google.android.youtube",
    "Arattai": "com.arattai", // confirm real package
  };


  bool isCommandLoading(String key) => commandLoading[key] == true;

  Future<void> onCommandToggle(String key, bool value) async {
    final id = deviceId.value.trim();

    print("🟡 TOGGLE CLICKED");
    print("➡️ Command UI Name : $key");
    print("➡️ Switch State   : ${value ? "ON" : "OFF"}");
    print("➡️ Device ID      : $id");

    if (id.isEmpty) {
      Get.snackbar("Error", "Device ID missing",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final map = _commandMap[key];
    if (map == null) {
      print("❌ NO COMMAND MAP FOUND FOR $key");
      Get.snackbar("Error", "Command mapping not found: $key",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final commandType = map[value];

    print("➡️ API CommandType : $commandType");

    if (commandType == null || commandType.trim().isEmpty) {
      Get.snackbar("Error", "CommandType not set for $key",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isCommandLoading(key)) return;

    final old = commands[key]?.value ?? false;
    commands[key]?.value = value;

    commandLoading[key] = true;

    // Payload if APP_BLOCK / APP_UNBLOCK
    Map<String, dynamic>? payload;
    if (commandType == "APP_BLOCK" || commandType == "APP_UNBLOCK") {
      final pkg = _packageMap[key];
      payload = {"packageName": pkg};

      print("➡️ Payload Sent    : $payload");
    }

    print("📤 FINAL REQUEST JSON:");
    print({
      "deviceId": id,
      "commandType": commandType,
      "payload": payload
    });

    final resp = await _commandService.sendCommand(
      DeviceCommandRequest(
        deviceId: id,
        commandType: commandType,
        payload: payload,
      ),
    );

    commandLoading[key] = false;

    if (!resp.success) {
      commands[key]?.value = old;

      print("❌ API FAILED : ${resp.message}");

      Get.snackbar("Error", resp.message,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    print("✅ API SUCCESS : ${resp.message}");

    Get.snackbar("Success", resp.message,
        snackPosition: SnackPosition.BOTTOM);
  }

  String iconFor(String key) {
    final path = "assets/icons/commands/${key.toLowerCase().replaceAll(' ', '_')}.svg";
    debugPrint("ICON PATH => $key : $path");
    return path;
  }

  final _removeKeyService = RemoveKeyService();

  Future<void> confirmAndRemoveKey() async {
    final keyDocId = details.value?.keyInfo?.id.trim() ?? ""; // ✅ Mongo _id
    if (keyDocId.isEmpty) {
      Get.snackbar("Error", "Key _id missing", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Remove Key?"),
        content: const Text("This action will remove the key. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Remove"),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (ok != true) return;

    if (commandLoading["Remove Key"] == true) return;
    commandLoading["Remove Key"] = true;

    try {
      final resp = await _removeKeyService.removeKey(keyDocId: keyDocId);

      if (resp.status != 200) {
        Get.snackbar("Error", resp.message ?? "Remove key failed",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.snackbar("Success", resp.message ?? "Key removed",
          snackPosition: SnackPosition.BOTTOM);

      // ✅ back / refresh (choose one)
      Get.back(); // details screen close
      // OR: await fetchKeyDetails();  // if backend still returns something
    } finally {
      commandLoading["Remove Key"] = false;
    }
  }
  // bottom sheet temp state
  final selectedStatus = EmiStatus.unpaid.obs;
  final selectedPayDate = Rxn<DateTime>();

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

  void applyChange(int index) {
    final item = emis[index];
    item.status = selectedStatus.value;
    item.paidDate = selectedPayDate.value;

    // ✅ trigger UI update
    emis[index] = item;
  }

  void openEditKey() {
    final d = details.value;
    if (d == null) {
      Get.snackbar("Error", "Details not loaded", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // ✅ Decide entry based on device type / key type (adjust if your API differs)
    final deviceTypeStr = (d.device?.status ?? d.device?.status ?? "").toString().toUpperCase();
    final keyTypeStr = (d.keyInfo?.status ?? "").toString().toUpperCase();

    NewKeyEntry entry;

    // Example mapping (adjust to your data)
    if (deviceTypeStr.contains("IPHONE") || deviceTypeStr.contains("IOS")) {
      entry = NewKeyEntry.iphone;
    } else if (keyTypeStr.contains("RUNNING")) {
      entry = NewKeyEntry.running;
    } else {
      entry = NewKeyEntry.android;
    }

    Get.to(
          () => EditKeyScreen(
        title: entry == NewKeyEntry.iphone
            ? "Edit iPhone Key"
            : entry == NewKeyEntry.running
            ? "Edit Running Key"
            : "Edit Android Key",
        entry: entry,
        keyId: keyId.value,
        deviceId: deviceId.value,
      ),
      arguments: {
        "entry": entry,
        "keyId": keyId.value,
        "deviceId": deviceId.value,
        "details": d, // ✅ pass full object for prefill
      },
    );
  }


  // ✅ per-document loader (no UI impact)
  final RxMap<String, bool> docLoading = <String, bool>{}.obs;
  bool isDocLoading(String key) => docLoading[key] == true;

  /// ✅ Agreement URL getter (safe)
  String get agreementUrl =>
      details.value?.documents?.purchaseAgreement.toString().trim() ?? "";

  /// ✅ Generic open in browser (works for pdf/doc/image)
  Future<void> viewDoc(String url) async {
    final u = url.trim();
    if (u.isEmpty) {
      Get.snackbar("Error", "Document URL missing", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final uri = Uri.tryParse(u);
    if (uri == null) {
      Get.snackbar("Error", "Invalid document URL", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar("Error", "Unable to open document", snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// ✅ Download + open (pdf/doc/image) with correct name
  Future<void> downloadAndOpenDoc({
    required String url,
    String? fileName,
    String loadingKey = "agreement",
  }) async {
    final u = url.trim();
    if (u.isEmpty) {
      Get.snackbar("Error", "Document URL missing", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isDocLoading(loadingKey)) return;
    docLoading[loadingKey] = true;

    try {
      final uri = Uri.tryParse(u);
      if (uri == null) {
        Get.snackbar("Error", "Invalid document URL", snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // ✅ safer storage: app documents directory (no permission needed mostly)
      final dir = await getApplicationDocumentsDirectory();

      // ✅ decide extension
      final ext = u.ext.isNotEmpty ? u.ext : "file";

      // ✅ filename (use passed name else from url)
      String name = (fileName ?? "").trim();
      if (name.isEmpty) {
        final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "document.$ext";
        name = last;
      }

      // ensure extension exists
      if (!name.toLowerCase().contains('.')) {
        name = "$name.$ext";
      }

      // ✅ avoid weird chars
      name = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), "_");

      final savePath = "${dir.path}/$name";

      final dio = Dio();
      await dio.download(
        u,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      // ✅ open file after download
      final result = await OpenFilex.open(savePath);

      // If open fails, fallback to browser
      if (result.type != ResultType.done) {
        await viewDoc(u);
      }
    } catch (e) {
      Get.snackbar("Error", "Download failed", snackPosition: SnackPosition.BOTTOM);
      // fallback open in browser
      await viewDoc(u);
    } finally {
      docLoading[loadingKey] = false;
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
enum EmiStatus { paid, unpaid }

extension EmiStatusX on EmiStatus {
  String get label => this == EmiStatus.paid ? "Paid" : "Unpaid";
}

class EmiRowModel {
  final String emiId; // ✅ NEW
  String date;            // due date (table)
  String amount;
  EmiStatus status;
  DateTime? paidDate;     // sheet se select

  EmiRowModel({
    required this.emiId,
    required this.date,
    required this.amount,
    required this.status,
    this.paidDate,
  });
}

