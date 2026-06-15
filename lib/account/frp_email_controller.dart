import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:zlock_smart_finance/app/services/frp_email_service.dart';

import '../modules/retailer/dashboard/retailer_dashboard_controller.dart';

class FrpEmailController extends GetxController {
  final emailController = TextEditingController();
  final idController = TextEditingController();

  RxBool isSaving = false.obs;

  final FrpEmailService service = FrpEmailService();
  final RetailerDashboardController retailerController = Get.find();

  // Future<void> saveEmail() async {
  //   final email = emailController.text.trim();
  //   final id = idController.text.trim();
  //
  //   if (email.isEmpty || id.isEmpty) {
  //     Get.snackbar("Error", "All fields required",
  //         snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //
  //   if (!email.contains("@")) {
  //     Get.snackbar("Error", "Invalid email",
  //         snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //
  //   isSaving.value = true;
  //
  //   final res = await service.updateFrpEmail(
  //     id: id,
  //     email: email,
  //   );
  //
  //   isSaving.value = false;
  //
  //   if (res != null && res.success) {
  //     Get.back();
  //
  //     Get.snackbar(
  //       "Success",
  //       res.message,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } else {
  //     Get.snackbar(
  //       "Error",
  //       res?.message ?? "Something went wrong",
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  Future<void> saveEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!email.contains("@")) {
      Get.snackbar("Error", "Invalid email",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final id = retailerController.userId.value;

    if (id.isEmpty) {
      Get.snackbar("Error", "User ID not found",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving.value = true;

    debugPrint("🔥 USING DASHBOARD ID: $id");

    final res = await service.updateFrpEmail(
      id: id,
      email: email,
    );

    isSaving.value = false;

    if (res != null && res.success) {
      emailController.clear();
      Get.back();
      Get.snackbar("Success", res.message,);
    } else {
      Get.snackbar("Error", res?.message ?? "Something went wrong");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    idController.dispose();
    super.onClose();
  }
}