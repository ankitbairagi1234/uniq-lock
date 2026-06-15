import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/account/HelpCenterPage.dart';
import 'package:zlock_smart_finance/account/account_controller.dart';
import 'package:zlock_smart_finance/account/add_video_banner_screen.dart';
import 'package:zlock_smart_finance/account/contact_support_screen.dart';
import 'package:zlock_smart_finance/account/widget/frp_email_dialog.dart';
import 'package:zlock_smart_finance/account/widget/setting_tile.dart';
import 'package:zlock_smart_finance/account/wishlist_page.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/app/utils/common_bottom_button.dart';
import 'package:zlock_smart_finance/modules/auth/role/role_screen.dart';
import 'package:zlock_smart_finance/modules/distributor/dashboard/distributor_dash_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/key_balance/key_transactions_page.dart';
import 'package:zlock_smart_finance/modules/retailer/wallet_transaction/wallet_transaction_page.dart';
import 'package:zlock_smart_finance/modules/two_factor_auth/all_auth_setup/change_password.dart';

import '../modules/retailer/dashboard/retailer_dashboard_controller.dart';

class RetailAccountPage extends StatelessWidget {
  RetailAccountPage({super.key});

  // final controller = Get.put(AccountController());

  final controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: Column(
        children: [
          /// TOP HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
            decoration: const BoxDecoration(gradient: AppColors.bgTopGradient),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back Button + Title
                Row(
                  children:  [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back, size: 25)),
                    SizedBox(width: 12),
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                /// PROFILE SECTION
                GestureDetector(
                  onTap: controller.onProfileClicked,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Profile image (dynamic + null safe)
                      Obx(() {
                        final image = controller.userImage.value;

                        return CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: (image.isNotEmpty && image.startsWith("http"))
                                ? Image.network(
                              image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return SvgPicture.asset(
                                  "assets/accounts/account.svg",
                                  width: 40,
                                  height: 40,
                                );
                              },
                            )
                                : SvgPicture.asset(
                              "assets/accounts/account.svg",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 16),

                      /// Name + Email (already correct)
                      Expanded(
                        child: Obx(
                              () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${controller.userName.value}!",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1D28),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.email.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),

                /// MAIN SETTINGS
                const SizedBox(height: 15),

                const Text(
                  "Main Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical:0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SettingsTile(
                    icon: "assets/accounts/account.svg",
                    title: "Manage Accounts",
                    onTap: () => controller.onMenuTap("/manageAccount"),
                  ),
                  SettingsTile(
                    icon: "assets/accounts/update.svg", // jo bhi icon ho
                    title: "App Update",
                    onTap: () {
                      final dash = Get.find<RetailerDashboardController>();
                      controller.checkForUpdateManual(dash.appUpdateData);
                    },
                  ),
                  SettingsTile(
                    icon: "assets/accounts/auth.svg",
                    title: "Two-Factor Authentication",
                    onTap: () => controller.onMenuTap("/two_factor_auth"),
                  ),
                  SettingsTile(
                    icon: "assets/accounts/password.svg",
                    title: "Change Password",
                    // onTap: () => controller.onMenuTap("/changePassword"),
                    onTap: () {
                      ChangePasswordDialog.show();
                    },
                  ),
                  SettingsTile(
                    icon: "assets/accounts/email.svg",
                    title: "Custom FRP Email",
                    onTap: () {
                      FrpEmailDialog.show();
                    },
                    // onTap: () => controller.onMenuTap("/customEmail"),
                  ),
                  // SettingsTile(
                  //   icon: "assets/accounts/wishlist.svg",
                  //   title: "Wishlist",
                  //   // onTap: () => controller.onMenuTap("/wishlist"),
                  //   onTap: () {
                  //     // Get.to(WishlistPage());
                  //     Get.snackbar(
                  //       "Wishlist",
                  //       "Coming Soon",
                  //       snackPosition: SnackPosition.BOTTOM,
                  //     );
                  //   },
                  // ),
                  SettingsTile(
                    icon: "assets/accounts/wallet.svg",
                    title: "Wallet",
                    // onTap: () => controller.onMenuTap("/wishlist"),
                    onTap: () {
                      Get.to(WalletTransactionPage());
                      // Get.snackbar(
                      //   "Wallet",
                      //   "Coming Soon",
                      //   snackPosition: SnackPosition.BOTTOM,
                      // );
                    },
                  ),

                  const SizedBox(height: 10),

                  /// SUPPORT & FEEDBACK
                  const Text(
                    "Support & Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // SettingsTile(
                  //   icon: "assets/accounts/info.svg",
                  //   title: "Help Center",
                  //   // onTap: () => controller.onMenuTap("/help"),
                  //   onTap: () {
                  //     Get.to(HelpCenterPage());
                  //   },
                  // ),
                  SettingsTile(
                    icon: "assets/accounts/help.svg",
                    title: "Customer Support",
                    onTap: () {
                      Get.to(() => ContactSupportScreen());
                    },
                    // onTap: () => controller.onMenuTap("/support"),
                  ),
                  SettingsTile(
                    icon: "assets/accounts/add.svg",
                    title: "Advertisement Video",
                    // onTap: () => controller.onMenuTap("/ads"),
                    onTap: () {
                      Get.to(AddVideoBannerScreen());
                      // Get.snackbar(
                      //   "Advertisement",
                      //   "Coming Soon",
                      //   snackPosition: SnackPosition.BOTTOM,
                      // );

                    },
                  ),

                  const SizedBox(height: 135),

                  /// LOGOUT BUTTON
                ],
              ),
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonLogoutBottomButton(
        title: "Logout",
        onTap: () {
          controller.showLogoutSheet(context);
        },
      ),
    );
  }

}

class DistributorAccountPage extends StatelessWidget {
  DistributorAccountPage({super.key});

  final controller = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: Column(
        children: [
          /// TOP HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
            decoration: const BoxDecoration(gradient: AppColors.bgTopGradient),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back Button + Title
                Row(
                  children:  [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back, size: 25)),
                    SizedBox(width: 12),
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // /// PROFILE SECTION
                // GestureDetector(
                //   onTap: controller.onProfileClicked,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       /// Profile image
                //       CircleAvatar(
                //         radius: 35,
                //         backgroundColor: Colors.grey.shade200, // optional
                //         child: SvgPicture.asset("assets/accounts/account.svg",
                //           width: 40,
                //           height: 40,
                //         ),
                //       ),
                //       SizedBox(width: 16),
                //
                //       /// Name + Email
                //       Expanded(
                //         child: Obx(
                //               () => Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Hi, ${controller.userName.value}!",
                //                 style: const TextStyle(
                //                   fontSize: 22,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color(0xFF1B1D28),
                //                 ),
                //               ),
                //               const SizedBox(height: 4),
                //               Text(
                //                 controller.email.value,
                //                 style: const TextStyle(
                //                   fontSize: 14,
                //                   color: Colors.black54,
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //
                //       const Icon(Icons.arrow_forward_ios, size: 20),
                //     ],
                //   ),
                // ),
                /// PROFILE SECTION
                GestureDetector(
                  onTap: controller.onProfileClicked,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Profile image (dynamic + null safe)
                      Obx(() {
                        final image = controller.userImage.value;

                        return CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: (image.isNotEmpty && image.startsWith("http"))
                                ? Image.network(
                              image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return SvgPicture.asset(
                                  "assets/accounts/account.svg",
                                  width: 40,
                                  height: 40,
                                );
                              },
                            )
                                : SvgPicture.asset(
                              "assets/accounts/account.svg",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 16),

                      /// Name + Email (already correct)
                      Expanded(
                        child: Obx(
                              () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${controller.userName.value}!",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1D28),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.email.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 20),
                    ],
                  ),
                ),


                /// MAIN SETTINGS
                const SizedBox(height: 15),

                const Text(
                  "Main Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical:0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SettingsTile(
                    icon: "assets/accounts/account.svg",
                    title: "Manage Accounts",
                    onTap: () => controller.onMenuTap("/manageAccount"),
                  ),
                  SettingsTile(
                    icon: "assets/accounts/update.svg",
                    title: "App Update",
                    onTap: () {
                      final dash = Get.find<DistributorDashController>();

                      controller.checkForUpdateManual(dash.appUpdateData);
                    },
                  ),
                  SettingsTile(
                    icon: "assets/accounts/auth.svg",
                    title: "Two-Factor Authentication",
                    onTap: () => controller.onMenuTap("/two_factor_auth"),
                  ),
                  SettingsTile(
                    icon: "assets/accounts/password.svg",
                    title: "Change Password",
                    // onTap: () => controller.onMenuTap("/changePassword"),
                    onTap: () {
                      ChangePasswordDialog.show();
                    },
                  ),
                  // SettingsTile(
                  //   icon: "assets/accounts/email.svg",
                  //   title: "Custom FRP Email",
                  //   onTap: () {
                  //     FrpEmailDialog.show();
                  //   },
                  //   // onTap: () => controller.onMenuTap("/customEmail"),
                  // ),
                  // SettingsTile(
                  //   icon: "assets/accounts/wishlist.svg",
                  //   title: "Wishlist",
                  //   // onTap: () => controller.onMenuTap("/wishlist"),
                  //   onTap: () {
                  //     Get.to(WishlistPage());
                  //   },
                  // ),

                  const SizedBox(height: 10),

                  /// SUPPORT & FEEDBACK
                  const Text(
                    "Support & Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // SettingsTile(
                  //   icon: "assets/accounts/info.svg",
                  //   title: "Help Center",
                  //   // onTap: () => controller.onMenuTap("/help"),
                  //   onTap: () {
                  //     Get.to(HelpCenterPage());
                  //   },
                  // ),
                  SettingsTile(
                    icon: "assets/accounts/help.svg",
                    title: "Customer Support",
                    onTap: () {
                      Get.to(() => ContactSupportScreen());
                    },
                    // onTap: () => controller.onMenuTap("/support"),
                  ),
                  // SettingsTile(
                  //   icon: "assets/accounts/add.svg",
                  //   title: "Advertisement Video",
                  //   // onTap: () => controller.onMenuTap("/ads"),
                  //   onTap: () {
                  //     Get.to(AddVideoBannerScreen());
                  //   },
                  // ),

                  const SizedBox(height: 135),

                  /// LOGOUT BUTTON
                ],
              ),
            ),
          )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     GestureDetector(
      //       onTap: () {
      //         showLogoutSheet(context);
      //
      //       },
      //       child: Container(
      //         width: MediaQuery.of(context).size.width, // full width
      //         // height: 100,
      //         decoration: const BoxDecoration(
      //             color: Color(0xFFDFE1E7),
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(32),
      //             topRight: Radius.circular(32),
      //           ),
      //         ),
      //         child: Padding(
      //           padding: EdgeInsets.symmetric(vertical: 20,horizontal: 13),
      //           child: Container(
      //             padding: EdgeInsets.symmetric(vertical: 18),
      //             decoration: BoxDecoration(
      //               color: Color(0xFF3153D8),
      //               borderRadius: BorderRadius.circular(50),
      //             ),
      //             alignment: Alignment.center,
      //             child: Text(
      //               "Logout",
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonLogoutBottomButton(
        title: "Logout",
        onTap: () {
          controller.showLogoutSheet(context);
        },
      ),
    );
  }

}

