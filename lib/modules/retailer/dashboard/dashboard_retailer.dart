// import 'package:flutter/material.dart';
//
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:zlock_smart_finance/app/constants/app_colors.dart';
// import 'package:zlock_smart_finance/app/routes/app_routes.dart';
// import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_page.dart';
// import 'package:zlock_smart_finance/modules/distributor/dashboard/distributor_dash_controller.dart';
// import 'package:zlock_smart_finance/modules/distributor/total_retailer/total_retailer_list_page.dart';
// import 'package:zlock_smart_finance/modules/notifications/notification_page.dart';
// import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';
// import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_screen.dart';
// import 'package:zlock_smart_finance/modules/retailer/dashboard/retailer_dashboard_controller.dart';
// import 'package:zlock_smart_finance/modules/retailer/key_balance/key_transactions_page.dart';
// import 'package:zlock_smart_finance/modules/retailer/total_user/key_details_page.dart';
// enum NewKeyEntry { android, running, iphone }
//
// class RetailerDashboard extends StatefulWidget {
//   const RetailerDashboard({super.key});
//
//   @override
//   State<RetailerDashboard> createState() => _RetailerDashboardState();
// }
//
// class _RetailerDashboardState extends State<RetailerDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     final RetailerDashboardController c = Get.put(RetailerDashboardController());
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: AppColors.topBgColour.withOpacity(0.02),
//       body: RefreshIndicator(
//         onRefresh: () => c.refreshAll(),
//
//         child: Container(
//           decoration: const BoxDecoration(gradient: AppColors.bgTopGradient),
//           child: SafeArea(
//             // bottom: false,
//             child: Column(
//               children: [
//                 /// ✅ HEADER (FIXED - NOT SCROLLABLE)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.topBgColour,
//                     borderRadius: BorderRadius.circular(0),
//                     boxShadow: [AppColors.cardShadow],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header row: profile + greeting + notification
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
//                         child: Row(
//                           children: [
//
//                             GestureDetector(
//                               onTap: () {
//                                 Get.toNamed(AppRoutes.RETAIL_ACCOUNT_PAGE);
//                               },
//                               child: Obx(() {
//                                 final image = c.profileImage.value;
//
//                                 return CircleAvatar(
//                                   radius: 24,
//                                   backgroundColor: Colors.grey.shade200,
//                                   backgroundImage: (image.isNotEmpty && image.startsWith("http"))
//                                       ? NetworkImage(image)
//                                       : const AssetImage("assets/images/profile.png") as ImageProvider,
//                                 );
//                               }),
//                             ),
//
//                             const SizedBox(width: 12),
//                             // greeting
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Obx(() => Text(
//                                     'Hi, ${c.name.value}',
//                                     style: const TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   )),
//                                   const SizedBox(height: 4),
//                                   Obx(() => Text(
//                                     c.email.value,
//                                     style: TextStyle(
//                                       color: AppColors.white.withOpacity(0.9),
//                                       fontSize: 12,
//                                     ),
//                                   )),
//                                 ],
//                               ),
//                             ),
//                             // notification bubble
//                             Stack(
//                               alignment: Alignment.topRight,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Get.to(NotificationPage());
//                                   },
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.primaryLight.withOpacity(0.15),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: SvgPicture.asset(
//                                       'assets/accounts/bell.svg',
//                                       // width: 30,
//                                       // height: 30,
//                                       // fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   right: 0,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: const Text(
//                                       '0',
//                                       style: TextStyle(color: Colors.white, fontSize: 10),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//                 // Top App Frame (thin border look)
//                 const SizedBox(height: 0),
//                 Expanded(
//                   child:
//                   SingleChildScrollView(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.topBgColour,
//                         borderRadius: BorderRadius.circular(0),
//                         boxShadow: [AppColors.cardShadow],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//
//                           const SizedBox(height: 14),
//                           // Banner card (left text + right image)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: BannerCarousel(),
//                           ),
//
//
//
//                           const SizedBox(height: 18),
//                           ///all user
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           //   child: SizedBox(
//                           //     height: 115,
//                           //     child: ListView(
//                           //       scrollDirection: Axis.horizontal,
//                           //       // physics: const BouncingScrollPhysics(),
//                           //       children: [
//                           //
//                           //         _modernStatCard(
//                           //           title: "Total User",
//                           //           valueRx: c.totalUsers,
//                           //           iconPath: "assets/icons/total_user.svg",
//                           //           onTap: () {
//                           //             Get.to(KeyDetailsPage());
//                           //           },
//                           //         ),
//                           //
//                           //         _modernStatCard(
//                           //           title: "Active User",
//                           //           valueRx: c.activeUsers,
//                           //           iconPath: "assets/icons/active_user.svg",
//                           //           onTap: () {
//                           //             Get.to(
//                           //               CustomerListingV2Page(title: "Active Users"),
//                           //               arguments: {"type": "active"},
//                           //             );
//                           //           },
//                           //         ),
//                           //
//                           //         // _modernStatCard(
//                           //         //   title: "Key Balance",
//                           //         //   valueRx: c.keyBalance,
//                           //         //   iconPath: "assets/icons/key.svg",
//                           //         //   onTap: () {
//                           //         //     Get.to(KeyTransactionsPage());
//                           //         //   },
//                           //         // ),
//                           //         //
//                           //         // _modernStatCard(
//                           //         //   title: "Upcoming EMI",
//                           //         //   valueRx: c.upcomingEmi,
//                           //         //   iconPath: "assets/icons/upcoming.svg",
//                           //         //   onTap: () {
//                           //         //     Get.to(UpcomingScreen());
//                           //         //   },
//                           //         // ),
//                           //
//                           //         _modernStatCard(
//                           //           title: "Today Activation",
//                           //           valueRx: c.todayActivation,
//                           //           iconPath: "assets/icons/upcoming.svg",
//                           //           onTap: () {
//                           //             Get.to(
//                           //               CustomerListingV2Page(title: "Today Activation"),
//                           //               arguments: {"type": "today"},
//                           //             );
//                           //           },
//                           //         ),
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12.0),
//                             child: SizedBox(
//                               height: 115,
//                               child: Row(
//                                 children: [
//
//                                   Expanded(
//                                     child: _modernStatCard(
//                                       title: "Total User",
//                                       valueRx: c.totalUsers,
//                                       iconPath: "assets/icons/total_user.svg",
//                                       onTap: () {
//                                         Get.to(KeyDetailsPage());
//                                       },
//                                     ),
//                                   ),
//
//                                   // const SizedBox(width: 10),
//
//                                   Expanded(
//                                     child: _modernStatCard(
//                                       title: "Active User",
//                                       valueRx: c.activeUsers,
//                                       iconPath: "assets/icons/active_user.svg",
//                                       onTap: () {
//                                         Get.to(
//                                           CustomerListingV2Page(title: "Active Users"),
//                                           arguments: {"type": "active"},
//                                         );
//                                       },
//                                     ),
//                                   ),
//
//                                   // const SizedBox(width: 10),
//
//                                   Expanded(
//                                     child: _modernStatCard(
//                                       title: "Today Activation",
//                                       valueRx: c.todayActivation,
//                                       iconPath: "assets/icons/upcoming.svg",
//                                       onTap: () {
//                                         Get.to(
//                                           CustomerListingV2Page(title: "Today Activation"),
//                                           arguments: {"type": "today"},
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 12),
//
//                           ///Sub Retailer
//                           Obx(() {
//                             if (c.userType.value == "vendor") {
//                               return Padding(
//                                 padding: const EdgeInsets.only(left: 12.0,bottom: 12),
//                                 child: SizedBox(
//                                   height: 125,
//                                   child: Row(
//                                     children: [
//
//                                       Expanded(
//                                         child: _modernStatCard(
//                                           title: "Total\nSub-Retailer",
//                                           valueRx: c.totalSubRetailer,
//                                           iconPath: "assets/icons/total_user.svg",
//                                           // onTap: () {
//                                           //   // Get.to(KeyDetailsPage());
//                                           //   Get.to(
//                                           //     CustomerListingV2Page(title: "Total Sub-Retailer"),
//                                           //     arguments: {"type": "today"},
//                                           //   );
//                                           //
//                                           // },
//                                             onTap: () {
//                                               Get.to(() {
//                                                 if (!Get.isRegistered<DistributorDashController>()) {
//                                                   Get.put(DistributorDashController());
//                                                 }
//                                                 return const TotalRetailerListPage(
//                                                   title: "Total Sub-Retailer",
//                                                 );
//                                               });
//                                             }
//
//                                         ),
//                                       ),
//
//                                       // const SizedBox(width: 10),
//
//                                       Expanded(
//                                         child: _modernStatCard(
//                                           title: "Active\nSub-Retailer",
//                                           valueRx: c.activeSubRetailer,
//                                           iconPath: "assets/icons/active_user.svg",
//                                           // onTap: () {
//                                           //   Get.to(
//                                           //     CustomerListingV2Page(title: "Active Sub-Retailer"),
//                                           //     arguments: {"type": "active"},
//                                           //   );
//                                           // },
//                                             onTap: () {
//                                               Get.to(() {
//                                                 if (!Get.isRegistered<DistributorDashController>()) {
//                                                   Get.put(DistributorDashController());
//                                                 }
//                                                 return const TotalRetailerListPage(
//                                                   title: "Active Sub-Retailer",
//                                                 );
//                                               });
//                                             }
//
//                                         ),
//                                       ),
//
//                                       // const SizedBox(width: 10),
//
//                                       Expanded(
//                                         child: _modernStatCard(
//                                           title: "De-Active\nSub-Retailer",
//                                           valueRx: c.deActiveSubRetailer,
//                                           iconPath: "assets/icons/remove_user.svg",
//                                           // onTap: () {
//                                           //   Get.to(
//                                           //     CustomerListingV2Page(title: "De-Active Sub-Retailer"),
//                                           //     arguments: {"type": "today"},
//                                           //   );
//                                           // },
//
//                                             onTap: () {
//                                               Get.to(() {
//                                                 if (!Get.isRegistered<DistributorDashController>()) {
//                                                   Get.put(DistributorDashController());
//                                                 }
//                                                 return const TotalRetailerListPage(
//                                                   title: "Deactive Sub-Retailer",
//                                                 );
//                                               });
//                                             }
//
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }
//                             return SizedBox();
//                           }),
//
//
//
//                           ///Add keys
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: FeatureCard(
//                                     title: "Add New\nKey",
//                                     // iconPath: "assets/icons/android1.svg",
//                                     iconPath: "assets/icons/android_new.svg",
//                                     bgColor: const Color(0xFFEAF7ED),
//                                     gradient: const [Color(0xFFEEF7FF), Colors.white],
//                                     onTap: () => openNewKey(NewKeyEntry.android, "Add Android Key"),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//
//                                 // ✅ NewRunningKeyScreen remove -> same screen reuse
//                                 Expanded(
//                                   child: FeatureCard(
//                                     title: "Add Running\nKey",
//                                     // iconPath: "assets/icons/android2.svg",
//                                     iconPath: "assets/icons/android_new.svg",
//                                     bgColor: const Color(0xFFEAF7ED),
//                                     gradient: const [Color(0xFFEEF7FF), Colors.white],
//                                     onTap: () => openNewKey(NewKeyEntry.running, "Add Running Key"),
//                                   ),
//                                 ),
//
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: FeatureCard(
//                                     title: "Add iPhone\nKey",
//                                     // iconPath: "assets/icons/apple.svg",
//                                     iconPath: "assets/icons/apple_new.svg",
//                                     bgColor: const Color(0xFFFFEDEE),
//                                     gradient: const [Color(0xFFFFF2F3), Colors.white],
//                                     // onTap: () => openNewKey(NewKeyEntry.iphone, "Add iPhone Key"),
//                                     onTap: () {
//
//                                       Get.snackbar(
//                                         "iPhone Key",
//                                         "Coming Soon",
//                                         snackPosition: SnackPosition.BOTTOM,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 12),
//                           ///B2B & loan Zon
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Expanded(
//                                 //   child: FeatureCard(
//                                 //     title: "B2B\nOrder",
//                                 //     iconPath: "assets/icons/loan_zone.svg",
//                                 //     bgColor: const Color(0xFFEBEFFF),
//                                 //     gradient: const [Colors.white,Color(0xFFFFDBD8), ],
//                                 //     onTap: () => Get.to(ProductListPage()),
//                                 //   ),
//                                 // ),
//                                 Expanded(
//                                   child: FeatureCard(
//                                     title: "B2B\nOrder",
//                                     iconPath: "assets/icons/loan_zone.svg",
//                                     bgColor: const Color(0xFFEBEFFF),
//                                     gradient: const [Colors.white, Color(0xFFFFDBD8)],
//                                     onTap: () {
//                                       // Get.to(ProductListPage()); // temporarily disabled
//
//                                       Get.snackbar(
//                                         "B2B Order",
//                                         "Coming Soon",
//                                         snackPosition: SnackPosition.BOTTOM,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 // Expanded(
//                                 //   child: FeatureCard(
//                                 //     title: "Loan\nZone",
//                                 //     iconPath: "assets/icons/loan_zone.svg",
//                                 //     bgColor: const Color(0xFFEBEFFF),
//                                 //     gradient: const [ Colors.white,Color(0xFFDFD3FF),],
//                                 //     onTap: () => Get.to(AddIphoneKeyScreen()),
//                                 //   ),
//                                 // ),
//                                 Expanded(
//                                   child: FeatureCard(
//                                     title: "Loan\nZone",
//                                     iconPath: "assets/icons/loan_zone.svg",
//                                     bgColor: const Color(0xFFEBEFFF),
//                                     gradient: const [Colors.white, Color(0xFFDFD3FF)],
//                                     onTap: () async {
//                                       // Get.to(AddIphoneKeyScreen()); // temporarily disabled
//
//                                       final url = Uri.parse("https://indiasales.club/");
//                                       await launchUrl(
//                                         url,
//                                         mode: LaunchMode.externalApplication,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 // Expanded(
//                                 //   child: FeatureCard(
//                                 //     // title: "ECS\nE-Mandate",
//                                 //     title: "Pro\nConnect",
//                                 //     iconPath: "assets/icons/loan_zone.svg",
//                                 //     bgColor: const Color(0xFFEBEFFF),
//                                 //     gradient: const [ Colors.white,Color(0xFFCDFBEB),],
//                                 //     onTap: () => Get.to(ProductListPage()),
//                                 //   ),
//                                 // ),
//                                 Expanded(
//                                   child: FeatureCard(
//                                     // title: "Pro\nConnect",
//                                     title: "Easy\nEMI",
//                                     iconPath: "assets/icons/loan_zone.svg",
//                                     bgColor: const Color(0xFFEBEFFF),
//                                     gradient: const [Colors.white, Color(0xFFCDFBEB)],
//                                     onTap: () async {
//                                       // final url = Uri.parse(
//                                       //   "https://app.lendbox.in/sahukar/login?partnerName=LOCKPE%20PRO",
//                                       // );
//                                       final url = Uri.parse(
//                                         "https://easyemi.lockpepro.com/",
//                                       );
//
//                                       await launchUrl(
//                                         url,
//                                         mode: LaunchMode.externalApplication,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 15),
//
//                           // COMING SOON CARDS
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           //   child: InkWell(
//                           //     onTap: () => Get.to(ProductListPage()),
//                           //     child: Row(
//                           //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //       children: [
//                           //         Expanded(child: ComingSoonCard()),
//                           //         const SizedBox(width: 10),
//                           //         Expanded(child: ComingSoonCard()),
//                           //         const SizedBox(width: 10),
//                           //         Expanded(child: ComingSoonCard()),
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                           // const SizedBox(height: 10),
//                           // Quick stat cards row
//                           ///old cards
//
//
//                           // const SizedBox(height: 20),
//                           ///android av & iphone av
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFEAF0FF), // SAME as screenshot background
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Row(
//                               children:  [
//                                 // Expanded(
//                                 //   child: AvailabilityCard(
//                                 //     title: "Android Av.",
//                                 //     count: "50",
//                                 //     iconPath: "assets/icons/android2.svg",
//                                 //     stripColor: Color(0xFF0E8345),
//                                 //     iconBg: Color(0xFFEAF7ED),
//                                 //     titleColor: Color(0xFF0B2A76),
//                                 //   ),
//                                 // ),
//                                 Expanded(
//                                   child: Obx(() => AvailabilityCard(
//                                     onTap: () {
//                                       Get.to(KeyTransactionsPage());
//
//                                     },
//                                     title: "Android Av.",
//                                     count: c.keyBalance.value.toString(), // ✅ DYNAMIC
//                                     iconPath: "assets/icons/android2.svg",
//                                     stripColor: const Color(0xFF0E8345),
//                                     iconBg: const Color(0xFFEAF7ED),
//                                     titleColor: const Color(0xFF0B2A76),
//                                   )),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: AvailabilityCard(
//                                     onTap: () {
//
//                                     },
//                                     title: "iPhone Av",
//                                     count: "0",
//                                     iconPath: "assets/icons/apple.svg",
//                                     stripColor: Color(0xFF8B1D20),
//                                     iconBg: Color(0xFFFFE7E8),
//                                     titleColor: Color(0xFF0B2A76),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 0),
//
//                           // const SizedBox(height: 20),
//
//                           // SvgPicture.asset(
//                           //   'assets/images/banner.svg',
//                           //   width: size.width,
//                           //   fit: BoxFit.cover,
//                           // ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _modernStatCard({
//     required String title,
//     required String iconPath,
//     required RxInt valueRx,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 13),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: onTap,
//         child: Container(
//           width: 120,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//
//             /// 🔥 GLASS + 3D EFFECT
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.white,
//                 const Color(0xFFF1F4FF),
//               ],
//             ),
//
//             boxShadow: [
//               /// light shadow (top)
//               // BoxShadow(
//               //   color: Colors.white.withOpacity(0.9),
//               //   offset: const Offset(-3, -3),
//               //   blurRadius: 6,
//               // ),
//
//               /// dark shadow (bottom)
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 offset: const Offset(4, 6),
//                 blurRadius: 12,
//               ),
//             ],
//
//             border: Border.all(color: Colors.white.withOpacity(0.6)),
//           ),
//
//           child: Obx(() {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 /// ICON
//                 Container(
//                   height: 38,
//                   width: 38,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFFEAF0FF), Color(0xFFDDE6FF)],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: SvgPicture.asset(
//                       iconPath,
//                       height: 20,
//                       width: 20,
//                     ),
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 /// TITLE
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     overflow: TextOverflow.ellipsis,
//
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A2B6B),
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 /// VALUE
//                 Text(
//                   valueRx.value.toString(),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
//
// void openNewKey(NewKeyEntry entry, String title) {
//   Get.to(
//         () => NewKeyScreen(entry: entry, title: title),
//     binding: BindingsBuilder(() {
//       // ✅ har entry ka apna controller instance
//       Get.put(NewKeyController(entry: entry), tag: entry.name);
//     }),
//   );
// }
//
// /// Stat card widget (small rounded)
// class StatCard extends StatelessWidget {
//   final String title;
//   final String iconPath;
//   final RxInt valueRx;
//   final VoidCallback onTap;
//
//
//   const StatCard({
//     super.key,
//     required this.title,
//     required this.iconPath,
//     required this.valueRx,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double cardWidth = MediaQuery.of(context).size.width * 0.22;
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         // height: 90,
//         // width: 83,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFFFFFFF),
//               Color(0xFFF5F7FF), // light blue tint same as screenshot
//             ],
//           ),
//           borderRadius: BorderRadius.circular(13),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(1, 3),
//             ),
//           ],
//         ),
//         child: Obx(() {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ICON BOX
//               Container(
//                 height: 36,
//                 width: 36,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEAF0FF), // light bg for icon
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     iconPath,
//                     width: 20,
//                     height: 20,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//
//               // TITLE
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Color(0xFF1A2B6B),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//
//               const SizedBox(height: 6),
//
//               // VALUE
//               Text(
//                 valueRx.value.toString(),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
// /// Banner with left text and right image
// class BannerCarousel extends StatelessWidget {
//   const BannerCarousel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final RetailerDashboardController c = Get.find();
//
//     return Column(
//       children: [
//         // SizedBox(
//         //   height: 182,
//         //   child: PageView.builder(
//         //     controller: c.pageController,
//         //     // itemCount: c.bannerList.length,
//         //     itemCount: c.bannerList.isEmpty ? 1 : c.bannerList.length,
//         //     onPageChanged: (index) => c.currentBanner.value = index,
//         //     itemBuilder: (context, index) {
//         //       if (c.bannerList.isEmpty) {
//         //         return _BannerCard(imagePath: "assets/images/lock_pe.png");
//         //       }
//         //       return _BannerCard(imagePath: c.bannerList[index]);
//         //     },
//         //   ),
//         // ),
//         SizedBox(
//           height: 182,
//           child: Obx(() {
//             final banners = c.bannerList;
//
//             return PageView.builder(
//               controller: c.pageController,
//               itemCount: banners.isEmpty ? 1 : banners.length,
//               onPageChanged: (index) => c.currentBanner.value = index,
//               itemBuilder: (context, index) {
//                 if (banners.isEmpty) {
//                   return _BannerCard(imagePath: "assets/images/lock_pe.png");
//                 }
//
//                 return _BannerCard(imagePath: banners[index]);
//               },
//             );
//           }),
//         ),
//         const SizedBox(height: 10),
//
//         // dot indicator
//         Obx(() {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               c.bannerList.length,
//                   (i) => AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 width: c.currentBanner.value == i ? 14 : 6,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   color: c.currentBanner.value == i
//                       ? AppColors.primaryDark
//                       : AppColors.grey.withOpacity(0.4),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
//
// class _BannerCard extends StatelessWidget {
//   final String imagePath;
//   const _BannerCard({required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     final isNetwork = imagePath.startsWith("http");
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: isNetwork
//             ? Image.network(
//           imagePath,
//           fit: BoxFit.cover,
//           width: double.infinity,
//           loadingBuilder: (context, child, progress) {
//             if (progress == null) return child;
//             return const Center(child: CircularProgressIndicator());
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Image.asset(
//               "assets/images/lock_pe.png",
//               fit: BoxFit.cover,
//             );
//           },
//         )
//             : Image.asset(
//           imagePath,
//           fit: BoxFit.cover,
//           width: double.infinity,
//         ),
//       ),
//     );
//   }
// }
//
// class FeatureCard extends StatelessWidget {
//   final String title;
//   final String iconPath;
//   final List<Color> gradient;
//   final Color bgColor;
//   final VoidCallback onTap;
//
//   const FeatureCard({
//     super.key,
//     required this.title,
//     required this.iconPath,
//     required this.gradient,
//     required this.bgColor,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 145,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(
//             colors: gradient,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: Colors.black12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.08),
//               blurRadius: 8,
//               offset: const Offset(2, 4),
//             )
//           ],
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ICON BOX
//             Container(
//               height: 36,
//               width: 36,
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: SvgPicture.asset(
//                   iconPath,
//                   height: 32,
//                   width: 32,
//                 ),
//               ),
//             ),
//
//             const Spacer(),
//
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             const Align(
//               alignment: Alignment.centerRight,
//               child: Icon(Icons.arrow_outward, size: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ComingSoonCard extends StatelessWidget {
//   const ComingSoonCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.black12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(2, 4),
//           )
//         ],
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.lock, size: 32, color: Colors.black54),
//           SizedBox(height: 10),
//           Text(
//             "Coming Soon",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AvailabilityCard extends StatelessWidget {
//   final String title;
//   final String count;
//   final String iconPath;
//   final Color stripColor;
//   final Color iconBg;
//   final Color titleColor;
//   final VoidCallback onTap;
//
//   const AvailabilityCard({
//     super.key,
//     required this.title,
//     required this.count,
//     required this.iconPath,
//     required this.stripColor,
//     required this.iconBg,
//     required this.titleColor,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 70,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: Colors.black12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.06),
//               blurRadius: 8,
//               offset: const Offset(1, 4),
//             )
//           ],
//           color: Colors.white,
//         ),
//         child: Stack(
//           children: [
//             // LEFT COLOR STRIP
//             Positioned(
//               left: 0,
//               top: 0,
//               bottom: 0,
//               child: Container(
//                 width: 14,
//                 decoration: BoxDecoration(
//                   color: stripColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     bottomLeft: Radius.circular(18),
//                   ),
//                 ),
//               ),
//             ),
//
//             // CONTENT
//             Padding(
//               padding: const EdgeInsets.only(left: 24, right: 5),
//               child: Row(
//                 children: [
//                   // ICON BOX
//                   Container(
//                     height: 36,
//                     width: 36,
//                     decoration: BoxDecoration(
//                       color: iconBg,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: SvgPicture.asset(
//                         iconPath,
//                         height: 22,
//                         width: 22,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   // TEXT AREA
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: titleColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           count,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const Icon(Icons.arrow_outward, size: 18),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_page.dart';
import 'package:zlock_smart_finance/modules/distributor/dashboard/distributor_dash_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/total_retailer_list_page.dart';
import 'package:zlock_smart_finance/modules/notifications/notification_page.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_screen.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/retailer_dashboard_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/key_balance/key_transactions_page.dart';
import 'package:zlock_smart_finance/modules/retailer/total_user/key_details_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/total_user/key_details_page.dart';
enum NewKeyEntry { android, running, iphone }

class RetailerDashboard extends StatefulWidget {
  const RetailerDashboard({super.key});

  @override
  State<RetailerDashboard> createState() => _RetailerDashboardState();
}

class _RetailerDashboardState extends State<RetailerDashboard> {

  @override
  Widget build(BuildContext context) {
    final RetailerDashboardController c = Get.put(RetailerDashboardController());
    final KeyDetailsController keyCtrl = Get.put(KeyDetailsController());

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.topBgColour.withOpacity(0.02),
      body: RefreshIndicator(
        onRefresh: () => c.refreshAll(),

        child: Container(

          // decoration: const BoxDecoration(gradient: AppColors.bgTopGradient),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // topBgColour,
                  // white,
                  // AppColors.topBgColour,
                  // AppColors.topBgColour
                  Color(0xFF0D0D0D),
                  Color(0xFF1A1A1A),

                ],
              )
          ),
          child: SafeArea(
            // bottom: false,
            child: Column(
              children: [
                /// ✅ HEADER (FIXED - NOT SCROLLABLE)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.topBgColour,
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [AppColors.cardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row: profile + greeting + notification
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                        child: Row(
                          children: [

                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.RETAIL_ACCOUNT_PAGE);
                              },
                              child: Obx(() {
                                final image = c.profileImage.value;

                                return CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: (image.isNotEmpty && image.startsWith("http"))
                                      ? NetworkImage(image)
                                      : const AssetImage("assets/images/profile.png") as ImageProvider,
                                );
                              }),
                            ),

                            const SizedBox(width: 12),
                            // greeting
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                    'Hi, ${c.name.value}',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    c.email.value,
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.9),
                                      fontSize: 12,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            // notification bubble
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(NotificationPage());
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,

                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/accounts/bell.svg',color: Color(0xFFD4AF37),
                                      // width: 30,
                                      // height: 30,
                                      // fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      '0',
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                // Top App Frame (thin border look)
                const SizedBox(height: 0),
                Expanded(
                  child:
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.topBgColour,
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [AppColors.cardShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: BannerCarousel(),
                          ),
                          const SizedBox(height: 8),


                          // Banner card (left text + right image)
                          ///all user
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          //   child: SizedBox(
                          //     height: 115,
                          //     child: ListView(
                          //       scrollDirection: Axis.horizontal,
                          //       // physics: const BouncingScrollPhysics(),
                          //       children: [
                          //
                          //         _modernStatCard(
                          //           title: "Total User",
                          //           valueRx: c.totalUsers,
                          //           iconPath: "assets/icons/total_user.svg",
                          //           onTap: () {
                          //             Get.to(KeyDetailsPage());
                          //           },
                          //         ),
                          //
                          //         _modernStatCard(
                          //           title: "Active User",
                          //           valueRx: c.activeUsers,
                          //           iconPath: "assets/icons/active_user.svg",
                          //           onTap: () {
                          //             Get.to(
                          //               CustomerListingV2Page(title: "Active Users"),
                          //               arguments: {"type": "active"},
                          //             );
                          //           },
                          //         ),
                          //
                          //         // _modernStatCard(
                          //         //   title: "Key Balance",
                          //         //   valueRx: c.keyBalance,
                          //         //   iconPath: "assets/icons/key.svg",
                          //         //   onTap: () {
                          //         //     Get.to(KeyTransactionsPage());
                          //         //   },
                          //         // ),
                          //         //
                          //         // _modernStatCard(
                          //         //   title: "Upcoming EMI",
                          //         //   valueRx: c.upcomingEmi,
                          //         //   iconPath: "assets/icons/upcoming.svg",
                          //         //   onTap: () {
                          //         //     Get.to(UpcomingScreen());
                          //         //   },
                          //         // ),
                          //
                          //         _modernStatCard(
                          //           title: "Today Activation",
                          //           valueRx: c.todayActivation,
                          //           iconPath: "assets/icons/upcoming.svg",
                          //           onTap: () {
                          //             Get.to(
                          //               CustomerListingV2Page(title: "Today Activation"),
                          //               arguments: {"type": "today"},
                          //             );
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: SizedBox(
                              height: 105,
                              child: Row(
                                children: [

                                  // Expanded(
                                  //   child: _modernStatCard(
                                  //     title: "Total User",
                                  //     valueRx: c.totalUsers,
                                  //     iconPath: "assets/icons/total_user.svg",
                                  //     onTap: () {
                                  //       Get.to(KeyDetailsPage());
                                  //     },
                                  //   ),
                                  // ),

                                  // const SizedBox(width: 10),

                                  Expanded(
                                    child: _modernStatCard(
                                      title: "Active User",
                                      valueRx: c.activeUsers,
                                      iconPath: "assets/icons/active_user.svg",
                                      onTap: () {
                                        Get.to(
                                          CustomerListingV2Page(title: "Active Users"),
                                          arguments: {"type": "active"},
                                        );
                                      },
                                    ),
                                  ),

                                  // const SizedBox(width: 10),

                                  Expanded(
                                    child: _modernStatCard(
                                      title: "Today Activation",
                                      valueRx: c.todayActivation,
                                      iconPath: "assets/icons/upcoming.svg",
                                      onTap: () {
                                        Get.to(
                                          CustomerListingV2Page(title: "Today Activation"),
                                          arguments: {"type": "today"},
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _modernStatCard(
                                      title: "Lock User",
                                      valueRx: c.todayActivation,
                                      iconPath: "assets/icons/lock_user.svg",
                                      onTap: () {
                                        Get.to(
                                          CustomerListingV2Page(title: "Lock User"),
                                          arguments: {"type": "lock"},
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),



                          // const SizedBox(height: 12),

                          ///Sub Retailer
                          // Obx(() {
                          //   if (c.userType.value == "vendor") {
                          //     return Padding(
                          //       padding: const EdgeInsets.only(left: 12.0,bottom: 12),
                          //       child: SizedBox(
                          //         height: 125,
                          //         child: Row(
                          //           children: [
                          //
                          //             Expanded(
                          //               child: _modernStatCard(
                          //                 title: "Total\nSub-Retailer",
                          //                 valueRx: c.totalSubRetailer,
                          //                 iconPath: "assets/icons/total_user.svg",
                          //                 // onTap: () {
                          //                 //   // Get.to(KeyDetailsPage());
                          //                 //   Get.to(
                          //                 //     CustomerListingV2Page(title: "Total Sub-Retailer"),
                          //                 //     arguments: {"type": "today"},
                          //                 //   );
                          //                 //
                          //                 // },
                          //                   onTap: () {
                          //                     Get.to(() {
                          //                       if (!Get.isRegistered<DistributorDashController>()) {
                          //                         Get.put(DistributorDashController());
                          //                       }
                          //                       return const TotalRetailerListPage(
                          //                         title: "Total Sub-Retailer",
                          //                       );
                          //                     });
                          //                   }
                          //
                          //               ),
                          //             ),
                          //
                          //             // const SizedBox(width: 10),
                          //
                          //             Expanded(
                          //               child: _modernStatCard(
                          //                 title: "Active\nSub-Retailer",
                          //                 valueRx: c.activeSubRetailer,
                          //                 iconPath: "assets/icons/active_user.svg",
                          //                 // onTap: () {
                          //                 //   Get.to(
                          //                 //     CustomerListingV2Page(title: "Active Sub-Retailer"),
                          //                 //     arguments: {"type": "active"},
                          //                 //   );
                          //                 // },
                          //                   onTap: () {
                          //                     Get.to(() {
                          //                       if (!Get.isRegistered<DistributorDashController>()) {
                          //                         Get.put(DistributorDashController());
                          //                       }
                          //                       return const TotalRetailerListPage(
                          //                         title: "Active Sub-Retailer",
                          //                       );
                          //                     });
                          //                   }
                          //
                          //               ),
                          //             ),
                          //
                          //             // const SizedBox(width: 10),
                          //
                          //             Expanded(
                          //               child: _modernStatCard(
                          //                 title: "De-Active\nSub-Retailer",
                          //                 valueRx: c.deActiveSubRetailer,
                          //                 iconPath: "assets/icons/remove_user.svg",
                          //                 // onTap: () {
                          //                 //   Get.to(
                          //                 //     CustomerListingV2Page(title: "De-Active Sub-Retailer"),
                          //                 //     arguments: {"type": "today"},
                          //                 //   );
                          //                 // },
                          //
                          //                   onTap: () {
                          //                     Get.to(() {
                          //                       if (!Get.isRegistered<DistributorDashController>()) {
                          //                         Get.put(DistributorDashController());
                          //                       }
                          //                       return const TotalRetailerListPage(
                          //                         title: "Deactive Sub-Retailer",
                          //                       );
                          //                     });
                          //                   }
                          //
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   }
                          //   return SizedBox();
                          // }),



                          ///Add keys
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FeatureCard(
                                    title: "Add\nNew Key",
                                    // iconPath: "assets/icons/android1.svg",
                                    iconPath: "assets/icons/android_new.svg",
                                    bgColor: const Color(0xFFEAF7ED),
                                    gradient: const [Color(0xFFEEF7FF), Colors.white],
                                    onTap: () => openNewKey(NewKeyEntry.android, "Add Android Key"),
                                  ),
                                ),
                                Expanded(
                                  child: FeatureCard(
                                    title: "Total\nUser",
                                    // iconPath: "assets/icons/android1.svg",
                                    iconPath: "assets/icons/total_user.svg",
                                    bgColor: const Color(0xFFEAF7ED),
                                    gradient: const [Color(0xFFEEF7FF), Colors.white],
                                    onTap: () {
                                      Get.to(
                                        CustomerListingV2Page(title: "Tota Users"),
                                        arguments: {
                                          "type": "all", // ✅ IMPORTANT (no filter)
                                        },
                                        // arguments: {"type": "active"},
                                      );

                                    },
                                    // onTap: () => openNewKey(NewKeyEntry.android, "Add Android Key"),
                                  ),
                                ),


                                // ✅ NewRunningKeyScreen remove -> same screen reuse
                                Expanded(
                                  child: FeatureCard(
                                    title: "Add\nRunning Key",
                                    // iconPath: "assets/icons/android2.svg",
                                    iconPath: "assets/icons/android_new.svg",
                                    bgColor: const Color(0xFFEAF7ED),
                                    gradient: const [Color(0xFFEEF7FF), Colors.white],
                                    onTap: () => openNewKey(NewKeyEntry.running, "Add Running Key"),
                                  ),
                                ),

                                const SizedBox(width: 10),
                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "Add\niPhone Key",
                                //     // iconPath: "assets/icons/apple.svg",
                                //     iconPath: "assets/icons/apple_new.svg",
                                //     bgColor: const Color(0xFFFFEDEE),
                                //     gradient: const [Color(0xFFFFF2F3), Colors.white],
                                //     // onTap: () => openNewKey(NewKeyEntry.iphone, "Add iPhone Key"),
                                //     onTap: () {
                                //
                                //       Get.snackbar(
                                //         "iPhone Key",
                                //         "Coming Soon",
                                //         snackPosition: SnackPosition.BOTTOM,
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          // const SizedBox(height: 12),
                          ///B2B & loan Zon
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "B2B\nOrder",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [Colors.white, Color(0xFFFFDBD8)],
                                //     onTap: () {
                                //       // Get.to(ProductListPage()); // temporarily disabled
                                //
                                //       Get.snackbar(
                                //         "B2B Order",
                                //         "Coming Soon",
                                //         snackPosition: SnackPosition.BOTTOM,
                                //       );
                                //     },
                                //   ),
                                // ),
                                // const SizedBox(width: 10),
                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "Loan\nZone",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [ Colors.white,Color(0xFFDFD3FF),],
                                //     onTap: () => Get.to(AddIphoneKeyScreen()),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "Loan\nZone",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [Colors.white, Color(0xFFDFD3FF)],
                                //     onTap: () async {
                                //       // Get.to(AddIphoneKeyScreen()); // temporarily disabled
                                //
                                //       final url = Uri.parse("https://indiasales.club/");
                                //       await launchUrl(
                                //         url,
                                //         mode: LaunchMode.externalApplication,
                                //       );
                                //     },
                                //   ),
                                // ),
                                // const SizedBox(width: 10),
                                // Expanded(
                                //   child: FeatureCard(
                                //     // title: "ECS\nE-Mandate",
                                //     title: "Pro\nConnect",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [ Colors.white,Color(0xFFCDFBEB),],
                                //     onTap: () => Get.to(ProductListPage()),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: FeatureCard(
                                //     // title: "Pro\nConnect",
                                //     title: "Easy\nEMI",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [Colors.white, Color(0xFFCDFBEB)],
                                //     onTap: () async {
                                //       // final url = Uri.parse(
                                //       //   "https://app.lendbox.in/sahukar/login?partnerName=LOCKPE%20PRO",
                                //       // );
                                //       final url = Uri.parse(
                                //         "https://easyemi.lockpepro.com/",
                                //       );
                                //
                                //       await launchUrl(
                                //         url,
                                //         mode: LaunchMode.externalApplication,
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),
                          Obx(() {
                            if (keyCtrl.isLoading.value) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [

                                  /// 🔥 ANDROID KEY
                                  _dashboardKeySection(
                                    title: "Android Key",
                                    value: keyCtrl.newKey.value,
                                    stats: keyCtrl.newKeyStats,
                                  ),

                                  const SizedBox(height: 10),

                                  /// 🔥 RUNNING KEY
                                  _dashboardKeySection(
                                    title: "Running Key",
                                    value: keyCtrl.runningKey.value,
                                    stats: keyCtrl.runningKeyStats,
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 15),

                          // COMING SOON CARDS
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          //   child: InkWell(
                          //     onTap: () => Get.to(ProductListPage()),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Expanded(child: ComingSoonCard()),
                          //         const SizedBox(width: 10),
                          //         Expanded(child: ComingSoonCard()),
                          //         const SizedBox(width: 10),
                          //         Expanded(child: ComingSoonCard()),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // Quick stat cards row
                          ///old cards


                          // const SizedBox(height: 20),
                          ///android av & iphone av
                          // Container(
                          //   width: double.infinity,
                          //   padding: const EdgeInsets.all(16),
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFFEAF0FF), // SAME as screenshot background
                          //     borderRadius: BorderRadius.circular(16),
                          //   ),
                          //   child: Row(
                          //     children:  [
                          //       // Expanded(
                          //       //   child: AvailabilityCard(
                          //       //     title: "Android Av.",
                          //       //     count: "50",
                          //       //     iconPath: "assets/icons/android2.svg",
                          //       //     stripColor: Color(0xFF0E8345),
                          //       //     iconBg: Color(0xFFEAF7ED),
                          //       //     titleColor: Color(0xFF0B2A76),
                          //       //   ),
                          //       // ),
                          //       Expanded(
                          //         child: Obx(() => AvailabilityCard(
                          //           onTap: () {
                          //             Get.to(KeyTransactionsPage());
                          //
                          //           },
                          //           title: "Android Av.",
                          //           count: c.keyBalance.value.toString(), // ✅ DYNAMIC
                          //           iconPath: "assets/icons/android2.svg",
                          //           stripColor: const Color(0xFF0E8345),
                          //           iconBg: const Color(0xFFEAF7ED),
                          //           titleColor: const Color(0xFF0B2A76),
                          //         )),
                          //       ),
                          //       SizedBox(width: 12),
                          //       Expanded(
                          //         child: AvailabilityCard(
                          //           onTap: () {
                          //
                          //           },
                          //           title: "iPhone Av",
                          //           count: "0",
                          //           iconPath: "assets/icons/apple.svg",
                          //           stripColor: Color(0xFF8B1D20),
                          //           iconBg: Color(0xFFFFE7E8),
                          //           titleColor: Color(0xFF0B2A76),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(22),
                            //
                            //   gradient: const LinearGradient(
                            //     colors: [
                            //       Color(0xFF1A1A1A),
                            //       Color(0xFF0D0D0D),
                            //     ],
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight,
                            //   ),
                            //
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: const Color(0xFFD4AF37).withOpacity(0.25),
                            //       blurRadius: 18,
                            //       offset: const Offset(0, 10),
                            //     ),
                            //     BoxShadow(
                            //       color: Colors.black.withOpacity(0.6),
                            //       blurRadius: 16,
                            //       offset: const Offset(0, 10),
                            //     ),
                            //   ],
                            //
                            //   border: Border.all(
                            //     color: const Color(0x33D4AF37),
                            //   ),
                            // ),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),

                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1C1C1C),
                                  Color(0xFF0A0A0A),
                                ],
                              ),

                              border: Border.all(
                                color: const Color(0x66D9B65A),
                                width: 1.2,
                              ),

                              // boxShadow: [
                              //   BoxShadow(
                              //     color: const Color(0xFFD9B65A).withOpacity(0.30),
                              //     blurRadius: 24,
                              //     spreadRadius: 1,
                              //     offset: const Offset(0, 8),
                              //   ),
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.65),
                              //     blurRadius: 18,
                              //     offset: const Offset(0, 10),
                              //   ),
                              // ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Key Availability",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() => AvailabilityCard(
                                        onTap: () => Get.to(KeyTransactionsPage()),
                                        title: "Android",
                                        count: c.keyBalance.value.toString(),
                                        iconPath: "assets/icons/android2.svg",
                                        stripColor: const Color(0xFF00D1FF),
                                        iconBg: const Color(0xFF00D1FF),
                                        titleColor: Colors.white,
                                      )),
                                    ),

                                    // const SizedBox(width: 12),
                                    //
                                    // Expanded(
                                    //   child: AvailabilityCard(
                                    //     onTap: () {},
                                    //     title: "iPhone",
                                    //     count: "0",
                                    //     iconPath: "assets/icons/apple.svg",
                                    //     stripColor: const Color(0xFF3FA9F5),
                                    //     iconBg: const Color(0xFF3FA9F5),
                                    //     titleColor: Colors.white,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 0),

                          // const SizedBox(height: 20),

                          // SvgPicture.asset(
                          //   'assets/images/banner.svg',
                          //   width: size.width,
                          //   fit: BoxFit.cover,
                          // ),

                          // SizedBox(
                          //   width: size.width,
                          //   child: Stack(
                          //     children: [
                          //       /// 🔹 ORIGINAL SVG (NO CHANGE)
                          //       SvgPicture.asset(
                          //         'assets/images/banner.svg',
                          //         width: size.width,
                          //         fit: BoxFit.cover,
                          //       ),
                          //
                          //       /// 🔹 OVERLAY TEXT (REPLACE "By Z Lock")
                          //       Positioned(
                          //
                          //         left: 0,
                          //         right: 280,
                          //         bottom: size.height * 0.16, // 🔥 responsive position
                          //         child: Center(
                          //           child: Container(
                          //             height: 50,
                          //             color: AppColors.topBgColour,
                          //             child: Text(
                          //               "Core Connect",
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: size.width * 0.036, // 🔥 responsive text
                          //                 fontWeight: FontWeight.w600,
                          //                 shadows: [
                          //                   Shadow(
                          //                     blurRadius: 6,
                          //                     color: Colors.black.withOpacity(0.6),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _dashboardKeySection({
    required String title,
    required int value,
    required Map<String, int> stats,
  }) {
    final active = stats["active"] ?? 0;
    final lock = stats["lock"] ?? 0;
    final remove = stats["remove"] ?? 0;
    final pending = stats["pending"] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          /// 🔥 MAIN CARD
          Container(
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 14),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
            //
            //   gradient: const LinearGradient(
            //     colors: [
            //       Color(0xFF1A1A1A),
            //       Color(0xFF0D0D0D),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //
            //   border: Border.all(
            //     color: const Color(0x33D4AF37),
            //   ),
            //
            //   boxShadow: [
            //     BoxShadow(
            //       color: const Color(0xFFD4AF37).withOpacity(0.25),
            //       blurRadius: 16,
            //       offset: const Offset(0, 8),
            //     ),
            //   ],
            // ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1C1C1C),
                  Color(0xFF0A0A0A),
                ],
              ),

              border: Border.all(
                color: const Color(0x66D9B65A),
                width: 1.2,
              ),

              // boxShadow: [
              //   BoxShadow(
              //     color: const Color(0xFFD9B65A).withOpacity(0.30),
              //     blurRadius: 22,
              //     spreadRadius: 1,
              //     offset: const Offset(0, 8),
              //   ),
              // ],
            ),
            child: Column(
              children: [

                /// HEADER
                Row(
                  children: [
                    const SizedBox(width: 40), // 🔥 space for floating icon

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 🔥 MINI CARDS
                Row(
                  children: [
                    _miniCard(
                      "Active",
                      active,
                      const Color(0xffE6F6EC),
                          () => openCustomerList(
                        sectionTitle: title,
                        status: "active",
                      ),
                    ),
                    _miniCard(
                      "Lock",
                      lock,
                      const Color(0xffFFF3E0),
                          () => openCustomerList(
                        sectionTitle: title,
                        status: "lock",
                      ),
                    ),
                    _miniCard(
                      "Remove",
                      remove,
                      const Color(0xffFFEAEA),
                          () => openCustomerList(
                        sectionTitle: title,
                        status: "remove",
                      ),
                    ),
                    _miniCard(
                      "Pending",
                      pending,
                      const Color(0xffE3F2FD),
                          () => openCustomerList(
                        sectionTitle: title,
                        status: "pending",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          /// 🔥 FLOATING ICON (TOP LEFT SAME DESIGN)
          Positioned(
            top: -18,
            left: 12,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                // gradient: const LinearGradient(
                //   colors: [
                //     Color(0xFFD4AF37),
                //     Color(0xFFF5D76E),
                //   ],
                // ),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF4E19C), // highlight
                    Color(0xFFD9B65A), // UniQ gold
                    Color(0xFFB8860B), // dark metallic gold
                  ],
                ),

                border: Border.all(
                  color: Color(0x80FFF4C2),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x99D9B65A),
                    blurRadius: 25,
                  )
                ],
              ),
              child: const Icon(
                Icons.vpn_key,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _miniCard(
      String title,
      int value,
      Color bg,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: InkWell(
        onTap: onTap, // 🔥 CLICK FIXED
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //
          //   color: bg,
          //   borderRadius: BorderRadius.circular(12),
          // ),
          // decoration: BoxDecoration(
          //   color: Colors.white.withOpacity(0.1),
          //   borderRadius: BorderRadius.circular(12),
          // ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0x33D4AF37)),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,

                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
  int _getKeyType(String sectionTitle) {
    if (sectionTitle.toLowerCase().contains("android")) {
      return 1;
    } else if (sectionTitle.toLowerCase().contains("running")) {
      return 3;
    }
    return 1; // default safe
  }
  void _navigateToList(String sectionTitle, String status) {
    final keyType = _getKeyType(sectionTitle);

    Get.to(
      CustomerListingV2Page(title: sectionTitle),
      arguments: {
        "sectionTitle": sectionTitle,
        "type": status,

        /// 🔥 IMPORTANT (FIX)
        "key_type": keyType,
      },
    );
  }

  void openCustomerList({
    required String sectionTitle,
    required String status,
  }) {
    int keyType = 1;

    if (sectionTitle.toLowerCase().contains("running")) {
      keyType = 2;
    } else if (sectionTitle.toLowerCase().contains("iphone")) {
      keyType = 3;
    }

    Get.to(
      CustomerListingV2Page(title: "$sectionTitle - $status"),
      arguments: {
        "type": status.toLowerCase(), // ✅ FIX
        "key_type": keyType,                // ✅ FIX
        "title": sectionTitle,
      },
    );
  }
  // Widget _modernStatCard({
  //   required String title,
  //   required String iconPath,
  //   required RxInt valueRx,
  //   required VoidCallback onTap,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(right: 13),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(18),
  //       onTap: onTap,
  //       child: Container(
  //         width: 110,
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //
  //           /// 🔥 GLASS + 3D EFFECT
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               // Colors.white,
  //               // const Color(0xFFF1F4FF),
  //               Color(0xFF0F4C97),
  //               Color(0xFF0B2A76),
  //
  //             ],
  //           ),
  //
  //           boxShadow: [
  //             /// light shadow (top)
  //             // BoxShadow(
  //             //   color: Colors.white.withOpacity(0.9),
  //             //   offset: const Offset(-3, -3),
  //             //   blurRadius: 6,
  //             // ),
  //
  //             /// dark shadow (bottom)
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.08),
  //               offset: const Offset(4, 6),
  //               blurRadius: 12,
  //             ),
  //           ],
  //
  //           border: Border.all(color: Colors.white.withOpacity(0.6)),
  //         ),
  //
  //         child: Obx(() {
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //
  //               /// ICON
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     height: 30,
  //                     width: 30,
  //                     decoration: BoxDecoration(
  //
  //                       gradient: const LinearGradient(
  //                         colors: [Color(0xFFEAF0FF), Color(0xFFDDE6FF)],
  //                       ),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Center(
  //                       child: SvgPicture.asset(
  //                         iconPath,
  //                         height: 20,
  //                         width: 20,
  //                       ),
  //                     ),
  //                   ),
  //                   /// VALUE
  //                   Text(
  //                     valueRx.value.toString(),
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //
  //                 ],
  //               ),
  //
  //               // const Spacer(),
  //
  //               /// TITLE
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 9.5,
  //                   overflow: TextOverflow.ellipsis,
  //
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //
  //
  //             ],
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }
  Widget _modernStatCard({
    required String title,
    required String iconPath,
    required RxInt valueRx,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            /// 🔥 MAIN CARD
            Container(
              width: 115,
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //
              //   gradient: const LinearGradient(
              //     colors: [
              //       Color(0xFF1A1A1A),
              //       Color(0xFF0D0D0D),
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //
              //   border: Border.all(
              //     color: const Color(0x33D4AF37),
              //   ),
              //
              //   boxShadow: [
              //     BoxShadow(
              //       color: const Color(0xFFD4AF37).withOpacity(0.25),
              //       blurRadius: 16,
              //       offset: const Offset(0, 8),
              //     ),
              //   ],
              // ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1C1C1C),
                    Color(0xFF0A0A0A),
                  ],
                ),

                border: Border.all(
                  color: const Color(0x66D9B65A), // Logo gold border
                  width: 1.2,
                ),

                // boxShadow: [
                //   BoxShadow(
                //     color: const Color(0xFFD9B65A).withOpacity(0.35),
                //     blurRadius: 22,
                //     spreadRadius: 1,
                //     offset: const Offset(0, 8),
                //   ),
                // ],
              ),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// VALUE
                    Text(
                      valueRx.value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            ),

            /// 🔥 FLOATING ICON (TOP)
            // Positioned(
            //   top: -18,
            //   left: 12,
            //   child: Container(
            //     height: 38,
            //     width: 38,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //
            //       gradient: const LinearGradient(
            //         colors: [
            //           Color(0xFFD4AF37),
            //           Color(0xFFF5D76E),
            //         ],
            //       ),
            //
            //       boxShadow: [
            //         BoxShadow(
            //           color: const Color(0xFFD4AF37).withOpacity(0.6),
            //           blurRadius: 10,
            //         )
            //       ],
            //     ),
            //     child: Center(
            //       child: SvgPicture.asset(
            //         iconPath,
            //         height: 18,
            //         width: 18,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            /// 🔥 FLOATING ICON (TOP)
            Positioned(
              top: -18,
              left: 12,
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF4E19C), // highlight gold
                      Color(0xFFD9B65A), // main UniQ gold
                      Color(0xFFB8860B), // dark metallic gold
                    ],
                  ),

                  border: Border.all(
                    color: Color(0x80FFF4C2),
                    width: 0.8,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66D9B65A),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    height: 18,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openNewKey(NewKeyEntry entry, String title) {
  Get.to(
        () => NewKeyScreen(entry: entry, title: title),
    binding: BindingsBuilder(() {
      // ✅ har entry ka apna controller instance
      Get.put(NewKeyController(entry: entry), tag: entry.name);
    }),
  );
}

/// Stat card widget (small rounded)
class StatCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final RxInt valueRx;
  final VoidCallback onTap;


  const StatCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.valueRx,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.22;
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 90,
        // width: 83,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF5F7FF), // light blue tint same as screenshot
            ],
          ),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON BOX
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF), // light bg for icon
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // TITLE
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A2B6B),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              // VALUE
              Text(
                valueRx.value.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}


class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final RetailerDashboardController c = Get.find();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Obx(() {
            final banners = c.bannerList;

            return PageView.builder(
              controller: c.pageController,
              itemCount: banners.isEmpty ? 1 : banners.length,
              onPageChanged: (index) => c.currentBanner.value = index,
              itemBuilder: (context, index) {
                final image = banners.isEmpty
                    ? "assets/images/lock_pe.png"
                    : banners[index];

                return _BannerCard(imagePath: image);
              },
            );
          }),
        ),

        const SizedBox(height: 12),

        /// 🔥 Premium Dot Indicator
        Obx(() {
          final total = c.bannerList.isEmpty ? 1 : c.bannerList.length;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: c.currentBanner.value == i ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: c.currentBanner.value == i
                      ? AppColors.primaryDark
                      : AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String imagePath;
  const _BannerCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isNetwork = imagePath.startsWith("http");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          /// 🔥 Premium Shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        /// 🔥 IMPORTANT: Clip AFTER container (not before padding)
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: isNetwork
              ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/lock_pe.png",
                fit: BoxFit.cover,
              );
            },
          )
              : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}


class FeatureCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<Color> gradient;
  final Color bgColor;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.gradient,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            /// 🔥 MAIN CARD
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //
              //   gradient: const LinearGradient(
              //     colors: [
              //       Color(0xFF1A1A1A),
              //       Color(0xFF0D0D0D),
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //
              //   border: Border.all(
              //     color: const Color(0x33D4AF37),
              //   ),
              //
              //   boxShadow: [
              //     BoxShadow(
              //       color: const Color(0xFFD4AF37).withOpacity(0.25),
              //       blurRadius: 16,
              //       offset: const Offset(0, 8),
              //     ),
              //   ],
              // ),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1C1C1C),
                    Color(0xFF0A0A0A),
                  ],
                ),

                border: Border.all(
                  color: const Color(0x66D9B65A), // Logo gold border
                  width: 1.2,
                ),

                // boxShadow: [
                //   BoxShadow(
                //     color: const Color(0xFFD9B65A).withOpacity(0.35),
                //     blurRadius: 22,
                //     spreadRadius: 1,
                //     offset: const Offset(0, 8),
                //   ),
                // ],
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.width * 0.028,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            /// 🔥 FLOATING ICON (TOP SAME AS FIRST ROW)
            Positioned(
              top: -18,
              left: 12,
              child: Container(
                height: 40,
                width: 40,
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //
                //   gradient: const LinearGradient(
                //     colors: [
                //       Color(0xFFD4AF37),
                //       Color(0xFFF5D76E),
                //     ],
                //   ),
                //
                //   boxShadow: [
                //     BoxShadow(
                //       color: const Color(0xFFD4AF37).withOpacity(0.6),
                //       blurRadius: 12,
                //     )
                //   ],
                // ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF4E19C), // highlight gold
                      Color(0xFFD9B65A), // main UniQ gold
                      Color(0xFFB8860B), // dark metallic gold
                    ],
                  ),

                  border: Border.all(
                    color: Color(0x80FFF4C2),
                    width: 0.8,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66D9B65A),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                    color: Colors.black, // 🔥 premium look
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock, size: 32, color: Colors.black54),
          SizedBox(height: 10),
          Text(
            "Coming Soon",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AvailabilityCard extends StatelessWidget {
  final String title;
  final String count;
  final String iconPath;
  final Color stripColor;
  final Color iconBg;
  final Color titleColor;
  final VoidCallback onTap;

  const AvailabilityCard({
    super.key,
    required this.title,
    required this.count,
    required this.iconPath,
    required this.stripColor,
    required this.iconBg,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            /// 🔥 MAIN CARD
            Container(
              height: 85,
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(18),
              //
              //   gradient: const LinearGradient(
              //     colors: [
              //       Color(0xFF1A1A1A),
              //       Color(0xFF0D0D0D),
              //     ],
              //   ),
              //
              //   border: Border.all(
              //     color: const Color(0x33D4AF37),
              //   ),
              //
              //   boxShadow: [
              //     BoxShadow(
              //       color: const Color(0xFFD4AF37).withOpacity(0.25),
              //       blurRadius: 14,
              //       offset: const Offset(0, 6),
              //     ),
              //   ],
              // ),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1C1C1C),
                    Color(0xFF0A0A0A),
                  ],
                ),

                border: Border.all(
                  color: const Color(0x66D9B65A),
                  width: 1.1,
                ),

                // boxShadow: [
                //   BoxShadow(
                //     color: const Color(0xFFD9B65A).withOpacity(0.30),
                //     blurRadius: 20,
                //     spreadRadius: 1,
                //     offset: const Offset(0, 6),
                //   ),
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.60),
                //     blurRadius: 14,
                //     offset: const Offset(0, 8),
                //   ),
                // ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 46), // space for floating icon

                  /// TEXT
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          count,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ARROW
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ],
              ),
            ),

            /// 🔥 FLOATING ICON (SAME STYLE)
            Positioned(
              top: -18,
              left: 12,
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF4E19C),
                      Color(0xFFD9B65A),
                      Color(0xFFB8860B),
                    ],
                  ),

                  border: Border.all(
                    color: Color(0x80FFF4C2),
                    width: 0.8,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0x99D9B65A),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],

              ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}