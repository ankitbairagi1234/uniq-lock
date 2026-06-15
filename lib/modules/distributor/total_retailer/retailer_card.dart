import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_model.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/view_retailer_page.dart';

// class RetailerCard extends StatelessWidget {
//   final RetailerModel retailer;
//   const RetailerCard({super.key, required this.retailer});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x14000000),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           /// TOP
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "ID: ${retailer.id}",
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5EC),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "Active",
//                   style: TextStyle(
//                     color: Color(0xFF2E7D32),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               )
//             ],
//           ),
//
//           const Divider(height: 24),
//
//           /// DETAILS
//           Row(
//             children: [
//               Container(
//                 height: 48,
//                 width: 48,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEAF0FF),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     "assets/icons/Shop.svg",
//                     width: 26,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _row("Retailer Name:", retailer.name),
//                     _row("Mobile:", retailer.mobile),
//                     _row("Email:", retailer.email),
//                     _row("State:", retailer.state),
//                   ],
//                 ),
//               )
//             ],
//           ),
//
//           const Divider(height: 24),
//
//           /// BOTTOM
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "Balance:\n\$${retailer.balance.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Obx(() => Switch(
//                 value: retailer.isActive.value,
//                 onChanged: (v) => retailer.isActive.value = v,
//                 activeColor:AppColors.primary,
//               )),
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: View Retailer
//                   Get.to(ViewRetailerPage());
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3D5CFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                 ),
//                 child: const Text("View",style: TextStyle(color: Colors.white),),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 2),
//       child: RichText(
//         text: TextSpan(
//           style: const TextStyle(fontSize: 13, color: Colors.black),
//           children: [
//             TextSpan(
//               text: "$label ",
//               style: const TextStyle(color: Colors.black54),
//             ),
//             TextSpan(
//               text: value,
//               style: const TextStyle(fontWeight: FontWeight.w600),
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
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_model.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/view_retailer_page.dart';

// class RetailerCard extends StatelessWidget {
//   final RetailerModel retailer;
//   const RetailerCard({super.key, required this.retailer});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<RetailerController>();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x14000000),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           /// TOP
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "ID: ${retailer.id}",
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//
//               // ✅ ACTIVE/INACTIVE chip dynamic
//               Obx(() {
//                 final active = retailer.isActive.value;
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: active ? const Color(0xFFE8F5EC) : const Color(0xFFFFEBEE),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     active ? "Active" : "Inactive",
//                     style: TextStyle(
//                       color: active ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//
//           const Divider(height: 24),
//
//           /// DETAILS
//           Row(
//             children: [
//               // ✅ IMAGE SAFE (if url exists show, else svg fallback)
//               _imageBox(),
//
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _row("Retailer Name:", retailer.name),
//                     _row("Mobile:", retailer.mobile),
//                     _row("Email:", retailer.email),
//                     _row("State:", retailer.state),
//                   ],
//                 ),
//               )
//             ],
//           ),
//
//           const Divider(height: 24),
//
//           /// BOTTOM
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "Balance:\n₹${retailer.balance.toStringAsFixed(2)}",
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//
//               // ✅ SWITCH (no error)
//               // Obx(() => Switch(
//               //   value: retailer.isActive.value,
//               //   onChanged: (v) {
//               //     retailer.isActive.value = v;
//               //
//               //     // ✅ TODO: later integrate toggle status API here
//               //     // controller.toggleRetailerStatus(retailer.retailerId, v);
//               //   },
//               //   activeColor: AppColors.primary,
//               // )),
//               Obx(() {
//                 final toggling = retailer.isToggling.value;
//
//                 return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Switch(
//                       value: retailer.isActive.value,
//                       onChanged: toggling
//                           ? null
//                           : (v) => controller.toggleRetailerStatus(retailer, v),
//                       activeColor: AppColors.primary,
//                     ),
//                     if (toggling)
//                       const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                   ],
//                 );
//               }),
//               ElevatedButton(
//                 onPressed: () {
//                   // ✅ pass retailer to view page if needed
//                   Get.to(() => ViewRetailerPage(retailerId: retailer.retailerId));
//
//                   // Get.to(() => ViewRetailerPage(), arguments: retailer);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3D5CFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                 ),
//                 child: const Text(
//                   "View",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _imageBox() {
//     final img = retailer.image;
//
//     // if api image null or empty -> show svg
//     if (img == null || img.isEmpty || !img.startsWith("http")) {
//       return Container(
//         height: 48,
//         width: 48,
//         decoration: BoxDecoration(
//           color: const Color(0xFFEAF0FF),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Center(
//           child: SvgPicture.asset(
//             "assets/icons/Shop.svg",
//             width: 26,
//           ),
//         ),
//       );
//     }
//
//     // show network image safely
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         height: 48,
//         width: 48,
//         color: const Color(0xFFEAF0FF),
//         child: Image.network(
//           img,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) {
//             return Center(
//               child: SvgPicture.asset(
//                 "assets/icons/Shop.svg",
//                 width: 26,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 2),
//       child: RichText(
//         text: TextSpan(
//           style: const TextStyle(fontSize: 13, color: Colors.black),
//           children: [
//             TextSpan(
//               text: "$label ",
//               style: const TextStyle(color: Colors.black54),
//             ),
//             TextSpan(
//               text: value,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class RetailerCard extends StatelessWidget {
  final RetailerModel retailer;
  final RetailerController controller;

  const RetailerCard({
    super.key,
    required this.retailer,
    required this.controller,
  });

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";

    final parsed = DateTime.tryParse(date);
    if (parsed == null) return "-";

    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];

    return "${parsed.day} ${months[parsed.month - 1]} ${parsed.year}";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          /// TOP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID: ${retailer.customId}", style: const TextStyle(fontWeight: FontWeight.w600)),
              Obx(() {
                final active = retailer.isActive.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFE8F5EC) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    active ? "Active" : "Inactive",
                    style: TextStyle(
                      color: active ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),

          const Divider(height: 24),

          /// DETAILS
          Row(
            children: [
              _imageBox(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row("Retailer Name:", retailer.name),
                    _row("Mobile:", retailer.mobile),
                    _row("Email:", retailer.email),
                    _row("State:", retailer.state),
                    _row("Created:", formatDate(retailer.createdAt)),

                  ],
                ),
              )
            ],
          ),

          const Divider(height: 24),

          /// BOTTOM
          Row(
            children: [
              Expanded(
                child: Text(
                  "Balance:\n₹${retailer.keyBalance.totalAvailable.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              /// ✅ SWITCH + API
              Obx(() {
                final toggling = retailer.isToggling.value;
                return IgnorePointer(
                  ignoring: toggling,
                  child: Opacity(
                    opacity: toggling ? 0.6 : 1,
                    child: Switch(
                      value: retailer.isActive.value,
                      onChanged: (v) => controller.toggleRetailerStatus(retailer, v),
                      activeColor: AppColors.primary,
                    ),
                  ),
                );
              }),

              ElevatedButton(
                onPressed: () =>
                    // Get.to(() => ViewRetailerPage(
                    //     retailerId: retailer.customId,
                    //     retailer: retailer, // ✅ PASS FULL DATA
                    // )),
                Get.to(() => ViewRetailerPage(
                  retailerId: retailer.customId,
                  retailer: retailer,
                  controllerTag: controller.tag, // 🔥 ADD THIS
                )),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5CFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("View", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _imageBox() {
    final img = retailer.image;

    if (img == null || img.isEmpty || !img.startsWith("http")) {
      return Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF0FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: SvgPicture.asset("assets/icons/Shop.svg", width: 26),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openFullImage(img),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          width: 48,
          color: const Color(0xFFEAF0FF),
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _openFullImage(String imageUrl) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),

            /// ❌ CLOSE BUTTON
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black,
    );
  }
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(color: Colors.black54)),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
