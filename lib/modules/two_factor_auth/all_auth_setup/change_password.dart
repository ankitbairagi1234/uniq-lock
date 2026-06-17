import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';
import 'package:zlock_smart_finance/app/services/distributor_key_transfer_service.dart';
import 'package:zlock_smart_finance/model/key_transfer_models.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_details_controller.dart';
import 'change_password_controller.dart';

class ChangePasswordDialog {
  static void show() {
    final ctrl = Get.put(ChangePasswordController());

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              // color: Colors.white,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== HEADER =====
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24), // Keep title centered
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF4E19C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.close,
                          size: 26,
                          color: Color(0xFFD9B65A),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: const Color(0x33D9B65A),
                ),

                const SizedBox(height: 20),

                // ===== THREE INPUT FIELDS =====

                _inputField(
                  controller: ctrl.currentPassword,
                  hint: "Current Password",
                  visibility: ctrl.isCurrentVisible,
                ),

                const SizedBox(height: 10),

                _inputField(
                  controller: ctrl.newPassword,
                  hint: "New Password",
                  visibility: ctrl.isNewVisible,
                ),

                // _inputField(
                //   controller: ctrl.confirmPassword,
                //   hint: "Confirm Password",
                //   visibility: ctrl.isConfirmVisible,
                // ),
                const SizedBox(height: 26),

                // ===== SAVE BUTTON =====
                Obx(() {
                  return GestureDetector(
                    onTap: ctrl.isSaving.value ? null : ctrl.savePassword,
                    child: Container(
                      width: Get.width * 0.75,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // color: const Color(0xFF3B5AF6),
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
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
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

  // ===== INPUT FIELD WIDGET =====
  static Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required RxBool visibility,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(40),
      //   border: Border.all(
      //     color: const Color(0xFFE2E2E2),
      //     width: 1.3,
      //   ),
      // ),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color(0x55D9B65A),
          width: 1.2,
        ),
      ),
      child: Obx(() {
        return TextField(
          controller: controller,
          obscureText: !visibility.value,
          // decoration: InputDecoration(
          //   hintText: hint,
          //   border: InputBorder.none,
          //
          //   /// 👁️ EYE ICON
          //   suffixIcon: IconButton(
          //     icon: Icon(
          //       visibility.value
          //           ? Icons.visibility
          //           : Icons.visibility_off,
          //     ),
          //     onPressed: () {
          //       visibility.value = !visibility.value;
          //     },
          //   ),
          // ),
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                visibility.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: const Color(0xFFD9B65A),
              ),
              onPressed: () {
                visibility.value = !visibility.value;
              },
            ),
          ),
        );
      }),
    );
  }

}
class ChangePasswordDialogForRetailer {
  static void show(String retailerId) {
    final ctrl = Get.put(ChangePasswordRetailerController(retailerId));

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              // color: Colors.white,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== HEADER =====
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24), // Keep title centered
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF4E19C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.close,
                          size: 26,
                          color: Color(0xFFD9B65A),
                        )
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 20),

                // ===== THREE INPUT FIELDS =====

                // _inputField(
                //   controller: ctrl.currentPassword,
                //   hint: "Current Password",
                //   visibility: ctrl.isCurrentVisible,
                // ),

                const SizedBox(height: 10),

                _inputField(
                  controller: ctrl.newPassword,
                  hint: "New Password",
                  visibility: ctrl.isNewVisible,
                ),
                const SizedBox(height: 10),


                _inputField(
                  controller: ctrl.confirmPassword,
                  hint: "Confirm Password",
                  visibility: ctrl.isConfirmVisible,
                ),
                const SizedBox(height: 26),

                // ===== SAVE BUTTON =====
                Obx(() {
                  return GestureDetector(
                    onTap: ctrl.isSaving.value ? null : ctrl.savePassword,
                    child: Container(
                      width: Get.width * 0.75,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // color: const Color(0xFF3B5AF6),
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

  // ===== INPUT FIELD WIDGET =====
  static Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required RxBool visibility,
  }) {
    return Container(
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
      child: Obx(() {
        return TextField(
          controller: controller,
          obscureText: !visibility.value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          cursorColor: const Color(0xFFD9B65A),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
            border: InputBorder.none,

            /// 👁️ EYE ICON
            suffixIcon: IconButton(
              icon: Icon(
                visibility.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: const Color(0xFFD9B65A),
              ),
              onPressed: () {
                visibility.value = !visibility.value;
              },
            ),
          ),
        );
      }),
    );
  }
}

class CreditDebitDialog {
  static void show(
      String text,
      RetailerController controller,
      RetailerDetailsController detailsC,
      ) {
    final isCredit = text.toLowerCase().contains("credit");

    // ✅ correct controller field use
    final TextEditingController amountCtrl =
    isCredit ? controller.creditCtrl : controller.debitCtrl;

    final _service = DistributorKeyTransferService();

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              // color: Colors.white,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== HEADER =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF4E19C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!controller.isSaving.value) Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 26,
                          color: Color(0xFFD9B65A),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(height: 1, color: Colors.grey.shade300),
                const SizedBox(height: 20),

                // ===== INPUT =====
                _inputField(
                  controller: amountCtrl,
                  hint: "Enter $text Amount",
                ),
                const SizedBox(height: 26),

                // ===== SAVE BUTTON =====
                Obx(() {
                  final loading = controller.isSaving.value;

                  return GestureDetector(
                    // onTap: loading
                    //     ? null
                    //     : () async {
                    //   final qty = int.tryParse(amountCtrl.text.trim()) ?? 0;
                    //   if (qty <= 0) {
                    //     Get.snackbar(
                    //       "Invalid",
                    //       "Please enter a valid amount",
                    //       snackPosition: SnackPosition.BOTTOM,
                    //     );
                    //     return;
                    //   }
                    //
                    //   // ✅ retailerId from details controller (no Get.find)
                    //   final retailerId = detailsC.details.value?.retailerId ?? "";
                    //   if (retailerId.isEmpty) {
                    //     Get.snackbar(
                    //       "Error",
                    //       "Retailer ID not found",
                    //       snackPosition: SnackPosition.BOTTOM,
                    //     );
                    //     return;
                    //   }
                    //
                    //   controller.isSaving.value = true;
                    //
                    //   try {
                    //     final req = KeyTransferRequest(
                    //       retailerId: retailerId,
                    //       type: isCredit ? "CREDIT" : "DEBIT",
                    //       keyType: "ANDROID", // or dynamic if you want
                    //       quantity: qty,
                    //     );
                    //
                    //     final resp = await _service.transferKeys(req);
                    //
                    //     if (resp == null || resp.success != true) {
                    //       Get.snackbar(
                    //         "Error",
                    //         resp?.message ?? "Transfer failed",
                    //         snackPosition: SnackPosition.BOTTOM,
                    //       );
                    //       return;
                    //     }
                    //
                    //     // ✅ clear both fields to avoid mixing
                    //     controller.creditCtrl.clear();
                    //     controller.debitCtrl.clear();
                    //
                    //     Get.back(); // close dialog
                    //
                    //     Get.snackbar(
                    //       "Success",
                    //       resp.message,
                    //       snackPosition: SnackPosition.BOTTOM,
                    //     );
                    //
                    //     // ✅ refresh details page balance
                    //     await detailsC.fetchDetails();
                    //   } finally {
                    //     controller.isSaving.value = false;
                    //   }
                    // },
                    onTap: loading
                        ? null
                        : () async {
                      final qty = int.tryParse(amountCtrl.text.trim()) ?? 0;

                      if (qty <= 0) {
                        Get.snackbar("Invalid", "Enter valid amount",
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      final retailerId = detailsC.details.value?.retailerId ?? "";
                      final receiverId = controller.distributorId ?? "";
                      if (retailerId.isEmpty) {
                        Get.snackbar("Error", "Retailer not found",
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      controller.isSaving.value = true;

                      try {
                        KeyTransferResponse? resp;

                        /// ✅ CREDIT FLOW
                        if (isCredit) {
                          resp = await _service.creditKeys(
                              units: qty,
                              retailerId: retailerId,
                          );
                        }

                        /// ✅ DEBIT FLOW
                        else {
                          resp = await _service.debitKeys(
                            retailerId: retailerId,
                            receiverId: receiverId,
                            units: qty,
                          );
                        }

                        if (resp == null || resp.success != true) {
                          Get.snackbar(
                            "Error",
                            resp?.message ?? "Operation failed",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        controller.creditCtrl.clear();
                        controller.debitCtrl.clear();

                        Get.back();

                        Get.snackbar(
                          "Success",
                          resp.message,
                          snackPosition: SnackPosition.BOTTOM,
                        );

                        await controller.fetchRetailers(); // ✅ refresh balance
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.offAllNamed(AppRoutes.DASH_DISTRIBUTOR);

                        });

                      } finally {
                        controller.isSaving.value = false;
                      }
                    },
                    child: Container(
                      width: Get.width * 0.75,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // color: const Color(0xFF3B5AF6),
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
                        child: loading
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

  static Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        cursorColor: const Color(0xFFD9B65A),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "",
        ).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
