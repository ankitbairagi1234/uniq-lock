import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';
import 'package:zlock_smart_finance/modules/distributor/dashboard/distributor_dash_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/all_transaction_page.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/total_retailer_list_page.dart';
import 'package:zlock_smart_finance/modules/notifications/notification_page.dart';

class DistributorDashboard extends StatelessWidget {
  const DistributorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final DistributorDashController c = Get.put(DistributorDashController());
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
                  AppColors.topBgColour,
                  AppColors.topBgColour
                ],
              )
          ),
          child: SafeArea(
            bottom: true,
            // bottom: false,
            child: Column(
              children: [
                // Top App Frame (thin border look)
                const SizedBox(height: 8),
                // Header row: profile + greeting + notification
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                  child: Row(
                    children: [
                      // profile pic
                      GestureDetector(
                        onTap: () {
                          // Get.toNamed(AppRoutes.RETAIL_ACCOUNT_PAGE);
                          Get.toNamed(AppRoutes.DISTRIBUTOR_ACCOUNT_PAGE);
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
                                'assets/accounts/bell.svg',
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

                const SizedBox(height: 8),
                Expanded(
                  child: 
                  SingleChildScrollView(
                    child: Container(
                      // height: MediaQuery.of(context).size.height*0.8,
                      decoration: BoxDecoration(
                        color: AppColors.topBgColour,
                        // borderRadius: BorderRadius.circular(12),
                        boxShadow: [AppColors.cardShadow],
                      ),
                      // decoration: BoxDecoration(
                      //   color: AppColors.topBgColour,
                      //   borderRadius: BorderRadius.circular(18),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.black.withOpacity(0.08),
                      //       blurRadius: 20,
                      //       offset: const Offset(0, 10),
                      //     ),
                      //     BoxShadow(
                      //       color: Colors.white.withOpacity(0.6),
                      //       blurRadius: 10,
                      //       offset: const Offset(-4, -4),
                      //     ),
                      //   ],
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),


                          // Banner card (left text + right image)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: BannerCarousel(),
                          ),
                    
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // mainAxisSpacing: 16,
                              // crossAxisSpacing: 16,
                              // childAspectRatio: 1.7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2.6, // 🔥 THIS IS KEY (height reduce)
                    
                              children: [
                                StatCard(
                                  // title: "Key Balance",
                                  title: "Available\nKey Balance",
                                  valueRx: c.keyBalance,
                                  onTap: () {
                                    // Get.to(() => const AllTransactionsPage());
                                    Get.to(() => const AllTransactionsPage(), arguments: {
                                      "type": "credit", // ✅ ONLY CREDIT
                                    });
                                  },
                                ),
                                StatCard(
                                  title: "Used Key",
                                  valueRx: c.usedKey,
                                  onTap: () {
                                    // Get.to(() => const AllTransactionsPage());
                                    Get.to(() => const AllTransactionsPage(), arguments: {
                                      "type": "debit", // ✅ ONLY DEBIT
                                    });
                    
                                  },
                                ),
                                // StatCard(
                                //   title: "Total Retailers",
                                //   valueRx: c.totalRetailers,
                                //   onTap: () {
                                //     Get.to(() => const TotalRetailerListPage(title: "Total Retailers List"));
                                //   },
                                // ),
                                // StatCard(
                                //   title: "Active Retailers",
                                //   valueRx: c.activeRetailers,
                                //   onTap: () {
                                //     Get.to(() => const TotalRetailerListPage(title: "Active Retailers List"));
                                //     // Get.to(() => const TotalRetailerListPage(title: "Total Retailers List"));
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Obx(() {
                          //   // if (c.userType.value != "super_distributor") {
                          //   //   return const SizedBox(); // ✅ NO IMPACT
                          //   // }
                          //
                          //   return Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          //     child: GridView.count(
                          //       crossAxisCount: 3,
                          //       shrinkWrap: true,
                          //       physics: const NeverScrollableScrollPhysics(),
                          //       mainAxisSpacing: 10,
                          //       crossAxisSpacing: 10,
                          //       // childAspectRatio: 0.9,
                          //       childAspectRatio: 1.4,
                          //
                          //       children: [
                          //
                          //         /// 🔵 DISTRIBUTOR
                          //         BigCard(
                          //           title: "TOTAL\nDISTRIBUTOR",
                          //           value: c.totalDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Total Distributor"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "ACTIVE\nDISTRIBUTOR",
                          //           value: c.activeDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Active Distributor"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "DEACTIVE\nDISTRIBUTOR",
                          //           value: c.inActiveDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Deactive Distributor"));
                          //           },
                          //         ),
                          //
                          //         /// 🟢 SUB DISTRIBUTOR (FIXED)
                          //         BigCard(
                          //           title: "TOTAL\nSUB DISTRIBUTOR",
                          //           value: c.totalSubDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Total Distributor"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "ACTIVE\nSUB DISTRIBUTOR",
                          //           value: c.activeSubDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Active Sub Distributor"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "DEACTIVE\nSUB DISTRIBUTOR",
                          //           value: c.inActiveSubDistributor,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Deactive Sub Distributor"));
                          //           },
                          //         ),
                          //
                          //         /// 🟣 RETAILERS
                          //         BigCard(
                          //           title: "TOTAL\nRETAILERS",
                          //           value: c.totalRetailers,
                          //           onTap: () {
                          //             // Get.to(() => const TotalRetailerListPage(title: "Total Retailer"));
                          //             Get.to(() => const TotalRetailerListPage(title: "Total Retailer"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "ACTIVE\nRETAILERS",
                          //           value: c.activeRetailers,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Active Retailer"));
                          //
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "DEACTIVE\nRETAILERS",
                          //           value: c.inActiveRetailers,
                          //
                          //           onTap: () {
                          //             // Get.to(() => const TotalRetailerListPage(title: "Deactive Retailer List"));
                          //             Get.to(() => const TotalRetailerListPage(title: "Deactive Retailer"));
                          //
                          //           },
                          //         ),
                          //         /// 🟣 SUB RETAILERS
                          //         BigCard(
                          //           title: "TOTAL\nSUB-RETAILERS",
                          //           value: c.totalRetailers,
                          //           onTap: () {
                          //             // Get.to(() => const TotalRetailerListPage(title: "Total Retailer"));
                          //             Get.to(() => const TotalRetailerListPage(title: "Total Retailer"));
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "ACTIVE\nSUB-RETAILERS",
                          //           value: c.activeRetailers,
                          //           onTap: () {
                          //             Get.to(() => const TotalRetailerListPage(title: "Active Retailer"));
                          //
                          //           },
                          //         ),
                          //         BigCard(
                          //           title: "DEACTIVE\nSUB-RETAILERS",
                          //           value: c.inActiveRetailers,
                          //
                          //           onTap: () {
                          //             // Get.to(() => const TotalRetailerListPage(title: "Deactive Retailer List"));
                          //             Get.to(() => const TotalRetailerListPage(title: "Deactive Retailer"));
                          //
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }),
                          Obx(() {
                            final type = c.userType.value;

                            /// 🔴 SUPER DISTRIBUTOR → ALL CARDS
                            if (type == "super_distributor") {
                              return _buildGrid([
                                /// DISTRIBUTOR
                                _card("TOTAL\nDISTRIBUTOR", c.totalDistributor, "Total Distributor"),
                                _card("ACTIVE\nDISTRIBUTOR", c.activeDistributor, "Active Distributor"),
                                _card("DEACTIVE\nDISTRIBUTOR", c.inActiveDistributor, "Deactive Distributor"),

                                /// SUB DISTRIBUTOR
                                _card("TOTAL\nSUB DISTRIBUTOR", c.totalSubDistributor, "Total Sub Distributor"),
                                _card("ACTIVE\nSUB DISTRIBUTOR", c.activeSubDistributor, "Active Sub Distributor"),
                                _card("DEACTIVE\nSUB DISTRIBUTOR", c.inActiveSubDistributor, "Deactive Sub Distributor"),

                                /// RETAILER
                                _card("TOTAL\nRETAILERS", c.totalRetailers, "Total Retailer"),
                                _card("ACTIVE\nRETAILERS", c.activeRetailers, "Active Retailer"),
                                _card("DEACTIVE\nRETAILERS", c.inActiveRetailers, "Deactive Retailer"),

                                /// SUB RETAILER
                                _card("TOTAL\nSUB-RETAILERS", c.totalRetailers, "Total Sub-Retailer"),
                                _card("ACTIVE\nSUB-RETAILERS", c.activeRetailers, "Active Sub-Retailer"),
                                _card("DEACTIVE\nSUB-RETAILERS", c.inActiveRetailers, "Deactive Sub-Retailer"),
                              ]);
                            }

                            /// 🟡 DISTRIBUTOR
                            if (type == "distributor") {
                              return _buildGrid([
                                /// SUB DISTRIBUTOR
                                _card("TOTAL\nSUB DISTRIBUTOR", c.totalSubDistributor, "Total Sub Distributor"),
                                _card("ACTIVE\nSUB DISTRIBUTOR", c.activeSubDistributor, "Active Sub Distributor"),
                                _card("DEACTIVE\nSUB DISTRIBUTOR", c.inActiveSubDistributor, "Deactive Sub Distributor"),

                                /// RETAILER
                                _card("TOTAL\nRETAILERS", c.totalRetailers, "Total Retailer"),
                                _card("ACTIVE\nRETAILERS", c.activeRetailers, "Active Retailer"),
                                _card("DEACTIVE\nRETAILERS", c.inActiveRetailers, "Deactive Retailer"),

                                /// SUB RETAILER
                                _card("TOTAL\nSUB-RETAILERS", c.totalSubRetailers, "Total Sub-Retailer"),
                                _card("ACTIVE\nSUB-RETAILERS", c.activeSubRetailers, "Active Sub-Retailer"),
                                _card("DEACTIVE\nSUB-RETAILERS", c.inActiveSubRetailers, "Deactive Sub-Retailer"),
                              ]);
                            }

                            /// 🟢 SUB DISTRIBUTOR
                            if (type == "sub_distributor") {
                              return _buildGrid([
                                /// RETAILER
                                _card("TOTAL\nRETAILERS", c.totalRetailers, "Total Retailer"),
                                _card("ACTIVE\nRETAILERS", c.activeRetailers, "Active Retailer"),
                                _card("DEACTIVE\nRETAILERS", c.inActiveRetailers, "Deactive Retailer"),

                                /// SUB RETAILER
                                _card("TOTAL\nSUB-RETAILERS", c.totalRetailers, "Total Sub-Retailer"),
                                _card("ACTIVE\nSUB-RETAILERS", c.activeRetailers, "Active Sub-Retailer"),
                                _card("DEACTIVE\nSUB-RETAILERS", c.inActiveRetailers, "Deactive Sub-Retailer"),
                              ]);
                            }

                            return const SizedBox();
                          }),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FeatureCard(
                                    title: "Active\nActivations",
                                    iconPath: "assets/icons/active_retailer.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white,Color(0xFFF5F8FF)],
                                    onTap: () {
                                      Get.to(() => const TotalRetailerListPage(title: "Active Retailers List"));
                                    },
                    
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FeatureCard(
                                    title: "Today's\nRetailers",
                                    iconPath: "assets/icons/calender.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white,Color(0xFFF5F8FF)],
                                    onTap: () {
                                      Get.to(() => const TotalRetailerListPage(title: "Today Retailers List"));
                                    },
                    
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FeatureCard(
                                    title: "Total\nRetailers",
                                    iconPath: "assets/icons/three_retailer.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white,Color(0xFFF5F8FF)],
                                    onTap: () {
                                      Get.to(() => const TotalRetailerListPage(title: "Total Retailers List"));
                                    },
                    
                                  ),
                                ),
                              ],
                            ),
                          ),
                    
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "B2B\nOrder",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [Colors.white,Color(0xFFFFDBD8), ],
                                //     onTap: () => Get.to(ProductListPage()),
                                //   ),
                                // ),
                                Expanded(
                                  child: FeatureCard(
                                    title: "B2B\nOrder",
                                    iconPath: "assets/icons/loan_zone.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white, Color(0xFFFFDBD8)],
                                    onTap: () {
                                      // Get.to(ProductListPage()); // temporarily disabled
                    
                                      Get.snackbar(
                                        "B2B Order",
                                        "Coming Soon",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Expanded(
                                //   child: FeatureCard(
                                //     title: "Loan\nZone",
                                //     iconPath: "assets/icons/loan_zone.svg",
                                //     bgColor: const Color(0xFFEBEFFF),
                                //     gradient: const [ Colors.white,Color(0xFFDFD3FF),],
                                //     onTap: () => Get.to(AddIphoneKeyScreen()),
                                //   ),
                                // ),
                                Expanded(
                                  child: FeatureCard(
                                    title: "Loan\nZone",
                                    iconPath: "assets/icons/loan_zone.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white, Color(0xFFDFD3FF)],
                                    onTap: () async {
                                      // Get.to(AddIphoneKeyScreen()); // temporarily disabled
                    
                                      final url = Uri.parse("https://indiasales.club/");
                                      await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                                Expanded(
                                  child: FeatureCard(
                                    // title: "Pro\nConnect",
                                    title: "Easy\nEMI",
                                    iconPath: "assets/icons/loan_zone.svg",
                                    bgColor: const Color(0xFFEBEFFF),
                                    gradient: const [Colors.white, Color(0xFFCDFBEB)],
                                    onTap: () async {
                                      final url = Uri.parse(
                                        "https://app.lendbox.in/sahukar/login?partnerName=LOCKPE%20PRO",
                                      );
                    
                                      await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 50),
                    
                          // SvgPicture.asset(
                          //   'assets/images/banner.svg',
                          //   width: size.width,
                          //   fit: BoxFit.cover,
                          // ),
                    
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
}
Widget _buildGrid(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: children,
    ),
  );
}

Widget _card(String title, RxInt value, String routeTitle) {
  return BigCard(
    title: title,
    value: value,
    onTap: () {
      Get.to(() => TotalRetailerListPage(title: routeTitle));
    },
  );
}
class BigCard extends StatelessWidget {
  final String title;
  final RxInt value;
  final VoidCallback onTap;

  const BigCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // gradient: const LinearGradient(
          //
          //   colors: [
          //     // Color(0xFFE8F0FF), Color(0xFFDCE6FF)
          //     Color(0xFF1F3BB3), // 🔵 DARK BLUE
          //     Color(0xFF2C56D6),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.white,

        ),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Stat card widget (small rounded)
// class StatCard extends StatelessWidget {
//   final String title;
//   final RxInt valueRx;
//   final VoidCallback onTap;
//
//   const StatCard({
//     super.key,
//     required this.title,
//     required this.valueRx,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFFFFFFF),
//               Color(0xFFF4F7FF),
//             ],
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x14000000),
//               blurRadius: 10,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Obx(() {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// TITLE + ICON
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Color(0xFF1F3BB3),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Container(
//                     height: 26,
//                     width: 26,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Color(0xFF1F3BB3),
//                         width: 1,
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_outward_rounded,
//                       size: 16,
//                       color: Color(0xFF1F3BB3),
//                     ),
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               /// VALUE
//               Text(
//                 valueRx.value.toString(),
//                 style: const TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

class StatCard extends StatelessWidget {
  final String title;
  final RxInt valueRx;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.valueRx,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55, // 🔥 fixed small height
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Obx(() {
          return Row(
            children: [
              /// LEFT TEXT
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      valueRx.value.toString(),
                      style: const TextStyle(
                        fontSize: 16, // 🔥 compact value
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT ICON
              Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F3BB3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_outward_rounded,
                  size: 14,
                  color: Color(0xFF1F3BB3),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
/// Banner with left text and right image
class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final DistributorDashController c = Get.find();

    return Column(
      children: [
        SizedBox(
          height: 182,
          child: Obx(() {
            final banners = c.bannerList;

            return PageView.builder(
              controller: c.pageController,
              itemCount: banners.isEmpty ? 1 : banners.length,
              onPageChanged: (index) => c.currentBanner.value = index,
              itemBuilder: (context, index) {
                // ✅ fallback image (IMPORTANT)
                if (banners.isEmpty) {
                  return _BannerCard(
                    imagePath: "assets/images/lock_pe.png",
                  );
                }

                return _BannerCard(imagePath: banners[index]);
              },
            );
          }),
        ),

        const SizedBox(height: 10),

        // ✅ DOT INDICATOR FIX
        Obx(() {
          final banners = c.bannerList;

          if (banners.isEmpty) return const SizedBox();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: c.currentBanner.value == i ? 14 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: c.currentBanner.value == i
                      ? AppColors.primaryDark
                      : AppColors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: isNetwork
            ? Image.network(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
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

  // ✅ optional count
  final RxInt? valueRx;

  const FeatureCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.gradient,
    required this.bgColor,
    required this.onTap,
    this.valueRx,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(iconPath, height: 22, width: 22),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_outward, size: 18),
                ),

              ],
            ),

            const Spacer(),

            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

            // ✅ count
            if (valueRx != null) ...[
              const SizedBox(height: 6),
              Obx(() => Text(
                valueRx!.value.toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              )),
            ],

            const SizedBox(height: 5),
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

  const AvailabilityCard({
    super.key,
    required this.title,
    required this.count,
    required this.iconPath,
    required this.stripColor,
    required this.iconBg,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(1, 4),
          )
        ],
        color: Colors.white,
      ),
      child: Stack(
        children: [
          // LEFT COLOR STRIP
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 14,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 14),
            child: Row(
              children: [
                // ICON BOX
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      height: 22,
                      width: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // TEXT AREA
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        count,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_outward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
