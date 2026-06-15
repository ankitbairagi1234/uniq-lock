import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/services/retailer_dashboard_service.dart';
import 'package:zlock_smart_finance/model/user_model.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_response.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_service.dart';
import 'package:zlock_smart_finance/modules/retailer/qr_code/qr_dialog_helper.dart';

class CustomerListingV2Controller extends GetxController {
  final selectedPlatform = 0.obs;
  final selectedStatus = UserStatus.active.obs;

  String type = "active";
  int keyType = 0;
  String deviceType = "ANDROID";
  int today = 0;

  final search = ''.obs;

  final users = <UserModel>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  int _page = 1;
  final int _limit = 10;
  int _total = 0;

  final _service = CustomerListingV2Service();
  Timer? _debounce;

  bool _statusListenerReady = false;
  bool _platformListenerReady = false;

  final isDashboardLoading = false.obs;

  // final _profileService = ProfileService();
  final _dashboardService = RetailerDashboardService();


  Future<void> fetchRetailerDashboardQR() async {
    isDashboardLoading.value = true;

    final resp = await _dashboardService.getRetailerDashboard();

    isDashboardLoading.value = false;

    if (resp == null || resp.success != true || resp.data == null) {
      debugPrint("❌ Failed to load dashboard stats: ${resp?.message}");
      return;
    }

    final d = resp.data!;

    // ✅ pick QR data from dashboard response
    final qrUrl =
        d.qrCodeRecord?.qrImageUrl ??
            d.homeQR?.qrImageUrl ??
            "";

    final label =
        d.qrCodeRecord?.qrLabel ??
            d.homeQR?.qrLabel ??
            "QR";

    final enrollLink =
        d.qrCodeRecord?.enrollmentLink ??
            d.homeQR?.enrollmentLink ??
            "";

    if (qrUrl.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 200), () {
        QrDialogHelper.openFromDashboard(
          qrImageUrl: qrUrl,
          qrLabel: label,
          enrollmentLink: enrollLink,
        );
      });
    }

  }

  Future<void> openUserQr(UserModel u) async {

    debugPrint("📌 QR Requested For User");
    debugPrint("KeyId: ${u.keyId}");
    debugPrint("DeviceId: ${u.deviceId}");
    debugPrint("DeviceType: ${u.deviceType}");

    isDashboardLoading.value = true;

    final resp = await _dashboardService.getRetailerDashboard();

    isDashboardLoading.value = false;

    if (resp == null || resp.success != true || resp.data == null) {
      debugPrint("❌ Failed to load dashboard stats: ${resp?.message}");
      return;
    }

    final d = resp.data!;

    String qrUrl = "";
    String label = "";
    String enrollLink = "";

    /// ✅ RUNNING KEY QR
    if (u.deviceType.toUpperCase() == "RUNNING") {

      debugPrint("🟢 RUNNING KEY QR OPEN");

      qrUrl = d.homeQR?.qrImageUrl ?? "";
      // label = d.homeQR?.qrLabel ?? "Running QR";
      label = u.keyId ?? "Running QR";
      enrollLink = d.homeQR?.enrollmentLink ?? "";

    }

    /// ✅ NEW KEY QR
    else if (u.deviceType.toUpperCase() == "NEW") {

      debugPrint("🔵 NEW KEY QR OPEN");

      qrUrl = d.qrCodeRecord?.qrImageUrl ?? "";
      // label = d.qrCodeRecord?.qrLabel ?? "New Key QR";
      label = u.keyId ?? "New Key QR";
      enrollLink = d.qrCodeRecord?.enrollmentLink ?? "";

    }

    else {

      debugPrint("🟡 UNKNOWN DEVICE TYPE → fallback QR");

      qrUrl = d.qrCodeRecord?.qrImageUrl ??
          d.homeQR?.qrImageUrl ??
          "";
      label = u.keyId ?? "QR";
      label = "QR";
    }

    debugPrint("📌 Final QR URL: $qrUrl");

    if (qrUrl.isNotEmpty) {

      Future.delayed(const Duration(milliseconds: 200), () {

        QrDialogHelper.openFromDashboard(
          qrImageUrl: qrUrl,
          qrLabel: label,
          enrollmentLink: enrollLink,
        );

      });

    } else {

      debugPrint("❌ QR URL EMPTY");

    }
  }

  Future<void> refreshList() async {
    _page = 1; // 🔥 IMPORTANT
    users.clear();

    await fetchFirstPage(); // ✅ correct API call
  }
  @override
  void onInit() {
    super.onInit();

    // final args = Get.arguments;
    // debugPrint("📌 CustomerListingV2Controller args => $args");
    //
    // if (args is Map) {
    //   type = (args["type"] ?? "ACTIVE").toString().toUpperCase();
    //   deviceType = (args["deviceType"] ?? "ANDROID").toString().toUpperCase();
    //   today = int.tryParse((args["today"] ?? 0).toString()) ?? 0;
    // }
    final args = Get.arguments;

    if (args is Map) {
      type = (args["type"] ?? "active").toString().toLowerCase();
      // ✅ NEW: if total user
      if (type == "all") {
        type = ""; // ya null bhejna ho to empty string best
      }

      // keyType = int.tryParse(args["key_type"].toString()) ?? 1;
      if (args["key_type"] != null) {
        keyType = int.tryParse(args["key_type"].toString()) ?? 0;
      }
      today = int.tryParse((args["today"] ?? 0).toString()) ?? 0;

    }
    // final args = Get.arguments;
    //
    // if (args is Map) {
    //   type = (args["statusType"] ?? "active").toString().toLowerCase();
    //   keyType = int.tryParse(args["key_type"]?.toString() ?? "1") ?? 1;
    //   today = int.tryParse((args["today"] ?? 0).toString()) ?? 0;
    // }



    selectedPlatform.value = (deviceType == "IPHONE") ? 1 : 0;
    selectedStatus.value = _uiStatusFromApi(type);

    ever(selectedPlatform, (_) {
      if (!_platformListenerReady) return;
      final newDevice = (selectedPlatform.value == 1) ? "IPHONE" : "ANDROID";
      if (deviceType == newDevice) return;
      deviceType = newDevice;
      fetchFirstPage();
    });

    ever(selectedStatus, (_) {
      if (!_statusListenerReady) return;
      final newType = _apiStatusFromUi(selectedStatus.value);
      if (type == newType) return;
      type = newType;
      fetchFirstPage();
    });

    _platformListenerReady = true;
    _statusListenerReady = true;

    ever(search, (_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        fetchFirstPage();
      });
    });

    fetchFirstPage();
  }

  // String _apiStatusFromUi(UserStatus s) {
  //   switch (s) {
  //     case UserStatus.active:
  //       return "ACTIVE";
  //     case UserStatus.locked:
  //       return "LOCKED";
  //     case UserStatus.removed:
  //       return "REMOVED";
  //     case UserStatus.pending:
  //       return "PENDING";
  //   }
  // }

  String _apiStatusFromUi(UserStatus s) {
    switch (s) {
      case UserStatus.active:
        return "active";
      case UserStatus.locked:
        return "lock";   // 🔥 IMPORTANT
      case UserStatus.removed:
        return "removed";
      case UserStatus.pending:
        return "pending";
    }
  }

  UserStatus _uiStatusFromApi(String s) {
    switch (s.toUpperCase()) {
      case "LOCK":
        return UserStatus.locked;
      case "REMOVED":
        return UserStatus.removed;
      case "PENDING":
        return UserStatus.pending;
      case "ACTIVE":
      default:
        return UserStatus.active;
    }
  }

  UserStatus _mapToUiStatus(CustomerListingV2Item item) {
    if ((item.deletedAt ?? "").isNotEmpty) return UserStatus.removed;
    if (!item.isActive) return UserStatus.locked;
    if (item.kycStatus.toLowerCase() == "pending") return UserStatus.pending;
    return UserStatus.active;
  }

  bool _matchesDevice(CustomerListingV2Item item) {
    final raw = item.deviceType.toLowerCase();

    if (deviceType == "ANDROID") {
      return raw == "new";
    }
    if (deviceType == "RUNNING") {
      return raw == "running";
    }
    if (deviceType == "IPHONE") {
      return raw == "iphone" || raw == "ios";
    }
    return true;
  }

  bool _matchesToday(CustomerListingV2Item item) {
    if (today != 1) return true;
    if (item.createdAt.isEmpty) return false;

    final dt = DateTime.tryParse(item.createdAt);
    if (dt == null) return false;

    final local = dt.toLocal();
    final now = DateTime.now();

    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  bool _matchesStatus(CustomerListingV2Item item) {
    final uiStatus = _mapToUiStatus(item);

    switch (type) {
      case "LOCK":
        return uiStatus == UserStatus.locked;
      case "REMOVED":
        return uiStatus == UserStatus.removed;
      case "PENDING":
        return uiStatus == UserStatus.pending;
      case "ACTIVE":
      default:
        return uiStatus == UserStatus.active || uiStatus == UserStatus.pending;
    }
  }

  List<UserModel> _mapAndFilter(List<CustomerListingV2Item> items) {
    final filtered = items.where((item) {
      return _matchesDevice(item) &&
          _matchesToday(item) &&
          _matchesStatus(item);
    }).toList();

    return filtered.map((d) {
      final uiStatus = _mapToUiStatus(d);

      return UserModel(
        keyId: d.keyType?.isNotEmpty == true ? d.keyType! : d.id,
        deviceId: d.id,
        deviceType: d.deviceType.toUpperCase(),
        // productImage: d.profileImage.isNotEmpty ? [d.profileImage] : [],
        productImage: (d.profileImage?.isNotEmpty == true) ? [d.profileImage!] : [],
        name: d.name,
        mobile: d.phone,
        imei: d.imei1,
        loanBy: (d.loanBy?.isNotEmpty == true)
            ? d.loanBy!
            : (d.emi?.loanProvider?.isNotEmpty == true ? d.emi!.loanProvider! : "-"),
        brand: d.deviceType,
        emi: d.emi?.status ?? "-",
        time: d.createdAt,
        status: uiStatus,
        createdDate: d.createdAt,
        signatureImage: d.signature,
        imei2: d.imei2,


      );
    }).toList();
  }

  // Future<void> fetchFirstPage() async {
  //   if (isLoading.value) return;
  //
  //   isLoading.value = true;
  //   isLoadingMore.value = false;
  //   hasMore.value = true;
  //   _page = 1;
  //   users.clear();
  //
  //   try {
  //     final resp = await _service.getCustomers(
  //       page: _page,
  //       limit: _limit,
  //       search: search.value,
  //     );
  //
  //     if (resp == null || !resp.success) {
  //       debugPrint("❌ CUSTOMER LIST V2 first page failed");
  //       return;
  //     }
  //
  //     _total = resp.total;
  //     final mapped = _mapAndFilter(resp.data);
  //
  //     users.assignAll(mapped);
  //     hasMore.value = resp.currentPage < resp.totalPages;
  //
  //     debugPrint(
  //       "✅ CUSTOMER LIST V2 FIRST PAGE: got=${users.length} total=$_total hasMore=${hasMore.value}",
  //     );
  //   } catch (e) {
  //     debugPrint("❌ CUSTOMER LIST V2 FIRST PAGE ERROR: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  // Future<void> loadMore() async {
  //   if (!hasMore.value) return;
  //   if (isLoading.value || isLoadingMore.value) return;
  //
  //   isLoadingMore.value = true;
  //
  //   try {
  //     final nextPage = _page + 1;
  //
  //     final resp = await _service.getCustomers(
  //       page: nextPage,
  //       limit: _limit,
  //       search: search.value,
  //     );
  //
  //     if (resp == null || !resp.success) {
  //       debugPrint("❌ CUSTOMER LIST V2 loadMore failed");
  //       return;
  //     }
  //
  //     final mapped = _mapAndFilter(resp.data);
  //
  //     users.addAll(mapped);
  //     _page = nextPage;
  //     _total = resp.total;
  //     hasMore.value = resp.currentPage < resp.totalPages;
  //
  //     debugPrint(
  //       "✅ CUSTOMER LIST V2 LOAD MORE: page=$_page added=${mapped.length} totalNow=${users.length}",
  //     );
  //   } catch (e) {
  //     debugPrint("❌ CUSTOMER LIST V2 LOAD MORE ERROR: $e");
  //   } finally {
  //     isLoadingMore.value = false;
  //   }
  // }

  Future<void> fetchFirstPage() async {
    if (isLoading.value) return;

    isLoading.value = true;
    isLoadingMore.value = false;
    hasMore.value = true;
    _page = 1;
    users.clear();

    try {
      final resp = await _service.getCustomers(
        page: _page,
        limit: _limit,
        search: search.value,
        // type: type,
        type: type.isEmpty ? null : type, // ✅ KEY FIX
        keyType: keyType,
      );

      if (resp == null || !resp.success) {
        debugPrint("❌ CUSTOMER LIST V2 first page failed");
        return;
      }

      _total = resp.total;

      final mapped = _mapOnly(resp.data); // ✅ changed

      users.assignAll(mapped);
      // hasMore.value = resp.currentPage < resp.totalPages;
      hasMore.value = users.length < resp.total;

      debugPrint(
        "✅ CUSTOMER LIST V2 FIRST PAGE: got=${users.length} total=$_total hasMore=${hasMore.value}",
      );
    } catch (e) {
      debugPrint("❌ CUSTOMER LIST V2 FIRST PAGE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    if (isLoading.value || isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;

      final resp = await _service.getCustomers(
        page: nextPage,
        limit: _limit,
        search: search.value,
        // type: type,
        type: type.isEmpty ? null : type, // ✅ FIX
        keyType: keyType,
      );

      if (resp == null || !resp.success) {
        debugPrint("❌ CUSTOMER LIST V2 loadMore failed");
        return;
      }

      final mapped = _mapOnly(resp.data); // ✅ changed

      users.addAll(mapped);
      _page = nextPage;
      _total = resp.total;
      // hasMore.value = resp.currentPage < resp.totalPages;
      hasMore.value = users.length < resp.total;

      debugPrint(
        "✅ CUSTOMER LIST V2 LOAD MORE: page=$_page added=${mapped.length} totalNow=${users.length}",
      );
    } catch (e) {
      debugPrint("❌ CUSTOMER LIST V2 LOAD MORE ERROR: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  List<UserModel> get filteredUsers => users;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
  // List<UserModel> _mapOnly(List<CustomerListingV2Item> items) {
  //
  //   return items.map((d) {
  //     return UserModel(
  //       keyId: d.keyType?.isNotEmpty == true ? d.keyType! : d.id,
  //       deviceId: d.id,
  //       deviceType: d.deviceType.toUpperCase(),
  //       productImage: (d.profileImage?.isNotEmpty == true)
  //           ? [d.profileImage!]
  //           : [],
  //       name: d.name,
  //       mobile: d.phone,
  //       imei: d.imei1,
  //       loanBy: d.loanBy ?? "-",
  //       brand: d.deviceType,
  //       emi: d.emi?.status ?? "-",
  //       createdDate: d.createdAt, time: '', status: d.kycStatus,
  //
  //     );
  //   }).toList();
  // }
  List<UserModel> _mapOnly(List<CustomerListingV2Item> items) {
    return items.map((d) {
      final uiStatus = _mapToUiStatus(d); // ✅ correct

      return UserModel(
        // keyId: d.keyType?.isNotEmpty == true ? d.keyType! : d.id,
        keyId: d.userId ??"",
        deviceId: d.id,
        deviceType: d.deviceType.toUpperCase(),
        productImage: (d.profileImage?.isNotEmpty == true)
            ? [d.profileImage!]
            : [],
        name: d.name,
        mobile: d.phone,
        imei: d.imei1,
        loanBy: d.loanBy ?? "-",
        brand: d.deviceType,
        emi: d.emi?.status ?? "-",
        time: d.createdAt,              // ✅ required field
        status: uiStatus,               // ✅ enum fix
        createdDate: d.createdAt,
          signatureImage: d.signature,
          imei2: d.imei2,
        productPrice: d.emi?.totalAmount?.toString(),
        downPayment: d.emi?.downPayment?.toString(),
        balancePayment: d.emi?.loanAmount?.toString(),
        tenure: d.emi?.tenureMonths?.toString(),
        interest: d.emi?.interestRate?.toString(),
        emiAmount: d.emi?.emiAmount?.toString(),

      );
    }).toList();
  }
}