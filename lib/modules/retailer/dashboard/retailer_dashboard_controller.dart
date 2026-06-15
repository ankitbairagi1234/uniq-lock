import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/services/profile_api_services.dart';
import 'package:zlock_smart_finance/app/services/retailer_dashboard_service.dart';
import 'package:zlock_smart_finance/model/dashboard_response.dart';
import 'package:zlock_smart_finance/modules/retailer/qr_code/qr_dialog_helper.dart';

class RetailerDashboardController extends GetxController {

  final name = ''.obs;
  final email = ''.obs;
  final profileImage = 'assets/images/profile.png'.obs;
  final userId = ''.obs;

  final isLoading = false.obs;
  final isDashboardLoading = false.obs;

  final _profileService = ProfileService();
  final _dashboardService = RetailerDashboardService();

  // ✅ Stats (default 0)
  final totalUsers = 0.obs;
  final activeUsers = 0.obs;

  final totalSubRetailer= 0.obs;
  final activeSubRetailer= 0.obs;
  final deActiveSubRetailer= 0.obs;
  final keyBalance = 0.obs;
  final upcomingEmi = 0.obs;
  final todayActivation = 0.obs; // backend na de to 0 hi rahega

  // availability
  final androidAvailable = 50.obs;
  final iphoneAvailable = 50.obs;

  // loading / pagination / UI control
  final bannerPage = 0.obs;

  // helper to increment (demo)
  void incrementStats() {
    totalUsers.value += 1;
  }

  RxInt currentBanner = 0.obs;

  // Temporary banners (same banner repeated 3 times)
  // List<String> bannerList = [
  //   "assets/images/lock_pe.png",
  //   "assets/images/lock_pe.png",
  //   "assets/images/lock_pe.png",
  // ];
  final bannerList = <String>[].obs;

  PageController pageController = PageController();


  // void autoSlide() async {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 3));
  //     if (pageController.hasClients) {
  //       int next = (currentBanner.value + 1) % bannerList.length;
  //       pageController.animateToPage(
  //         next,
  //         duration: const Duration(milliseconds: 350),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   }
  // }
  Timer? _timer;

  void autoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients || bannerList.length <= 1) return;

      int next = (currentBanner.value + 1) % bannerList.length;

      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }
  Future<void> fetchProfile() async {
    isLoading.value = true;

    final resp = await _profileService.getProfile();

    isLoading.value = false;

    if (resp?.status != 200 || resp?.data?.user == null) {
      debugPrint("❌ Failed to load profile");
      return;
    }

    final user = resp!.data!.user!;

    name.value = user.displayName;
    email.value = user.email ?? '';
    // profileImage.value =
    // (user.image != null && user.image!.isNotEmpty)
    //     ? user.image!
    //     : 'assets/images/profile.png';

    debugPrint("✅ PROFILE LOADED");
    debugPrint("Name: ${name.value}");
    debugPrint("Email: ${email.value}");
  }

  bool _qrDialogOpenedOnce = false;

  final runningQrUrl = ''.obs;
  final newKeyQrUrl = ''.obs;

  final runningQrLabel = ''.obs;
  final runningEnrollLink = ''.obs;

  final newKeyQrLabel = ''.obs;
  final newKeyEnrollLink = ''.obs;
  DashAppUpdate? appUpdateData;
  final userType = ''.obs; // 🔥 NEW


  Future<void> fetchRetailerDashboard() async {
    isDashboardLoading.value = true;

    final resp = await _dashboardService.getRetailerDashboard();

    isDashboardLoading.value = false;

    if (resp == null || resp.success != true || resp.data == null) {
      debugPrint("❌ Failed to load dashboard stats: ${resp?.message}");
      return;
    }

    final d = resp.data!;

    // ✅ BANNERS
    // if (d.banners != null && d.banners!.isNotEmpty) {
    //   bannerList = d.banners!
    //       .where((b) => b.isActive == true)
    //       .map((b) => b.imageUrl ?? "")
    //       .where((url) => url.isNotEmpty)
    //       .toList();
    // }

    bannerList.value = (d.banners as List)
        .where((b) => b["isActive"] == true)
        .map<String>((b) => b["imageUrl"] ?? "")
        .where((url) => url.isNotEmpty)
        .toList();

    userId.value = d.user?.id ?? "";
    profileImage.value = d.user?.profileImage ?? '';

    debugPrint("🖼 IMAGE: ${profileImage.value}");

    // ✅ RUNNING KEY QR
    runningQrUrl.value = d.homeQR?.qrImageUrl ?? "";
    // runningQrLabel.value = d.homeQR?.qrLabel ?? "Running Key";
    runningEnrollLink.value = d.homeQR?.enrollmentLink ?? "";

// ✅ NEW KEY QR
    newKeyQrUrl.value = d.qrCodeRecord?.qrImageUrl ?? "";
    // newKeyQrLabel.value = d.qrCodeRecord?.qrLabel ?? "New Key";

    newKeyEnrollLink.value = d.qrCodeRecord?.enrollmentLink ?? "";

    // ✅ Display name & email dashboard se (no impact)
    name.value = d.user?.name ?? name.value;
    email.value = d.user?.email ?? email.value;

    // ✅ Stats mapping (0 safe)
    // totalUsers/activeUsers => customers
    totalUsers.value = d.customers?.self?.total ?? 0;
    activeUsers.value = d.customers?.self?.active ?? 0;


    userType.value = d.user?.type ?? "";
    print("🔥 USER TYPE: ${userType.value}");

    final vendorState = d.vendorStats?.byType;

    ///Sub Retailer
    totalSubRetailer.value = vendorState?.retailer?.total ??0;
    activeSubRetailer.value = vendorState?.retailer?.active ??0;
    deActiveSubRetailer.value = vendorState?.retailer?.inactive ??0;


    keyBalance.value = d.keys?.totalBalance ?? 0;

    // upcomingEmi => customers.emi.active (best match)
    upcomingEmi.value = d.customers?.emi?.active ?? 0;

    // todayActivation => customers.new_today OR linked (aapke UI meaning pe depend)
    // yaha new_today use kiya (today new customers)
    todayActivation.value =
        d.customers?.self?.newToday?.total ?? 0;


    checkAppUpdate(d.appUpdate);
    appUpdateData = d.appUpdate;

    // ✅ after dashboard loaded - open QR dialog once (only if coming from add key)
    final args = Get.arguments;
    final shouldOpen = (args is Map && args["showQrAfterDashboard"] == true);
    final passedUserId = (args is Map) ? args["qrUserId"] ?? "" : "";

    if (passedUserId.isNotEmpty) {
      runningQrLabel.value = passedUserId;
      newKeyQrLabel.value = passedUserId;
    }
    // if (shouldOpen && !_qrDialogOpenedOnce) {
    //   _qrDialogOpenedOnce = true;
    //
    //   // ✅ important: flag consume so refresh pe dubara na khule
    //   args["showQrAfterDashboard"] = false;
    //
    //   // ✅ pick QR data from dashboard response
    //   // final qrUrl =
    //   //     d.qrCodeRecord?.qrImageUrl ??
    //   //         d.homeQR?.qrImageUrl ??
    //   //         "";
    //   //
    //   // final label =
    //   //     d.qrCodeRecord?.qrLabel ??
    //   //         d.homeQR?.qrLabel ??
    //   //         "QR";
    //   //
    //   // final enrollLink =
    //   //     d.qrCodeRecord?.enrollmentLink ??
    //   //         d.homeQR?.enrollmentLink ??
    //   //         "";
    //
    //   // if (qrUrl.isNotEmpty) {
    //   //   Future.delayed(const Duration(milliseconds: 200), () {
    //   //     QrDialogHelper.openFromDashboard(
    //   //       qrImageUrl: qrUrl,
    //   //       qrLabel: label,
    //   //       enrollmentLink: enrollLink,
    //   //     );
    //   //   });
    //   // }
    //   if (newKeyQrUrl.value.isNotEmpty) {
    //     Future.delayed(const Duration(milliseconds: 200), () {
    //       QrDialogHelper.openFromDashboard(
    //         qrImageUrl: newKeyQrUrl.value,
    //         qrLabel: newKeyQrLabel.value,
    //         enrollmentLink: newKeyEnrollLink.value,
    //       );
    //     });
    //   }
    // }
    if (shouldOpen && !_qrDialogOpenedOnce) {

      _qrDialogOpenedOnce = true;
      args["showQrAfterDashboard"] = false;

      final source = args["source"];

      /// 🆕 NEW KEY
      if (source == "afterAddKey") {

        debugPrint("🆕 SHOWING NEW KEY QR");
        debugPrint("QR URL: ${newKeyQrUrl.value}");

        if (newKeyQrUrl.value.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 200), () {
            QrDialogHelper.openFromDashboard(
              qrImageUrl: newKeyQrUrl.value,
              qrLabel: newKeyQrLabel.value,
              enrollmentLink: newKeyEnrollLink.value,
            );
          });
        }

      }

      /// 🏠 RUNNING KEY
      else {

        debugPrint("🏠 SHOWING RUNNING KEY QR");
        debugPrint("QR URL: ${runningQrUrl.value}");

        if (runningQrUrl.value.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 200), () {
            QrDialogHelper.openFromDashboard(
              qrImageUrl: runningQrUrl.value,
              qrLabel: runningQrLabel.value,
              enrollmentLink: runningEnrollLink.value,
            );
          });
        }

      }

    }
    debugPrint(
      "✅ RETAILER DASH UPDATED: "
          "name=${name.value}, email=${email.value}, "
          "total=${totalUsers.value}, active=${activeUsers.value}, "
          "key=${keyBalance.value}, emi=${upcomingEmi.value}, today=${todayActivation.value}",
    );
  }

  Future<void> refreshAll() async {
    await Future.wait([
      fetchRetailerDashboard(),
    ]);
  }

  Future<void> checkAppUpdate(DashAppUpdate? update) async {
    if (update == null) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final currentVersion = packageInfo.version; // 1.0.0
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final serverVersion = update.versionName ?? "0.0.0";
      final serverBuild = int.tryParse(update.versionCode ?? "0") ?? 0;

      debugPrint("📱 CURRENT: $currentVersion ($currentBuild)");
      debugPrint("🌐 SERVER: $serverVersion ($serverBuild)");

      /// ✅ Compare build number first (recommended)
      if (serverBuild > currentBuild) {
        _showUpdateDialog(update);
      }
    } catch (e) {
      debugPrint("❌ Update check failed: $e");
    }
  }

  void _showUpdateDialog(DashAppUpdate update) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => !(update.forceUpdate ?? false),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 50, color: Colors.blue),

                const SizedBox(height: 10),

                const Text(
                  "Update Available 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Version ${update.versionName}",
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 10),

                Text(
                  update.changelog ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    /// ❌ Skip button (only if NOT force update)
                    if (!(update.forceUpdate ?? false))
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text("Later"),
                        ),
                      ),

                    if (!(update.forceUpdate ?? false))
                      const SizedBox(width: 10),

                    /// ✅ Update button
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       final url = Uri.parse(update.downloadUrl ?? "");
                    //       if (await canLaunchUrl(url)) {
                    //         // await launchUrl(
                    //         //   url,
                    //         //   mode: LaunchMode.externalApplication,
                    //         // );
                    //         final Uri uri = Uri.parse(update.downloadUrl ?? "");
                    //
                    //         if (!await launchUrl(
                    //           uri,
                    //           mode: LaunchMode.externalApplication,
                    //         )) {
                    //           Get.snackbar("Error", "Unable to open update link");
                    //         }
                    //       }
                    //     },
                    //     child: const Text("Update Now"),
                    //   ),
                    // ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final urlString = update.downloadUrl ?? "";

                          if (urlString.isEmpty) {
                            Get.snackbar("Error", "Invalid download URL");
                            return;
                          }

                          final Uri uri = Uri.parse(urlString);

                          final success = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication, // force browser
                          );

                          if (!success) {
                            Get.snackbar("Error", "Unable to open update link");
                          }
                        },
                        child: const Text("Update Now"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !(update.forceUpdate ?? false),
    );
  }
  // You can wire actual data fetching here
  @override
  void onInit() {
    super.onInit();
    refreshAll();
    autoSlide();
  }
  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
