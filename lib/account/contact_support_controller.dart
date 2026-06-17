import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// class ContactSupportController extends GetxController {
//   final supportEmail = "Ceo@lockontechventure.com";
//   final supportPhone = "+918810422690";
//   final supportWhatsapp = "+8810422689";
//
//   /// Open Email App
//   void openEmail() async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: supportEmail,
//     );
//
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       Get.snackbar("Error", "Could not open email app",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   /// Call Phone
//   void openPhone() async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: supportPhone);
//
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       Get.snackbar("Error", "Could not start call",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   /// Open WhatsApp chat
//   void openWhatsApp() async {
//     final whatsappUrl = Uri.parse("https://wa.me/$supportWhatsapp");
//
//     if (await canLaunchUrl(whatsappUrl)) {
//       await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
//     } else {
//       Get.snackbar("Error", "WhatsApp not installed",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
// }

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportController extends GetxController {
  final supportEmail = "Sabkuchmall.in@gmail.com";
  final supportPhone = "8923168292";

  /// ---------------- EMAIL ----------------
  void openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: Uri.encodeFull(
        'subject=Support Request&body=Hello Team,',
      ),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // 👉 Gmail Web fallback
        final Uri gmailWeb = Uri.parse(
          "https://mail.google.com/mail/?view=cm&to=$supportEmail&su=Support%20Request&body=Hello%20Team",
        );

        await launchUrl(
          gmailWeb,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to open email");
    }
  }

  /// ---------------- CALL ----------------
  // void openPhone() async {
  //   String formattedNumber = supportPhone.startsWith("+91")
  //       ? supportPhone
  //       : "+91$supportPhone";
  //
  //   final Uri phoneUri = Uri.parse("tel:$formattedNumber");
  //
  //   try {
  //     await launchUrl(
  //       phoneUri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } catch (e) {
  //     Get.snackbar("Error", "Could not start call");
  //   }
  // }

  void openPhone(String phoneNumber) async {
    String formattedNumber = phoneNumber.startsWith("+91")
        ? phoneNumber
        : "+91$phoneNumber";

    final Uri phoneUri = Uri.parse("tel:$formattedNumber");

    try {
      await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not start call");
    }
  }
  void openWhatsApp(String phoneNumber) async {
    String phone = phoneNumber.replaceAll("+", "");

    String message = "Hello Support Team,\nI need help regarding my account.";

    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Clipboard.setData(ClipboardData(text: phoneNumber));
      Get.snackbar(
        "WhatsApp not available",
        "Number copied: $phoneNumber",
      );
    }
  }
  /// ---------------- WHATSAPP ----------------
  // void openWhatsApp() async {
  //   // 👉 Remove + sign for wa.me
  //   String phone = supportPhone.replaceAll("+", "");
  //
  //   final Uri whatsappUri =
  //   Uri.parse("https://wa.me/$phone?text=Hello%20Support");
  //
  //   try {
  //     await launchUrl(
  //       whatsappUri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } catch (e) {
  //     // 👉 fallback: copy number
  //     Clipboard.setData(ClipboardData(text: supportPhone));
  //     Get.snackbar(
  //       "WhatsApp not available",
  //       "Number copied: $supportPhone",
  //     );
  //   }
  // }
  // void openWhatsApp() async {
  //   String phone = supportPhone.replaceAll("+", "");
  //
  //   String message = "Hello Support Team,\nI need help regarding my account.";
  //
  //   final Uri whatsappUri = Uri.parse(
  //     "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
  //   );
  //
  //   try {
  //     await launchUrl(
  //       whatsappUri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } catch (e) {
  //     Clipboard.setData(ClipboardData(text: supportPhone));
  //     Get.snackbar(
  //       "WhatsApp not available",
  //       "Number copied: $supportPhone",
  //     );
  //   }
  // }
}