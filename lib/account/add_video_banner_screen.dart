import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/account/account_controller.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
///old
// class AddVideoBannerScreen extends StatelessWidget {
//   AddVideoBannerScreen({super.key});
//
//   final AccountController c = Get.put(AccountController());
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: AppColors.bgTopGradient,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back button
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF2F4FA),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.arrow_back, size: 18),
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 const Text(
//                   "Advertisement Video",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 const Text(
//                   "Can’t find what you’re looking for? Reach out to\nour support team",
//                   style: TextStyle(
//                     fontSize: 15,
//                     height: 1.4,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                     child: Image.asset(
//                       "assets/images/banner.png",
//                       fit: BoxFit.fill,
//                       width: double.infinity,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                     child: Image.asset(
//                       "assets/images/banner.png",
//                       fit: BoxFit.fill,
//                       width: double.infinity,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                     child: Image.asset(
//                       "assets/images/banner.png",
//                       fit: BoxFit.fill,
//                       width: double.infinity,
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

///video
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
// class AddVideoBannerScreen extends StatefulWidget {
//   const AddVideoBannerScreen({super.key});
//
//   @override
//   State<AddVideoBannerScreen> createState() =>
//       _AddVideoBannerScreenState();
// }
//
// class _AddVideoBannerScreenState extends State<AddVideoBannerScreen> {
//   late VideoPlayerController runningController;
//   late VideoPlayerController newKeyController;
//
//   bool isRunningPlaying = false;
//   bool isNewPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     runningController =
//     VideoPlayerController.asset("assets/videos/running_key.mp4")
//       ..initialize().then((_) => setState(() {}));
//
//     newKeyController =
//     VideoPlayerController.asset("assets/videos/new_key.mp4")
//       ..initialize().then((_) => setState(() {}));
//   }
//
//   @override
//   void dispose() {
//     runningController.dispose();
//     newKeyController.dispose();
//     super.dispose();
//   }
//
//   void toggleRunning() {
//     setState(() {
//       if (runningController.value.isPlaying) {
//         runningController.pause();
//         isRunningPlaying = false;
//       } else {
//         runningController.play();
//         isRunningPlaying = true;
//       }
//     });
//   }
//
//   void toggleNewKey() {
//     setState(() {
//       if (newKeyController.value.isPlaying) {
//         newKeyController.pause();
//         isNewPlaying = false;
//       } else {
//         newKeyController.play();
//         isNewPlaying = true;
//       }
//     });
//   }
//
//   Widget buildVideoCard({
//     required String title,
//     required VideoPlayerController controller,
//     required VoidCallback onTap,
//     required bool isPlaying,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 25),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//
//           /// Video
//           GestureDetector(
//             onTap: onTap,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     bottom: Radius.circular(20),
//                   ),
//                   child: controller.value.isInitialized
//                       ? AspectRatio(
//                     aspectRatio: controller.value.aspectRatio,
//                     child: VideoPlayer(controller),
//                   )
//                       : Container(
//                     height: 200,
//                     alignment: Alignment.center,
//                     child: const CircularProgressIndicator(),
//                   ),
//                 ),
//
//                 /// Play button overlay
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black45,
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(12),
//                   child: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: AppColors.bgTopGradient,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Back
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFF2F4FA),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.arrow_back, size: 18),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               /// Title
//               const Text(
//                 "Advertisement Video",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               /// New Key Video
//               buildVideoCard(
//                 title: "New Key Installation",
//                 controller: newKeyController,
//                 onTap: toggleNewKey,
//                 isPlaying: isNewPlaying,
//               ),
//               /// Running Key Video
//               buildVideoCard(
//                 title: "Running Key Installation",
//                 controller: runningController,
//                 onTap: toggleRunning,
//                 isPlaying: isRunningPlaying,
//               ),
//
//
//             ],
//
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:url_launcher/url_launcher.dart';

class AddVideoBannerScreen extends StatelessWidget {
  const AddVideoBannerScreen({super.key});

  /// 🔗 Open YouTube Link
  Future<void> openYoutube(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open video");
    }
  }

  // /// 🔥 Beautiful Card UI
  // Widget buildCard({
  //   required String title,
  //   required String subtitle,
  //   required String url,
  //   required IconData icon,
  //   required Color color,
  // }) {
  //   return GestureDetector(
  //     onTap: () => openYoutube(url),
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 20),
  //       padding: const EdgeInsets.all(18),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(18),
  //         gradient: LinearGradient(
  //           colors: [
  //             color.withOpacity(0.9),
  //             color.withOpacity(0.7),
  //           ],
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: color.withOpacity(0.3),
  //             blurRadius: 10,
  //             offset: const Offset(0, 6),
  //           )
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           /// Icon
  //           Container(
  //             padding: const EdgeInsets.all(14),
  //             decoration: BoxDecoration(
  //               color: Colors.white.withOpacity(0.2),
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(icon, color: Colors.white, size: 26),
  //           ),
  //
  //           const SizedBox(width: 16),
  //
  //           /// Text
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   title,
  //                   style: const TextStyle(
  //                     fontSize: 17,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 6),
  //                 Text(
  //                   subtitle,
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                     color: Colors.white70,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           /// Arrow
  //           const Icon(Icons.arrow_forward_ios,
  //               color: Colors.white, size: 18),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildCard({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => openYoutube(url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF0A0A0A),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0x55D9B65A),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A).withOpacity(.12),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0x22D9B65A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFD9B65A),
                size: 26,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF4E19C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFFD9B65A),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x55D9B65A),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFD9B65A),
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "Video Guide",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4E19C),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Learn installation with step-by-step videos",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 30),

              /// 🔥 NEW KEY VIDEO
              buildCard(
                title: "New Key Installation",
                subtitle: "Step-by-step guide for new key setup",
                url: "https://youtu.be/-0eEB3Pkcf0",
                icon: Icons.vpn_key,
              ),

              /// 🔥 RUNNING KEY VIDEO
              buildCard(
                title: "Running Key Installation",
                subtitle: "Guide for already running key",
                url: "https://youtu.be/KQryAyr7rkw",
                icon: Icons.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}