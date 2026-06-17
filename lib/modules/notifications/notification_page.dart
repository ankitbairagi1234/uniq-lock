import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/account/account_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/retailer_dashboard_controller.dart';
import 'notification_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final NotificationController ctrl =
  Get.put(NotificationController());

  // final AccountController accountController =
  // Get.find<AccountController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          _header(),
          // Expanded(
          //   child: Obx(
          //         () => ListView.builder(
          //       padding:
          //       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          //       itemCount: ctrl.notifications.length,
          //       itemBuilder: (context, index) {
          //         final item = ctrl.notifications[index];
          //         return _notificationCard(item);
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: Obx(
                  () => ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                children: [



                  ...ctrl.notifications.map(
                        (item) => _notificationCard(item),

                  ),
                  const SizedBox(height: 18),

                  // /// APP UPDATE CARD
                  // _appUpdateCard(),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appUpdateCard() {
    return GestureDetector(
      // onTap: () {
      //   final dash = Get.find<RetailerDashboardController>();
      //
      //
      //   accountController.checkForUpdateManual(
      //     dash.appUpdateData,
      //   );
      // },
      onTap: () {
        if (!Get.isRegistered<AccountController>()) {
          Get.put(AccountController());
        }

        final accountController = Get.find<AccountController>();

        final dash = Get.find<RetailerDashboardController>();

        accountController.checkForUpdateManual(
          dash.appUpdateData,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF4E19C),
              Color(0xFFD9B65A),
              Color(0xFFB8860B),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A)
                  .withOpacity(.30),
              blurRadius: 18,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.system_update_alt_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "App Update",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Check for latest version and update your app",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "CHECK",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ---------------- Header ----------------
  // Widget _header() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Color(0xFF1B1B1B),
  //           Color(0xFF0A0A0A),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           onTap: () => Get.back(),
  //           child: Container(
  //             padding: const EdgeInsets.all(10),
  //             decoration: BoxDecoration(
  //               color: const Color(0xFF151515),
  //               shape: BoxShape.circle,
  //               border: Border.all(
  //                 color: const Color(0x55D9B65A),
  //               ),
  //             ),
  //             child: const Icon(
  //               Icons.arrow_back,
  //               size: 18,
  //               color: Color(0xFFD9B65A),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         const Text(
  //           "Notification",
  //           style: TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.w700,
  //             color: Color(0xFFF4E19C),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          /// BACK
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0x55D9B65A),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 18,
                color: Color(0xFFD9B65A),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// TITLE
          const Expanded(
            child: Text(
              "Notification",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF4E19C),
              ),
            ),
          ),

          /// APP UPDATE BUTTON
          GestureDetector(
            onTap: () {
              if (!Get.isRegistered<AccountController>()) {
                Get.put(AccountController());
              }

              final accountController =
              Get.find<AccountController>();

              final dash =
              Get.find<RetailerDashboardController>();

              accountController.checkForUpdateManual(
                dash.appUpdateData,
              );
            },
            child: Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF4E19C),
                    Color(0xFFD9B65A),
                    Color(0xFFB8860B),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD9B65A)
                        .withOpacity(.35),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(
                Icons.system_update_alt_rounded,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ---------------- Notification Card ----------------
  Widget _notificationCard(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x55D9B65A),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Color(0x22D9B65A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                item.icon,
                height: 22,
                width: 22,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF4E19C),
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD9B65A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
