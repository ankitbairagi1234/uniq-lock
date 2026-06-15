import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

// class SplashScreen extends GetView<SplashController> {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Image.asset(
//           "assets/gif/splash.gif",
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/splash.png",height: MediaQuery.of(context).size.height,
          // fit: BoxFit.fill,
        ),
      ),
    );
  }
}