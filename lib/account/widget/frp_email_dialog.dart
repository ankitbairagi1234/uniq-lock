import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/account/frp_email_controller.dart';

class FrpEmailDialog {
  static void show() {
    final ctrl = Get.put(FrpEmailController());

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(bottom: 22),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(32),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.12),
            //       blurRadius: 18,
            //       offset: const Offset(0, 6),
            //     ),
            //   ],
            // ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD9B65A).withOpacity(.15),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ======= TITLE BAR =======
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24), // balance
                      const Text(
                        "Custom FRP Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF4E19C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                        Icons.close,
                        size: 26,
                        color: Color(0xFFD9B65A),
                      )),
                    ],
                  ),
                ),

                // Divider line
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 20),

                // ======= INPUT FIELD =======
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 22),
                //   padding: const EdgeInsets.symmetric(horizontal: 18),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(40),
                //     border: Border.all(
                //       color: const Color(0xFFE2E2E2),
                //       width: 1.3,
                //     ),
                //   ),
                //   child: TextField(
                //     controller: ctrl.emailController,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: const InputDecoration(
                //       hintText: "Enter email here",
                //       border: InputBorder.none,
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: const Color(0x55D9B65A),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD9B65A).withOpacity(.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: ctrl.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    cursorColor: const Color(0xFFD9B65A),
                    decoration: const InputDecoration(
                      hintText: "Enter email here",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 22),
                //   padding: const EdgeInsets.symmetric(horizontal: 18),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(40),
                //     border: Border.all(
                //       color: const Color(0xFFE2E2E2),
                //       width: 1.3,
                //     ),
                //   ),
                //   child: TextField(
                //     controller: ctrl.idController,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: const InputDecoration(
                //       hintText: "Enter Id",
                //       border: InputBorder.none,
                //     ),
                //   ),
                // ),


                const SizedBox(height: 28),

                // ======= SAVE BUTTON =======
                Obx(() {
                  return GestureDetector(
                    onTap: ctrl.isSaving.value ? null : ctrl.saveEmail,
                    child: Container(
                      width: Get.width * 0.75,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF4E19C),
                            Color(0xFFD9B65A),
                            Color(0xFFB8860B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: ctrl.isSaving.value
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
