import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/services/distributor_dashboard_service.dart';
import 'package:zlock_smart_finance/app/services/profile_api_services.dart';
import 'package:zlock_smart_finance/model/dashboard_response.dart';

// class DistributorDashController extends GetxController {
//   // user info
//   // final name = 'Distributor Dashboard'.obs;
//   // final email = 'distributor1234@gmail.com'.obs;
//   // final profileImage = 'assets/images/profile.png'.obs;
//
//   final name = ''.obs;
//   final email = ''.obs;
//   final profileImage = 'assets/images/profile.png'.obs;
//
//   final isLoading = false.obs;
//   final isDashboardLoading = false.obs;
//
//   // ✅ DASHBOARD STATS (API driven)
//   RxInt keyBalance = 0.obs;
//   RxInt usedKey = 0.obs;
//   RxInt totalRetailers = 0.obs;
//   RxInt activeRetailers = 0.obs;
//   RxInt activeActivations = 0.obs;
//   RxInt todaysRetailers = 0.obs;
//
//
//   // // quick stats
//   // final totalUsers = 1126.obs;
//   // final activeUsers = 1005.obs;
//   // final upcomingEmi = 50.obs;
//
//   // RxInt keyBalance = 798.obs;
//   // RxInt usedKey = 0.obs;
//   // RxInt totalRetailers = 6.obs;
//   // RxInt activeRetailers = 5.obs;
//
//   // availability
//   final androidAvailable = 50.obs;
//   final iphoneAvailable = 50.obs;
//
//   // loading / pagination / UI control
//   final bannerPage = 0.obs;
//
//   // // helper to increment (demo)
//   // void incrementStats() {
//   //   totalUsers.value += 1;
//   // }
//
//   RxInt currentBanner = 0.obs;
//
//   // Temporary banners (same banner repeated 3 times)
//   List<String> bannerList = [
//     "assets/images/banner.png",
//     "assets/images/banner.png",
//     "assets/images/banner.png",
//   ];
//
//   PageController pageController = PageController();
//   final _dashService = DistributorDashboardService();
//
//
//   void autoSlide() async {
//     while (true) {
//       await Future.delayed(const Duration(seconds: 3));
//       if (pageController.hasClients) {
//         int next = (currentBanner.value + 1) % bannerList.length;
//         pageController.animateToPage(
//           next,
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeInOut,
//         );
//       }
//     }
//   }
//
//   final _profileService = ProfileService();
//
//   Future<void> fetchProfile() async {
//     isLoading.value = true;
//
//     final resp = await _profileService.getProfile();
//
//     isLoading.value = false;
//
//     if (resp?.status != 200 || resp?.data?.user == null) {
//       debugPrint("❌ Failed to load profile");
//       return;
//     }
//
//     final user = resp!.data!.user!;
//
//     name.value = user.displayName;
//     email.value = user.email ?? '';
//     // profileImage.value =
//     // (user.image != null && user.image!.isNotEmpty)
//     //     ? user.image!
//     //     : 'assets/images/profile.png';
//
//     debugPrint("✅ PROFILE LOADED");
//     debugPrint("Name: ${name.value}");
//     debugPrint("Email: ${email.value}");
//   }
//
//   // Future<void> fetchDashboard() async {
//   //   isDashboardLoading.value = true;
//   //
//   //   final resp = await _dashService.getDistributorDashboard();
//   //
//   //   isDashboardLoading.value = false;
//   //
//   //   if (resp?.status != 200 || resp?.data == null) return;
//   //
//   //   final d = resp!.data!;
//   //   keyBalance.value = d.keyBalance;
//   //   usedKey.value = d.usedKey;
//   //   totalRetailers.value = d.totalRetailers;
//   //   activeRetailers.value = d.activeRetailers;
//   //   activeActivations.value = d.activeActivations;
//   //   todaysRetailers.value = d.todaysRetailers;
//   // }
//
//   Future<void> fetchDashboard() async {
//     isDashboardLoading.value = true;
//
//     final resp = await _dashService.getDistributorDashboard();
//
//     isDashboardLoading.value = false;
//
//     if (resp == null || resp.success != true || resp.data == null) {
//       debugPrint("❌ Dashboard failed: ${resp?.message}");
//       return;
//     }
//
//     final d = resp.data!;
//
//     // ✅ name/email from dashboard user
//     name.value = d.user?.name ?? '';
//     email.value = d.user?.email ?? '';
//
//     // ✅ stats mapping (no crash)
//     keyBalance.value = d.keys?.totalBalance ?? 0;
//     usedKey.value = d.keys?.totalUsed ?? (d.keys?.usedKeys ?? 0);
//
//     totalRetailers.value = d.customers?.total ?? 0;
//     activeRetailers.value = d.customers?.active ?? 0;
//
//     // "activations" ka best mapping linked customers
//     activeActivations.value = d.customers?.linked ?? 0;
//
//     todaysRetailers.value = d.customers?.newToday ?? 0;
//
//     debugPrint("✅ DASH LOADED");
//     debugPrint("Name: ${name.value}");
//     debugPrint("Email: ${email.value}");
//     debugPrint("KeyBalance: ${keyBalance.value}");
//   }
//
//   // Future<void> refreshAll() async {
//   //   await Future.wait([
//   //     fetchProfile(),
//   //     fetchDashboard(),
//   //   ]);
//   // }
//   Future<void> refreshAll() async {
//     await Future.wait([
//       fetchDashboard(),
//     ]);
//   }
//
//   // You can wire actual data fetching here
//   @override
//   void onInit() {
//     super.onInit();
//     refreshAll();
//     autoSlide();
//   }
//
//
// }

class DistributorDashController extends GetxController {

  ///Sub Distributor
  final totalSubDistributor = 0.obs;
  final activeSubDistributor = 0.obs;
  final inActiveSubDistributor = 0.obs;

  ///Distributors
  final totalDistributor = 0.obs;
  final activeDistributor = 0.obs;
  final inActiveDistributor = 0.obs;

  final name = ''.obs;
  final email = ''.obs;
  final profileImage = 'assets/images/profile.png'.obs;
  final userId = ''.obs;
  final isLoading = false.obs;
  final isDashboardLoading = false.obs;

  // ✅ STATS
  final keyBalance = 0.obs;
  final usedKey = 0.obs;
  final totalRetailers = 0.obs;
  final activeRetailers = 0.obs;
  final inActiveRetailers = 0.obs;

  final totalSubRetailers = 0.obs;
  final activeSubRetailers = 0.obs;
  final inActiveSubRetailers = 0.obs;

  final activeActivations = 0.obs;
  final todaysRetailers = 0.obs;

  // ✅ BANNERS (dynamic like retailer)
  final bannerList = <String>[].obs;
  RxInt currentBanner = 0.obs;
  PageController pageController = PageController();

  final _profileService = ProfileService();
  final _dashService = DistributorDashboardService();

  // ---------------- AUTO SLIDE ----------------
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


  // ---------------- PROFILE ----------------
  Future<void> fetchProfile() async {
    isLoading.value = true;

    final resp = await _profileService.getProfile();

    isLoading.value = false;

    if (resp?.status != 200 || resp?.data?.user == null) {
      debugPrint("❌ PROFILE FAILED");
      return;
    }

    final user = resp!.data!.user!;

    name.value = user.displayName;
    userId.value = user.id ?? '';

    email.value = user.email ?? '';


    debugPrint("🆔 USER ID SAVED (PROFILE): ${userId.value}");

    debugPrint("✅ PROFILE LOADED");

  }
  DashAppUpdate? appUpdateData;

  // ---------------- DASHBOARD ----------------
  Future<void> fetchDashboard() async {
    isDashboardLoading.value = true;

    final resp = await _dashService.getDistributorDashboard();

    isDashboardLoading.value = false;

    if (resp == null || resp.success != true || resp.data == null) {
      debugPrint("❌ DASH FAILED: ${resp?.message}");
      return;
    }

    final d = resp.data!;

    // ✅ USER INFO
    fetchProfile();
    name.value = d.user?.name ?? name.value;
    email.value = d.user?.email ?? email.value;
    profileImage.value = d.user?.profileImage ?? '';
    userId.value = d.user?.id ?? userId.value;
    userType.value = d.user?.type ?? "";

    print("🔥 USER TYPE: ${userType.value}");

    /// ✅ DISTRIBUTOR → vendorStats
    final vendorSummary = d.vendorStats?.summary;
    final sub = d.vendorStats?.byType?.subDistributor;
    final dist = d.vendorStats?.byType?.distributor;

    final vendor = d.vendorStats?.byType?.vendor;
    final subRetailer = d.vendorStats?.byType?.retailer;


    ///retailer-vendor
    totalRetailers.value = vendor?.total ?? 0;
    activeRetailers.value = vendor?.active ?? 0;
    inActiveRetailers.value = vendor?.inactive ?? 0;

    ///sub retailer -retailer
    totalSubRetailers.value = subRetailer?.total ?? 0;
    activeSubRetailers.value = subRetailer?.active ?? 0;
    inActiveSubRetailers.value = subRetailer?.inactive ?? 0;

    /// set subdistributor count
    totalSubDistributor.value = sub?.total ?? 0;
    activeSubDistributor.value = sub?.active ?? 0;
    inActiveSubDistributor.value = sub?.inactive ?? 0;

    /// set distributor count
    totalDistributor.value = dist?.total ?? 0;
    activeDistributor.value = dist?.active ?? 0;
    inActiveDistributor.value = dist?.inactive ?? 0;
    update();

    // // ✅ BANNERS (same logic as retailer)
    // bannerList.value = (d.banners ?? [])
    //     .where((b) => b["isActive"] == true)
    //     .map<String>((b) => b["imageUrl"] ?? "")
    //     .where((url) => url.isNotEmpty)
    //     .toList();

    bannerList.value = (d.banners ?? [])
        .where((b) => b["isActive"] == true)
        .map<String>((b) => b["imageUrl"] ?? "")
        .where((url) => url.isNotEmpty)
        .toList();

    debugPrint("🟢 BANNERS: ${bannerList.length}");

    // ✅ STATS MAPPING (IMPORTANT)
    keyBalance.value = d.keys?.totalBalance ?? 0;   // totalBalance
    usedKey.value = d.keys?.totalUsed ?? 0;         // totalUsed

    // totalRetailers.value = d.customers?.total ?? 0; // total
    // activeRetailers.value = d.customers?.active ?? 0; // active


    // ✅ OTHER STATS (same)
    keyBalance.value = d.keys?.totalBalance ?? 0;
    usedKey.value = d.keys?.totalUsed ?? 0;

    activeActivations.value = d.customers?.linked ?? 0;
    todaysRetailers.value = d.customers?.newToday ?? 0;
    checkAppUpdate(d.appUpdate);
    appUpdateData = d.appUpdate;
    update();

    debugPrint("✅ DASH LOADED");
    debugPrint("KeyBalance: ${keyBalance.value}");
    debugPrint("UsedKey: ${usedKey.value}");
    debugPrint("TotalRetailers: ${totalRetailers.value}");
    debugPrint("ActiveRetailers: ${activeRetailers.value}");
  }

  // ---------------- REFRESH ----------------
  Future<void> refreshAll() async {
    await Future.wait([
      fetchDashboard(),
      fetchProfile()
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

  final userType = ''.obs; // 🔥 NEW
  // ---------------- INIT ----------------
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