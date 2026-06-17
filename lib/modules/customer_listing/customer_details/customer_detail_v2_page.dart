import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zlock_smart_finance/app/constants/map_open_halper.dart';
import 'package:zlock_smart_finance/app/utils/date_formate.dart';
import 'package:zlock_smart_finance/model/device_command_model.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';

class CustomerDetailV2Page extends StatelessWidget {
  CustomerDetailV2Page({super.key});

  final CustomerDetailV2Controller ctrl = Get.find<CustomerDetailV2Controller>();
  final NewKeyController c = Get.find<NewKeyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      // appBar: AppBar(
      //
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: GestureDetector(
      //     onTap: () => Get.back(),
      //     child: Container(
      //       margin: const EdgeInsets.all(10),
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         shape: BoxShape.circle,
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.shade300,
      //             blurRadius: 6,
      //             offset: const Offset(0, 3),
      //           )
      //         ],
      //       ),
      //       child: const Icon(Icons.arrow_back, color: Colors.black),
      //     ),
      //   ),
      //   title: const Text("Details"),
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFFD9B65A),
            ),
          ),
        ),
        title: const Text(
          "Customer Details",
          style: TextStyle(
            color: Color(0xFFF4E19C),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          _tabs(),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              switch (ctrl.selectedTab.value) {
                case 1:
                  return _commandsTab();
                case 2:
                  return _emiTab(context);
                default:
                  return customerTab();
              }
            }),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Obx(() {
      //   if (ctrl.selectedTab.value != 0) return const SizedBox.shrink();
      //
      //   return Container(
      //     width: MediaQuery.of(context).size.width,
      //     padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      //     decoration: const BoxDecoration(
      //       color: Color(0xffF6F7FB),
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(28),
      //         topRight: Radius.circular(28),
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black12,
      //           blurRadius: 10,
      //           offset: Offset(0, -2),
      //         ),
      //       ],
      //     ),
      //     child: Row(
      //       children: [
      //         Expanded(child: _unlockButton()),
      //         const SizedBox(width: 14),
      //         Expanded(child: _lockButton()),
      //       ],
      //     ),
      //   );
      // }),
    );
  }

  Widget _tabs() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Customer Details', 'Commands', 'EMI']
          .asMap()
          .entries
          .map(
            (e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(e.value),
            selected: ctrl.selectedTab.value == e.key,
            // selectedColor: const Color(0xff4F6BED),
            selectedColor: const Color(0xFFD9B65A),
            onSelected: (_) => ctrl.selectedTab.value = e.key,
            // labelStyle: TextStyle(
            //   color: ctrl.selectedTab.value == e.key
            //       ? Colors.white
            //       : Colors.black,
            // ),
            labelStyle: TextStyle(
              color: ctrl.selectedTab.value == e.key
                  ? Colors.black
                  : const Color(0xFFD9B65A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      )
          .toList(),
    ));
  }

  Widget customerTab() {
    return Obx(() {
      if (ctrl.isDetailsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.customer.value == null) {
        return Center(
          child: TextButton(
            onPressed: ctrl.fetchCustomerDetails,
            child: const Text("Retry"),
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _profileSection(),
            // const SizedBox(height: 16),
            // _deviceStatus(),
            const SizedBox(height: 16),
            _numberSection(),
            const SizedBox(height: 16),
            _documentsSection(),
          ],
        ),
      );
    });
  }

  Widget _profileAvatar() {
    final String imageUrl = (ctrl.productImage ?? '').trim();
    final hasImage = imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: hasImage
          ? () => _showFullImage(imageUrl)
          : null,
      child: Hero(
        tag: imageUrl,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xffEEF1FF),
          backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
          child: hasImage
              ? null
              : const Icon(Icons.person, size: 36, color: Colors.grey),
        ),
      ),
    );
  }

  void _showFullImage(String imageUrl) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            /// 🔥 Image with smooth zoom + Hero animation
            Center(
              child: Hero(
                tag: imageUrl,
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            /// ❌ Close Button (Top Right)
            Positioned(
              top: MediaQuery.of(Get.context!).padding.top + 10,
              right: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.95),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
    );
  }

  Widget _profileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _profileAvatar(),
          const SizedBox(height: 16),
          _inputField(
            icon: Icons.person_outline,
            text: ctrl.customerName,
          ),
          const SizedBox(height: 12),
          _inputField(
            svgPath: "assets/accounts/call.svg",
            text: ctrl.customerPhone,
          ),
        ],
      ),
    );
  }

  // Widget _deviceStatus() {
  //   final isActive = ctrl.isActiveDevice;
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: _cardDecoration(),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const Text(
  //           "Device Status",
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: isActive ? Colors.green.shade50 : Colors.red.shade50,
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: isActive ? Colors.green : Colors.red),
  //           ),
  //           child: Text(
  //             isActive ? "● Phone is Active" : "● Phone is Inactive",
  //             style: TextStyle(
  //               color: isActive ? Colors.green : Colors.red,
  //               fontSize: 12,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _deviceStatus() {
    final isActive = ctrl.isDeviceActiveByRemove;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Device Status",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isActive ? Colors.green : Colors.red),
            ),
            child: Text(
              isActive ? "● Phone is Active" : "● Phone is Inactive",
              style: TextStyle(
                color: isActive ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _numberSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Device Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF4E19C),
            ),
          ),
          const SizedBox(height: 16),

          _numberTile(
            Icons.sim_card_rounded,
            "SIM 1",
            ctrl.customerPhone,
          ),

          _divider(),

          _numberTile(
            Icons.qr_code_rounded,
            "IMEI 1",
            ctrl.imei1,
          ),

          _divider(),

          _numberTile(
            Icons.qr_code_rounded,
            "IMEI 2",
            ctrl.imei2,
          ),

          _divider(),

          _numberTile(
            Icons.phone_android_rounded,
            "Brand / Model",
            ctrl.brandModel,
          ),
        ],
      ),
    );
  }

  Widget _numberTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: const Color(0x22D9B65A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0x55D9B65A),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD9B65A),
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value.isEmpty ? "-" : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _inputField({
    IconData? icon,
    String? svgPath,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0x44D9B65A),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon,color: const Color(0xFFD9B65A), size: 20),
          if (svgPath != null)
            SvgPicture.asset(svgPath,color: const Color(0xFFD9B65A), width: 20, height: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _numberTile(IconData icon, String title, String value) {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: const Color(0xffEEF2FF),
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Icon(icon, color: const Color(0xff4F6BED)),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(title, style: const TextStyle(fontSize: 12)),
  //             Text(
  //               value,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Divider(
      color: Color(0x33D9B65A),
      height: 1,
    ),
  );

  // BoxDecoration _cardDecoration() => BoxDecoration(
  //   color: Colors.white,
  //   borderRadius: BorderRadius.circular(20),
  //   boxShadow: [
  //     BoxShadow(
  //       color: Colors.black.withOpacity(.05),
  //       blurRadius: 10,
  //       offset: const Offset(0, 4),
  //     )
  //   ],
  // );

  BoxDecoration _cardDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(22),
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
    boxShadow: [
      BoxShadow(
        color: const Color(0xFFD9B65A).withOpacity(.08),
        blurRadius: 15,
      ),
    ],
  );


  Widget _commandsTab() {
    final gridCommands = ctrl.orderedCommands.where((e) {
      return e != "Lock Device" &&
          e != "Location" &&
          e != "Mobile No" &&
          e != "Audio";
    }).toList();
    return SingleChildScrollView(
      // padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),

      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔵 SOCIAL MEDIA
          Obx(() {
            final loading = ctrl.isCommandLoading("Social Media");

            return _socialMediaModernCard(
              value: ctrl.commands["Social Media"]!.value,
              isLoading: loading,
              onChanged: loading
                  ? null
                  : (v) => ctrl.onCommandToggle("Social Media", v),
            );
          }),

          const SizedBox(height: 12),

          _buildLockUnlockPanel(),

          const SizedBox(height: 12),

          _buildQuickActions(),
          const SizedBox(height: 8),

          // GridView.builder(
          //   padding: EdgeInsets.only(top: 5,bottom: 5),
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   // itemCount: ctrl.orderedCommands.length,
          //   itemCount: gridCommands.length,
          //   // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   //   crossAxisCount: 3,
          //   //   childAspectRatio: 0.77,
          //   //   crossAxisSpacing: 12,
          //   //   mainAxisSpacing: 12,
          //   // ),
          //
          //   // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   //   crossAxisCount: 3,
          //   //   childAspectRatio: 0.92,
          //   //   crossAxisSpacing: 10,
          //   //   mainAxisSpacing: 10,
          //   // ),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     childAspectRatio: 1.3,
          //     crossAxisSpacing: 8,
          //     mainAxisSpacing: 8,
          //   ),
          //
          //   // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   //   crossAxisCount: 3,
          //   //   childAspectRatio: 1.08,
          //   //   crossAxisSpacing: 8,
          //   //   mainAxisSpacing: 8,
          //   // ),
          //
          //   itemBuilder: (_, i) {
          //     // final title = ctrl.orderedCommands[i];
          //     final title = gridCommands[i];
          //     /// 👉 SPECIAL COMMANDS (Location, Mobile No)
          //     // if (ctrl.specialCommands.contains(title)) {
          //     //   return _actionCard(
          //     //     title: title,
          //     //     iconPath: ctrl.iconFor(title),
          //     //     onTap: () => onSpecialCommandTap(title),
          //     //   );
          //     // }
          //
          //
          //     if (ctrl.specialCommands.contains(title)) {
          //       return _actionCard(
          //         title: title,
          //         iconPath: ctrl.iconFor(title),
          //         onTap: () {
          //           if (title == "Audio") {
          //             showAudioAlertDialog();
          //             return;
          //           }
          //
          //           onSpecialCommandTap(title);
          //         },
          //       );
          //     }
          //     /// 👉 NORMAL COMMANDS
          //     final internalKey =
          //         ctrl.displayToInternalCommand[title] ?? title;
          //
          //     return Obx(() {
          //       final command = ctrl.commands[internalKey];
          //       final isComingSoon =
          //       ctrl.comingSoonCommands.contains(title);
          //
          //       return _miniCommandCard(
          //         title: title,
          //         iconPath: ctrl.iconFor(internalKey),
          //         value: command?.value ?? false,
          //         loading: ctrl.isCommandLoading(internalKey),
          //         // onChanged: isComingSoon
          //         //     ? (_) {
          //         //   Get.snackbar(
          //         //       "Coming Soon", "$title will be available soon");
          //         // }
          //         //     : (v) => ctrl.onCommandToggle(internalKey, v),
          //         onChanged: isComingSoon
          //             ? (_) {}
          //             : (v) async {
          //
          //           /// ✅ AUDIO POPUP
          //           if (internalKey == "Audio") {
          //             showAudioAlertDialog();
          //             return;
          //           }
          //
          //
          //           /// ✅ CONFIRMATION ONLY FOR THESE 2
          //           if (internalKey == "Lock Device" ||
          //               internalKey == "ACTIVE_RESTRICTION") {
          //
          //             // final confirm = await Get.dialog<bool>(
          //             //   Dialog(
          //             //     shape: RoundedRectangleBorder(
          //             //       borderRadius: BorderRadius.circular(20),
          //             //     ),
          //             //     child: Padding(
          //             //       padding: const EdgeInsets.all(20),
          //             //       child: Column(
          //             //         mainAxisSize: MainAxisSize.min,
          //             //         children: [
          //             //
          //             //           Icon(
          //             //             Icons.warning_amber_rounded,
          //             //             size: 36,
          //             //             color: Colors.orange,
          //             //           ),
          //             //
          //             //           const SizedBox(height: 12),
          //             //
          //             //           const Text(
          //             //             "Confirmation",
          //             //             style: TextStyle(
          //             //               fontSize: 18,
          //             //               fontWeight: FontWeight.bold,
          //             //             ),
          //             //           ),
          //             //
          //             //           const SizedBox(height: 10),
          //             //
          //             //           Text(
          //             //             internalKey == "Lock Device"
          //             //                 ? (v
          //             //                 ? "Are you sure you want to lock this device?"
          //             //                 : "Are you sure you want to unlock this device?")
          //             //                 : (v
          //             //                 ? "Are you sure you want to enable active restriction?"
          //             //                 : "Are you sure you want to disable active restriction?"),
          //             //             textAlign: TextAlign.center,
          //             //             style: const TextStyle(color: Colors.grey),
          //             //           ),
          //             //
          //             //           const SizedBox(height: 20),
          //             //
          //             //           Row(
          //             //             children: [
          //             //               Expanded(
          //             //                 child: OutlinedButton(
          //             //                   onPressed: () => Get.back(result: false),
          //             //                   child: const Text("Cancel"),
          //             //                 ),
          //             //               ),
          //             //               const SizedBox(width: 10),
          //             //               Expanded(
          //             //                 child: ElevatedButton(
          //             //                   onPressed: () => Get.back(result: true),
          //             //                   style: ElevatedButton.styleFrom(
          //             //                     backgroundColor: const Color(0xff4F6BED),
          //             //                   ),
          //             //                   child: const Text(
          //             //                     "Yes",
          //             //                     style: TextStyle(color: Colors.white),
          //             //                   ),
          //             //                 ),
          //             //               ),
          //             //             ],
          //             //           )
          //             //         ],
          //             //       ),
          //             //     ),
          //             //   ),
          //             // );
          //
          //             final confirm = await Get.dialog<bool>(
          //               Dialog(
          //                 insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(24),
          //                 ),
          //                 child: Container(
          //                   padding: const EdgeInsets.all(20),
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(24),
          //
          //                     /// 🔥 PREMIUM GRADIENT (MATCH APP)
          //                     gradient: const LinearGradient(
          //                       colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
          //                       begin: Alignment.topLeft,
          //                       end: Alignment.bottomRight,
          //                     ),
          //                   ),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //
          //                       /// 🔵 ICON WITH GLOW
          //                       Container(
          //                         padding: const EdgeInsets.all(14),
          //                         decoration: BoxDecoration(
          //                           shape: BoxShape.circle,
          //                           color: const Color(0xff4F6BED).withOpacity(.1),
          //                         ),
          //                         child: Icon(
          //                           internalKey == "Lock Device"
          //                               ? (v ? Icons.lock : Icons.lock_open)
          //                               : Icons.security,
          //                           color: const Color(0xff4F6BED),
          //                           size: 28,
          //                         ),
          //                       ),
          //
          //                       const SizedBox(height: 14),
          //
          //                       /// 🔥 TITLE
          //                       const Text(
          //                         "Confirmation",
          //                         style: TextStyle(
          //                           fontSize: 18,
          //                           fontWeight: FontWeight.w700,
          //                           color: Color(0xff1E2A5A),
          //                         ),
          //                       ),
          //
          //                       const SizedBox(height: 8),
          //
          //                       /// 🔹 SUB TEXT
          //                       Text(
          //                         internalKey == "Lock Device"
          //                             ? (v
          //                             ? "Are you sure you want to lock this device?"
          //                             : "Are you sure you want to unlock this device?")
          //                             : (v
          //                             ? "Enable active restriction on this device?"
          //                             : "Disable active restriction on this device?"),
          //                         textAlign: TextAlign.center,
          //                         style: const TextStyle(
          //                           fontSize: 13,
          //                           color: Colors.grey,
          //                           height: 1.4,
          //                         ),
          //                       ),
          //
          //                       const SizedBox(height: 22),
          //
          //                       /// 🔥 BUTTONS
          //                       Row(
          //                         children: [
          //
          //                           /// CANCEL
          //                           Expanded(
          //                             child: OutlinedButton(
          //                               onPressed: () => Get.back(result: false),
          //                               style: OutlinedButton.styleFrom(
          //                                 padding: const EdgeInsets.symmetric(vertical: 14),
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius: BorderRadius.circular(14),
          //                                 ),
          //                                 side: BorderSide(
          //                                   color: const Color(0xff4F6BED).withOpacity(.3),
          //                                 ),
          //                               ),
          //                               child: const Text(
          //                                 "Cancel",
          //                                 style: TextStyle(color: Colors.black87),
          //                               ),
          //                             ),
          //                           ),
          //
          //                           const SizedBox(width: 10),
          //
          //                           /// YES BUTTON
          //                           Expanded(
          //                             child: ElevatedButton(
          //                               onPressed: () => Get.back(result: true),
          //                               style: ElevatedButton.styleFrom(
          //                                 padding: const EdgeInsets.symmetric(vertical: 14),
          //                                 backgroundColor: const Color(0xff4F6BED),
          //                                 elevation: 0,
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius: BorderRadius.circular(14),
          //                                 ),
          //                               ),
          //                               child: Text(
          //                                 internalKey == "Lock Device"
          //                                     ? (v ? "Lock" : "Unlock")
          //                                     : (v ? "Enable" : "Disable"),
          //                                 style: const TextStyle(
          //                                   color: Colors.white,
          //                                   fontWeight: FontWeight.w600,
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //             /// ❌ CANCEL → DO NOTHING
          //             if (confirm != true) return;
          //           }
          //
          //           /// ✅ CONTINUE ORIGINAL FLOW
          //           ctrl.onCommandToggle(internalKey, v);
          //         },
          //         isDisabled: isComingSoon,
          //       );
          //     });
          //   },
          // ),


          /// 🔹 MAIN COMMAND GRID

          // Obx(() {
          //   final isRunning = ctrl.isRunningKey; // 🔥 THIS LINE FIXES ISSUE
          //   print("🔥 isRunningKey: ${ctrl.isRunningKey}");
          //
          //   final commands = ctrl.mainCommands;
          //
          //   return GridView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: commands.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       childAspectRatio: 1,
          //       crossAxisSpacing: 12,
          //       mainAxisSpacing: 12,
          //     ),
          //     itemBuilder: (_, i) {
          //       final displayKey = commands[i];
          //       final internalKey =
          //       ctrl.displayToInternalCommand[displayKey]!;
          //
          //       return Obx(() {
          //         final command = ctrl.commands[internalKey];
          //         final isComingSoon =
          //         ctrl.comingSoonCommands.contains(displayKey);
          //
          //         return _miniCommandCard(
          //           title: displayKey,
          //           iconPath: ctrl.iconFor(internalKey),
          //           value: command?.value ?? false,
          //           loading: ctrl.isCommandLoading(internalKey),
          //           onChanged: isComingSoon
          //               ? (_) {
          //             Get.snackbar(
          //                 "Coming Soon", "$displayKey will be available soon");
          //           }
          //               : (v) => ctrl.onCommandToggle(internalKey, v),
          //           isDisabled: isComingSoon,
          //         );
          //       });
          //     },
          //   );
          // }),
          // const SizedBox(height: 10),


          Obx(() {
            final loading = ctrl.isCommandLoading("Remove Key");

            return GestureDetector(
              onTap: loading
                  ? null
                  : () async {
                // final confirm = await showDialog<bool>(
                //   context: Get.context!,
                //   builder: (context) {
                //     return AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       title: const Text("Confirm"),
                //       content: const Text(
                //         "Are you sure you want to remove this device?",
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context, false),
                //           child: const Text("Cancel"),
                //         ),
                //         ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.red,
                //           ),
                //           onPressed: () => Navigator.pop(context, true),
                //           child: const Text("Remove"),
                //         ),
                //       ],
                //     );
                //   },
                // );
                //
                // if (confirm == true) {
                //   onSpecialCommandTap("Remove Key");
                // }
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// 🔴 ICON
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.delete_outline,
                                color: Colors.red, size: 30),
                          ),

                          SizedBox(height: 16),

                          /// TITLE
                          Text(
                            "Remove Device?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          /// DESC
                          Text(
                            "This will permanently remove the device from system.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),

                          SizedBox(height: 20),

                          /// BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text("Cancel"),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    onSpecialCommandTap("Remove Key");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text("Remove",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF5A52),
                      Color(0xFFFF3B30),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent,
                      blurRadius: 18,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Remove Device",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            );
          }),

          const SizedBox(height: 40),
        ],
      ),

    );
  }

  Widget _buildLockUnlockPanel() {
    return Obx(() {
      final command = ctrl.commands["Lock Device"];
      final isLocked = command?.value ?? false;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF0A0A0A),
            ],
          ),
          border: Border.all(
            color: const Color(0x66D9B65A),
          ),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.security,
                  color: Color(0xFFD9B65A),
                ),
                SizedBox(width: 8),
                Text(
                  "Device Control",
                  style: TextStyle(
                    color: Color(0xFFF4E19C),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _controlButton(
                    title: "Lock Device",
                    icon: Icons.lock,
                    selected: isLocked,
                    onTap: () async {
                      final confirm = await _showCommandConfirmation(
                        title: "Lock Device",
                        message: "Are you sure you want to lock this device?",
                        actionText: "Lock",
                        icon: Icons.lock,
                      );

                      if (confirm == true) {
                        ctrl.onCommandToggle(
                          "Lock Device",
                          true,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _controlButton(
                    title: "Unlock Device",
                    icon: Icons.lock_open,
                    selected: !isLocked,
                    // onTap: () {
                    //   ctrl.onCommandToggle(
                    //     "Lock Device",
                    //     false,
                    //   );
                    // },
                    onTap: () async {
                      final confirm = await _showCommandConfirmation(
                        title: "Unlock Device",
                        message: "Are you sure you want to unlock this device?",
                        actionText: "Unlock",
                        icon: Icons.lock_open,
                      );

                      if (confirm == true) {
                        ctrl.onCommandToggle(
                          "Lock Device",
                          false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
  Widget _controlButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: selected
              ? const Color(0xFFD9B65A)
              : const Color(0xFF151515),
          border: Border.all(
            color: const Color(0x55D9B65A),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? Colors.black
                  : const Color(0xFFD9B65A),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildQuickActions() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.1,
      // crossAxisCount: 3,
      // childAspectRatio: 0.95,

      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [

        _quickCard(
          "Location",
          Icons.location_on,
              () => onSpecialCommandTap("Location"),
        ),

        _quickCard(
          "Mobile No",
          Icons.phone_android,
              () => onSpecialCommandTap("Mobile No"),
        ),

        _quickCard(
          "Audio",
          Icons.volume_up,
          showAudioAlertDialog,
        ),

        _quickCard(
          "Active Restriction",
          Icons.security,
              () async {
            final currentValue =
                ctrl.commands["ACTIVE_RESTRICTION"]?.value ?? false;

            final confirm = await _showCommandConfirmation(
              title: "Active Restriction",
              message: currentValue
                  ? "Disable active restriction?"
                  : "Enable active restriction?",
              actionText: currentValue ? "Disable" : "Enable",
              icon: Icons.security,
            );

            if (confirm == true) {
              ctrl.onCommandToggle(
                "ACTIVE_RESTRICTION",
                !currentValue,
              );
            }
          },
        ),

        _quickCard(
          "Offline Lock",
          Icons.lock_outline,
              () => onSpecialCommandTap("Offline Lock"),
        ),

        _quickCard(
          "Offline Unlock",
          Icons.lock_open,
              () => onSpecialCommandTap("Offline Unlock"),
        ),
      ],
    );
  }
  Widget _quickCard(
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
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
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD9B65A).withOpacity(.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF4E19C),
                        Color(0xFFD9B65A),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55D9B65A),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 24,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showAudioAlertDialog() {
    final TextEditingController messageCtrl = TextEditingController();
    bool isLoading = false;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B1B1B),
                    Color(0xFF0A0A0A),
                  ],
                ),
                border: Border.all(
                  color: const Color(0x66D9B65A),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x55D9B65A),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E19C),
                          Color(0xFFD9B65A),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x55D9B65A),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Play Audio Alert",
                    style: TextStyle(
                      color: Color(0xFFF4E19C),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Send a voice alert to the selected device",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [

                      /// CANCEL
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFD9B65A),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFFD9B65A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// SEND
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            final msg = "";

                            setState(
                                  () => isLoading = true,
                            );

                            final success =
                            await ctrl.sendAudioAlert(msg);

                            setState(
                                  () => isLoading = false,
                            );

                            if (success) {
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();

                              if (Get.isDialogOpen ?? false) {
                                Navigator.pop(context);
                              }

                              await Future.delayed(
                                const Duration(
                                  milliseconds: 200,
                                ),
                              );

                              Get.snackbar(
                                "Success",
                                "Voice alert sent",
                                snackPosition:
                                SnackPosition.BOTTOM,
                                backgroundColor:
                                Colors.green,
                                colorText: Colors.white,
                                margin:
                                const EdgeInsets.all(12),
                                duration:
                                const Duration(seconds: 2),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFD9B65A),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                            CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Send Alert",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _socialMediaModernCard({
    required bool value,
    required bool isLoading,
    required ValueChanged<bool>? onChanged,
  }) {
    Widget socialIcon(String asset) {
      return Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF222222),
              Color(0xFF111111),
            ],
          ),
          border: Border.all(
            color: const Color(0x55D9B65A),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD9B65A).withOpacity(.12),
              blurRadius: 12,
            ),
          ],
        ),
        child: SvgPicture.asset(
          asset,
          placeholderBuilder: (_) => const SizedBox(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF0A0A0A),
          ],
        ),
        border: Border.all(
          color: const Color(0x66D9B65A),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.25),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
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
                      color: Color(0x99D9B65A),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.public,
                  color: Colors.black,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Social Media",
                      style: TextStyle(
                        color: Color(0xFFF4E19C),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Access Management",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: value
                      ? const Color(0x22FF4444)
                      : const Color(0x22D9B65A),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  value ? "BLOCKED" : "ACTIVE",
                  style: TextStyle(
                    color: value
                        ? Colors.redAccent
                        : const Color(0xFFD9B65A),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// SOCIAL APPS
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              socialIcon(
                  "assets/icons/commands/youtube_colour.svg"),
              socialIcon(
                  "assets/icons/commands/whatsupp_colour.svg"),
              socialIcon(
                  "assets/icons/commands/wa_business.svg"),
              socialIcon(
                  "assets/icons/commands/insta_colour.svg"),
              socialIcon(
                  "assets/icons/commands/facebook_color.svg"),
              socialIcon(
                  "assets/icons/commands/arattai_colour.svg"),
            ],
          ),

          const SizedBox(height: 22),

          /// TOGGLE PANEL
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0x33D9B65A),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  value
                      ? Icons.lock_open_rounded
                      : Icons.lock_rounded,
                  color: const Color(0xFFD9B65A),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    value
                        ? "Social Media Restricted"
                        : "Social Media Allowed",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (isLoading)
                  const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else
                  Transform.scale(
                    scale: .9,
                    child: Switch(
                      value: value,
                      onChanged: onChanged,
                      activeColor: Colors.black,
                      activeTrackColor: const Color(0xFFD9B65A),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCommandCard({
    required String title,
    required String iconPath,
    required bool value,
    required bool loading,
    required ValueChanged<bool> onChanged,
    required bool isDisabled,

  }) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(color: const Color(0xff4F6BED)),
        //   color: Colors.white,
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          /// SAME AS SPECIAL COMMAND CARD
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF7F9FF),
              Color(0xFFEAF0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          border: Border.all(
            color: const Color(0xff4F6BED).withOpacity(.12),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT
          children: [

            /// ICON
            SvgPicture.asset(iconPath, height: 20),

            /// TEXT (FIXED)
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            if (isDisabled)
              const Text(
                "Coming Soon",
                style: TextStyle(fontSize: 9, color: Colors.red),
              ),

            /// SWITCH / LOADER
            loading
                ? const SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Transform.scale(
              scale: 0.7,
              child: Switch(
                value: value,
                // onChanged: onChanged,
                onChanged: isDisabled ? null : onChanged,
                activeTrackColor: const Color(0xff4F6BED),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _actionCard({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            /// 🔥 GRADIENT BACKGROUND
            gradient: const LinearGradient(
              colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            /// 🔹 BORDER
            border: Border.all(
              color: const Color(0xff4F6BED).withOpacity(0.15),
              width: 1,
            ),

            /// 🔹 SHADOW
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// 🔵 ICON CONTAINER
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔤 TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E2A5A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showCommandConfirmation({
    required String title,
    required String message,
    required String actionText,
    required IconData icon,
  }) {
    return Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD9B65A).withOpacity(.15),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFD9B65A),
                  size: 30,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9B65A),
                      ),
                      child: Text(
                        actionText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> onSpecialCommandTap(String title) async {
    if (title == 'Location') {
      showLocationPopup();
      return;
    }

    // if (title == 'Mobile No') {
    //   showMobileNumberPopup(
    //     registeredNumber: ctrl.customerPhone,
    //     currentNumber: ctrl.customerPhone,
    //   );
    //   return;
    // }

    // if (title == 'Mobile No') {
    //   /// 🔹 SHOW WAIT POPUP FIRST
    //   showMobileNumberPopup(
    //     simNumbers: [],
    //     isLoading: true,
    //   );
    //
    //   final numbers = await ctrl.fetchSimNumbers();
    //
    //   /// 🔹 UPDATE UI
    //   Get.back(); // close wait dialog
    //
    //   showMobileNumberPopup(
    //     simNumbers: numbers,
    //     isLoading: false,
    //   );
    //
    //   return;
    // }
    if (title == 'Mobile No') {
      /// ❌ DEVICE ID MISSING → NO POPUP
      if (ctrl.actualDeviceId.isEmpty) {
        Get.snackbar("Error", "Device ID missing");
        return;
      }
      /// 🔹 CLOSE ANY EXISTING DIALOG (SAFETY)
      if (Get.isDialogOpen ?? false) Get.back();

      /// 🔹 SHOW LOADING
      showMobileNumberPopup(
        simNumbers: [],
        simHistory: ctrl.simHistory.toList(),

        isLoading: true,
      );

      List<String> numbers = [];

      try {
        numbers = await ctrl.fetchSimNumbers();
      } catch (e) {
        debugPrint("❌ UI ERROR => $e");
      }

      /// 🔹 CLOSE LOADING SAFELY
      if (Get.isDialogOpen ?? false) Get.back();

      /// 🔹 SHOW FINAL RESULT
      showMobileNumberPopup(
        simNumbers: numbers,
        simHistory: ctrl.simHistory.toList(),

        isLoading: false,
      );

      return;
    }
    if (title == 'Scheduler Lock') {
      debugPrint("⏰ Scheduler Lock clicked");

      // /// Future me API call yaha jayega
      // Get.snackbar(
      //   "Scheduler Lock",
      //   "Scheduler lock clicked (API pending)",
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      showSchedulerDialog();


      return;
    }
    // if (title == 'Offline Lock') {
    //   ctrl.handleOfflineCommand(true);
    //   return;
    // }
    //
    // if (title == 'Offline Unlock') {
    //   ctrl.handleOfflineCommand(false);
    //   return;
    // }
    if (title == 'Offline Lock') {
      ctrl.handleOfflineCommand(true); // validation + logs
      showOfflineNumberDialog(isLock: true); // UI call
      return;
    }

    if (title == 'Offline Unlock') {
      ctrl.handleOfflineCommand(false);
      showOfflineNumberDialog(isLock: false);
      return;
    }
    if (title == 'App Update') {
      showAppUpdateDialog();
      return;
    }
    if (title == 'Remove Key') {
      await ctrl.sendRemoveKeyCommand();

      // ctrl.confirmAndRemoveKey(); // ✅ NEW

      // ctrl.confirmAndRemoveKey();
      return;
    }
  }


  void showSchedulerDialog() {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    bool isLoading = false;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 🔵 ICON + TITLE
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff4F6BED).withOpacity(.1),
                    ),
                    child: const Icon(Icons.lock_clock,
                        color: Color(0xff4F6BED), size: 28),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Schedule Lock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Select date & time to lock device",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  /// 📅 DATE
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: _schedulerBox(
                      icon: Icons.calendar_today,
                      text: selectedDate == null
                          ? "Select Date"
                          : DateFormat("dd MMM yyyy").format(selectedDate!),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ⏰ TIME
                  InkWell(
                    onTap: () async {
                      // final picked = await showTimePicker(
                      //   context: context,
                      //   initialTime: TimeOfDay.now(),
                      // );

                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: true,
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    child: _schedulerBox(
                      icon: Icons.access_time,
                      // text: selectedTime == null
                      //     ? "Select Time"
                      //     : selectedTime!.format(context),
                      text: selectedTime == null
                          ? "Select Time"
                          : "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// 🔥 BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (selectedDate == null ||
                                selectedTime == null) {
                              Get.snackbar("Error", "Select date & time");
                              return;
                            }

                            setState(() => isLoading = true);

                            final dateTime = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );

                            // final formatted = DateFormat(
                            //     "yyyy-MM-ddTHH:mm:ss")
                            //     .format(dateTime);

                            final offset = dateTime.timeZoneOffset;
                            final sign = offset.isNegative ? '-' : '+';

                            final hours =
                            offset.inHours.abs().toString().padLeft(2, '0');

                            final minutes =
                            (offset.inMinutes.abs() % 60)
                                .toString()
                                .padLeft(2, '0');

                            final formatted =
                                "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime)}"
                                "$sign$hours:$minutes";

                            debugPrint("📤 schedule_at => $formatted");

                            await ctrl.scheduleLockApi(formatted);

                            setState(() => isLoading = false);
                            // Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4F6BED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Schedule",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _schedulerBox({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff4F6BED).withOpacity(.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xff4F6BED)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  void showOfflineNumberDialog({required bool isLock}) {
    final ctrl = Get.find<CustomerDetailV2Controller>();

    TextEditingController numberCtrl = TextEditingController();

    List<String> simNumbers = [];
    bool isLoading = true;
    bool isSending = false;
    bool isFetched = false;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {

            /// ✅ FETCH ONLY ONCE
            if (isLoading && !isFetched) {
              isFetched = true;

              ctrl.fetchSimNumbers().then((list) {
                simNumbers = list;
                isLoading = false;

                /// 👉 अगर number है → prefill
                if (simNumbers.isNotEmpty) {
                  numberCtrl.text = simNumbers.first;
                }

                setState(() {});
              });
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B1B1B),
                    Color(0xFF0A0A0A),
                  ],
                ),
                border: Border.all(
                  color: Color(0x66D9B65A),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// 🔵 ICON
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E19C),
                          Color(0xFFD9B65A),
                        ],
                      ),
                    ),
                    child: Icon(
                      isLock ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    isLock ? "Offline Lock" : "Offline Unlock",
                    style: const TextStyle(
                      color: Color(0xFFF4E19C),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// 🔄 LOADING
                  if (isLoading)
                    const CircularProgressIndicator()
                  else if (simNumbers.isNotEmpty)

                  /// ✅ PREFILLED NUMBER (NO INPUT)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0x55D9B65A),
                        ),
                        color: const Color(0xFF151515),                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            color: Color(0xFFD9B65A),
                          ),
                         const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              numberCtrl.text,
                              // style: const TextStyle(
                              //   fontSize: 14,
                              //   fontWeight: FontWeight.w600,
                              // ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  /// ❌ NO NUMBER → INPUT FIELD
                  else
                    TextField(
                      controller: numberCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      // decoration: InputDecoration(
                      //   hintText: "Enter mobile number",
                      //   counterText: "",
                      //   prefixIcon: const Icon(Icons.phone),
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(14),
                      //   ),
                      // ),
                      decoration: InputDecoration(
                        hintText: "Enter mobile number",
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xFF151515),
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: Color(0xFFD9B65A),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0x55D9B65A),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0x55D9B65A),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9B65A),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// 🔥 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSending
                          ? null
                          : () async {
                        final number = numberCtrl.text.trim();

                        if (number.isEmpty || number.length < 10) {
                          Get.snackbar("Error", "Enter valid number");
                          return;
                        }

                        /// 🔥 CONFIRMATION DIALOG
                        final confirm = await Get.dialog<bool>(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Icon(
                                    isLock ? Icons.lock : Icons.lock_open,
                                    color: const Color(0xff4F6BED),
                                    size: 28,
                                  ),

                                  const SizedBox(height: 12),

                                  const Text(
                                    "Confirmation",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    isLock
                                        ? "Send offline lock to $number?"
                                        : "Send offline unlock to $number?",
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: const Text("Cancel"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(0xff4F6BED),
                                          ),
                                          child: const Text("Yes",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

                        if (confirm != true) return;

                        setState(() => isSending = true);

                        await ctrl.sendOfflineCommandApi(
                          number: number,
                          isLock: isLock,
                        );

                        /// ✅ CLOSE
                        if (Get.isDialogOpen == true) {
                          Navigator.of(Get.overlayContext!).pop();
                        }

                        Get.closeAllSnackbars();

                        Get.rawSnackbar(
                          message: isLock
                              ? "Offline Lock sent"
                              : "Offline Unlock sent",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                        );

                        setState(() => isSending = false);
                      },
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: const Color(0xff4F6BED),
                      //   padding:
                      //   const EdgeInsets.symmetric(vertical: 14),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(14),
                      //   ),
                      // ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9B65A),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isSending
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text("Send Command",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showMobileNumberPopup({
    required List<String> simNumbers,
    required List<Map<String, dynamic>> simHistory,
    bool isLoading = false,
  }) {
    // Get.dialog(
    //   Dialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(18),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //
    //           /// 🔹 LOADING
    //           if (isLoading) ...[
    //             const SizedBox(height: 10),
    //             const CircularProgressIndicator(),
    //             const SizedBox(height: 14),
    //             const Text(
    //               "Please wait...\nFetching SIM numbers",
    //               textAlign: TextAlign.center,
    //             ),
    //           ] else ...[
    //
    //             /// 🔥 NO NUMBER
    //             if (simNumbers.isEmpty)
    //               Column(
    //                 children: [
    //                   const Icon(Icons.sim_card, size: 40, color: Colors.grey),
    //                   const SizedBox(height: 8),
    //                   _infoRowForSim("SIM Number", "Not available"),
    //                 ],
    //               )
    //
    //             /// 🔥 MULTIPLE NUMBERS
    //             else
    //               ...simNumbers.asMap().entries.map((e) {
    //                 return Padding(
    //                   padding: const EdgeInsets.only(bottom: 8),
    //                   child: _infoRowForSim(
    //                     "SIM ${e.key + 1}",
    //                     e.value,
    //                   ),
    //                 );
    //               }).toList(),
    //           ],
    //
    //           const SizedBox(height: 12),
    //           if (!isLoading &&
    //               simHistory.isNotEmpty) ...[
    //
    //             const SizedBox(height: 12),
    //
    //             InkWell(
    //               onTap: () {
    //                 showSimHistoryPopup(simHistory);
    //               },
    //               child: Container(
    //                 width: double.infinity,
    //                 padding: const EdgeInsets.symmetric(vertical: 14),
    //                 decoration: BoxDecoration(
    //                   gradient: const LinearGradient(
    //                     colors: [
    //                       Color(0xFF4F6BED),
    //                       Color(0xFF3153D8),
    //                     ],
    //                   ),
    //                   borderRadius: BorderRadius.circular(50),
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: Color(0x334F6BED),
    //                       blurRadius: 12,
    //                       offset: Offset(0, 5),
    //                     ),
    //                   ],
    //                 ),
    //                 child: const Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.history,
    //                       color: Colors.white,
    //                       size: 18,
    //                     ),
    //                     SizedBox(width: 8),
    //                     Text(
    //                       "SIM History",
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w600,
    //                         fontSize: 15,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //           const SizedBox(height: 12),
    //
    //           /// 🔹 BUTTON
    //           InkWell(
    //             onTap: () {
    //               if (Get.isDialogOpen ?? false) Get.back();
    //             },
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(vertical: 16),
    //               decoration: BoxDecoration(
    //                 color: const Color(0xFF3153D8),
    //                 borderRadius: BorderRadius.circular(50),
    //               ),
    //               alignment: Alignment.center,
    //               child: const Text(
    //                 "Dismiss",
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    //   barrierDismissible: false, // 🔥 IMPORTANT
    // );
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF0A0A0A),
              ],
            ),
            border: Border.all(
              color: const Color(0x66D9B65A),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x55D9B65A),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sim_card_rounded,
                    color: Color(0xFFD9B65A),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "SIM Information",
                    style: TextStyle(
                      color: Color(0xFFF4E19C),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// LOADING
              if (isLoading) ...[
                const CircularProgressIndicator(
                  color: Color(0xFFD9B65A),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Please wait...\nFetching SIM numbers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ] else ...[

                if (simNumbers.isEmpty)
                  Column(
                    children: [
                      const Icon(
                        Icons.sim_card,
                        size: 42,
                        color: Color(0xFFD9B65A),
                      ),
                      const SizedBox(height: 10),
                      _infoRowForSim(
                        "SIM Number",
                        "Not available",
                      ),
                    ],
                  )
                else
                  ...simNumbers.asMap().entries.map(
                        (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _infoRowForSim(
                        "SIM ${e.key + 1}",
                        e.value,
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 14),

              if (!isLoading && simHistory.isNotEmpty) ...[
                InkWell(
                  onTap: () {
                    showSimHistoryPopup(simHistory);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E19C),
                          Color(0xFFD9B65A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "SIM History",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],

              InkWell(
                onTap: () {
                  if (Get.isDialogOpen ?? false) Get.back();
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFFD9B65A),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Dismiss",
                      style: TextStyle(
                        color: Color(0xFFD9B65A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showSimHistoryPopup(
      List<Map<String, dynamic>> history,
      ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 600,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF0A0A0A),
              ],
            ),
            border: Border.all(
              color: const Color(0x66D9B65A),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x55D9B65A),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [

              /// HEADER
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0x22D9B65A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history,
                      color: Color(0xFFD9B65A),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      "SIM History",
                      style: TextStyle(
                        color: Color(0xFFF4E19C),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final item = history[index];

                    final sim1 =
                        item["sim1_number"]?.toString() ?? "-";

                    final carrier1 =
                        item["sim1_carrier"]?.toString() ??
                            "Unknown";

                    final sim2 =
                    item["sim2_number"]?.toString();

                    final carrier2 =
                    item["sim2_carrier"]?.toString();

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0x44D9B65A),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x22D9B65A),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          /// HISTORY TAG
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0x22D9B65A),
                              borderRadius:
                              BorderRadius.circular(
                                  30),
                            ),
                            child: Text(
                              "History #${index + 1}",
                              style: const TextStyle(
                                color:
                                Color(0xFFD9B65A),
                                fontWeight:
                                FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          _historyRow(
                            "SIM 1",
                            sim1,
                          ),

                          _historyRow(
                            "Carrier",
                            carrier1,
                          ),

                          if (sim2 != null &&
                              sim2.isNotEmpty) ...[
                            Divider(
                              color: Colors.white
                                  .withOpacity(.08),
                            ),

                            _historyRow(
                              "SIM 2",
                              sim2,
                            ),

                            _historyRow(
                              "Carrier",
                              carrier2 ?? "-",
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFD9B65A),
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _infoRowForSim(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF151515),
        border: Border.all(
          color: const Color(0x44D9B65A),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22D9B65A),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label :",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF4E19C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 85,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0x22D9B65A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFF4E19C),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> showLocationPopup() async {
    // ✅ Initial location fetch
    await ctrl.getLocationCommand();
    await ctrl.fetchDeviceLocation();

    // ✅ Start auto-refresh every 5 minutes
    ctrl.startAutoLocationRefresh(intervalMinutes: 5);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(() {
          // return Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(28),
          //     gradient: const LinearGradient(
          //       colors: [
          //         Color(0xFFEAF0FF),
          //         Color(0xFFFFFFFF),
          //       ],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //
          //       /// 🔹 HEADER
          //       Row(
          //         children: [
          //           InkWell(
          //               onTap: () {
          //                 ctrl.stopAutoLocationRefresh();
          //                 Get.back();
          //               },
          //               child: const Icon(Icons.close)),
          //           const Spacer(),
          //           const Text(
          //             "LockPe Pro",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           const Spacer(),
          //         ],
          //       ),
          //
          //       const SizedBox(height: 12),
          //
          //       /// 🔹 TABS
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           _tabItem("Details", false),
          //           _tabItem("Commands", true),
          //           _tabItem("EMI", false),
          //         ],
          //       ),
          //
          //       const SizedBox(height: 18),
          //
          //       /// 🔹 LOCATION CARD
          //       Container(
          //         padding: const EdgeInsets.all(14),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(18),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               blurRadius: 10,
          //               color: Colors.black.withOpacity(0.05),
          //             )
          //           ],
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //
          //             const Text(
          //               "Recent Locations",
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 15,
          //               ),
          //             ),
          //
          //             const SizedBox(height: 8),
          //
          //             /// 🕒 TIME
          //             Text(
          //               ctrl.lastUpdatedText.value,
          //               style: const TextStyle(color: Colors.grey),
          //             ),
          //
          //
          //             const SizedBox(height: 8),
          //
          //             /// 📍 LOCATION ROW
          //             Row(
          //               children:  [
          //                 Icon(Icons.location_on, color: Colors.blue),
          //                 SizedBox(width: 6),
          //                 // Text(
          //                 //   "Location",
          //                 //   style: TextStyle(fontWeight: FontWeight.bold),
          //                 // ),
          //                 /// 📍 ADDRESS
          //                 Text(
          //                   ctrl.deviceAddress.value,
          //                   style: const TextStyle(fontSize: 13),
          //                 ),
          //
          //               ],
          //             ),
          //
          //             const SizedBox(height: 8),
          //
          //             // /// 📍 ADDRESS
          //             // Text(
          //             //   ctrl.deviceAddress.value,
          //             //   style: const TextStyle(fontSize: 13),
          //             // ),
          //
          //             const SizedBox(height: 8),
          //
          //             /// 🟢 STATUS ROW
          //             Row(
          //               children: [
          //                 Container(
          //                   width: 8,
          //                   height: 8,
          //                   decoration: const BoxDecoration(
          //                     color: Colors.green,
          //                     shape: BoxShape.circle,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 6),
          //                 const Text("Live Tracking ON"),
          //
          //                 const Spacer(),
          //
          //                 // Text(
          //                 //   ctrl.lastUpdatedText.value,
          //                 //   style: const TextStyle(
          //                 //     fontSize: 11,
          //                 //     color: Colors.grey,
          //                 //   ),
          //                 // ),
          //               ],
          //             ),
          //
          //             const SizedBox(height: 12),
          //
          //             /// 🔄 LOADER
          //             if (ctrl.isLocationLoading.value)
          //               const Center(
          //                 child: Padding(
          //                   padding: EdgeInsets.all(10),
          //                   child: CircularProgressIndicator(),
          //                 ),
          //               ),
          //
          //             const SizedBox(height: 10),
          //
          //             /// 📍 VIEW MAP BUTTON
          //             SizedBox(
          //               width: double.infinity,
          //               child: ElevatedButton.icon(
          //                 icon: const Icon(Icons.location_on),
          //                 label: const Text("View on Map"),
          //                 style: ElevatedButton.styleFrom(
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(30),
          //                   ),
          //                 ),
          //                 onPressed: () {
          //                   openMap(
          //                     ctrl.latitude.value,
          //                     ctrl.longitude.value,
          //                   );
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //
          //       const SizedBox(height: 14),
          //
          //       /// 🔹 LIVE TRACK TOGGLE
          //       Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 12),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(16),
          //           color: Colors.white,
          //         ),
          //         child: const SwitchListTile(
          //           value: true,
          //           onChanged: null,
          //           title: Text("Live Tracking ON"),
          //           secondary: Icon(Icons.circle, color: Colors.green),
          //         ),
          //       ),
          //
          //       const SizedBox(height: 16),
          //
          //       /// 🔹 BUTTONS
          //       Column(
          //         children: [
          //
          //           /// 🔄 REFRESH
          //           GestureDetector(
          //             onTap: () => ctrl.fetchDeviceLocation(),
          //             child: Container(
          //               width: double.infinity,
          //               padding: const EdgeInsets.symmetric(vertical: 14),
          //               decoration: BoxDecoration(
          //                 gradient: const LinearGradient(
          //                   colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          //                 ),
          //                 borderRadius: BorderRadius.circular(30),
          //               ),
          //               child: const Center(
          //                 child: Text(
          //                   "Refresh Location",
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             ),
          //           ),
          //
          //           const SizedBox(height: 10),
          //
          //           /// ❌ CANCEL
          //           GestureDetector(
          //             onTap: () {
          //               ctrl.stopAutoLocationRefresh();
          //               Get.back();
          //             },
          //             child: Container(
          //               width: double.infinity,
          //               padding: const EdgeInsets.symmetric(vertical: 14),
          //               decoration: BoxDecoration(
          //                 border: Border.all(color: Colors.blue),
          //                 borderRadius: BorderRadius.circular(30),
          //               ),
          //               child: const Center(
          //                 child: Text("Cancel"),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // );
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              border: Border.all(
                color: const Color(0x66D9B65A),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x55D9B65A),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// HEADER
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ctrl.stopAutoLocationRefresh();
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x22D9B65A),
                          border: Border.all(
                            color: const Color(0x55D9B65A),
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFD9B65A),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "UNIQ LOCK",
                      style: TextStyle(
                        color: Color(0xFFF4E19C),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 20),

                /// LOCATION CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFF151515),
                    border: Border.all(
                      color: const Color(0x44D9B65A),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Recent Location",
                        style: TextStyle(
                          color: Color(0xFFF4E19C),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        ctrl.lastUpdatedText.value,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFD9B65A),
                          ),
                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              ctrl.deviceAddress.value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Live Tracking ON",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      if (ctrl.isLocationLoading.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD9B65A),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.map,
                            color: Colors.black,
                          ),
                          label: const Text(
                            "View on Map",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9B65A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            openMap(
                              ctrl.latitude.value,
                              ctrl.longitude.value,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// LIVE TRACKING STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0x44D9B65A),
                    ),
                  ),
                  child: const SwitchListTile(
                    value: true,
                    onChanged: null,
                    title: Text(
                      "Live Tracking ON",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    secondary: Icon(
                      Icons.circle,
                      color: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// REFRESH
                GestureDetector(
                  onTap: () => ctrl.fetchDeviceLocation(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF4E19C),
                          Color(0xFFD9B65A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Refresh Location",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// CLOSE
                GestureDetector(
                  onTap: () {
                    ctrl.stopAutoLocationRefresh();
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD9B65A),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: Color(0xFFD9B65A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void showAppUpdateDialog() {
    final ctrl = Get.find<CustomerDetailV2Controller>();

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            /// 🔥 PREMIUM GRADIENT
            gradient: const LinearGradient(
              colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔵 ICON WITH GLOW
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff4F6BED).withOpacity(.1),
                ),
                child: const Icon(
                  Icons.system_update_alt,
                  color: Color(0xff4F6BED),
                  size: 28,
                ),
              ),

              const SizedBox(height: 14),

              /// 🔥 TITLE
              const Text(
                "Update App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1E2A5A),
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 DESC
              const Text(
                "Are you sure you want to update the app on this device?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              /// 🔥 BUTTONS
              Row(
                children: [

                  /// CANCEL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(
                          color: const Color(0xff4F6BED).withOpacity(.3),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// UPDATE BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final deviceId = ctrl.actualDeviceId;

                        if (deviceId.isEmpty) {
                          Get.back();
                          Get.snackbar("Error", "Device ID missing");
                          return;
                        }

                        try {
                          final req = DeviceCommandRequest(
                            deviceId: deviceId,
                            // commandType: "UPDATE_APP",
                            commandType: "MDM_APP_UPDATE",
                          );

                          await ctrl.sendUpdateAppCommand(req);

                          /// ✅ CLOSE DIALOG (SAFE)
                          if (Get.isDialogOpen == true) {
                            Navigator.of(Get.overlayContext!).pop();
                          }

                          /// ✅ CLEAR OLD SNACKBARS
                          Get.closeAllSnackbars();

                          /// ✅ SUCCESS TOAST
                          Get.rawSnackbar(
                            message: "App update command sent",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            margin: const EdgeInsets.all(12),
                            borderRadius: 12,
                            duration: const Duration(seconds: 2),
                          );
                        } catch (e) {
                          Get.back();
                          Get.snackbar("Error", "Failed to send command");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xff4F6BED),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _tabItem(String title, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2563EB) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _emiTab(BuildContext context) {
    if (ctrl.isDetailsLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ctrl.customer.value == null) {
      return Center(
        child: TextButton(
          onPressed: ctrl.fetchCustomerDetails,
          child: const Text("Retry"),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _importantInfoCard(),
          // const SizedBox(height: 16),

          // _loanProgress(),
          // const SizedBox(height: 16),
          // _emiSettings(),
          // const SizedBox(height: 16),
          _emiTable(context),
          SizedBox(height: 30,),
        ],
      ),
    );
  }

  // Widget _importantInfoCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(18),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(.04),
  //           blurRadius: 10,
  //         )
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: const [
  //             Text(
  //               "Important Info.",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             _infoColumnLeft(),
  //             const SizedBox(width: 12),
  //             Container(width: 1, height: 150, color: Colors.grey.shade300),
  //             const SizedBox(width: 12),
  //             _infoColumnRight(),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _importantInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFFD9B65A),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Loan Information",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF4E19C),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoRowV2("Loan ID", ctrl.loanId),
              _InfoRowV2("Product Price", fmtMoney(ctrl.productPrice)),
              _InfoRowV2("Loan Amount", fmtMoney(ctrl.loanAmount)),
              _InfoRowV2("Down Payment", fmtMoney(ctrl.downPayment)),
              _InfoRowV2("EMI Amount", fmtMoney(ctrl.emiAmount)),
              _InfoRowV2("Tenure", fmtTenureMonths(ctrl.tenure)),
              _InfoRowV2("Processing Fee", fmtMoney(ctrl.processingFee)),
              _InfoRowV2("Loan By", ctrl.loanBy),
              _InfoRowV2("Down Payment Date", fmtDate(ctrl.downPaymentDate)),
              _InfoRowV2("First EMI Date", fmtDate(ctrl.firstEmiDate)),
            ],
          ),
        ],
      ),
    );
  }
  Widget _infoColumnLeft() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRowV2("Loan ID", ctrl.loanId),
          _InfoRowV2("Product Price", fmtMoney(ctrl.productPrice)),
          _InfoRowV2("Down Payment Date", fmtDate(ctrl.downPaymentDate)),
          _InfoRowV2("Down Payment", fmtMoney(ctrl.downPayment)),
          _InfoRowV2("Loan Amount", fmtMoney(ctrl.loanAmount)),
        ],
      ),
    );
  }

  Widget _infoColumnRight() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRowV2("Tenure", fmtTenureMonths(ctrl.tenure)),
          _InfoRowV2("Processing Fee", fmtMoney(ctrl.processingFee)),
          _InfoRowV2("EMI Amount", fmtMoney(ctrl.emiAmount)),
          _InfoRowV2("First EMI Date", fmtDate(ctrl.firstEmiDate)),
          _InfoRowV2("Loan By", ctrl.loanBy),
        ],
      ),
    );
  }

  String fmtMoney(num value) => "₹ ${value.toStringAsFixed(2)}";

  String fmtDate(String value) {
    if (value.trim().isEmpty || value == "-") return "-";
    return formatApiDate(value);
  }

  String fmtTenureMonths(int months) => months > 0 ? "$months Months" : "-";

  String fmtPercent(double p) {
    final val = (p <= 1) ? (p * 100) : p;
    return "${val.round()}%";
  }

  Widget _loanProgress() {
    return Obx(() {
      final percentage = ctrl.progressPercentage;
      final progressValue = ctrl.progress;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Loan Progress",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text("${fmtPercent(percentage)} Paid"),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xff4F6BED),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              "Paid EMI: ${ctrl.paidEmi}/${ctrl.totalEmi}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _emiSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _switchTile(
            "Auto Lock",
            "Pay EMI in 3 days to avoid phone lock.",
            ctrl.autoLock,
          ),
          const Divider(),
          _switchTile(
            "Add Overdue Amount",
            "Late charges will be added to your EMI.",
            ctrl.addOverdueAmount,
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, RxBool rxValue) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Switch(
          value: rxValue.value,
          onChanged: (v) => rxValue.value = v,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xff4F6BED),
        )
      ],
    ));
  }


  Widget _emiTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Obx(
            () => Column(
          children: [
            _tableHeader(),
            const SizedBox(height: 8),
            const Divider(
              color: Color(0x33D9B65A),
            ),
            ...List.generate(ctrl.emis.length, (i) {
              final e = ctrl.emis[i];

              final color =
              e.status == CustomerDetailV2EmiStatus.paid
                  ? Colors.green
                  : Colors.redAccent;

              return _emiRow(
                context,
                i,
                e.emiNumber,
                e.amount,
                e.status.label,
                color,
                paidDate: e.paidDate,
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            "EMI",
            style: TextStyle(
              color: Color(0xFFF4E19C),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Amount",
            style: TextStyle(
              color: Color(0xFFF4E19C),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Status",
            style: TextStyle(
              color: Color(0xFFF4E19C),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Action",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF4E19C),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
  Widget _emiRow(
      BuildContext context,
      int index,
      dynamic emiNumber,
      dynamic amount,
      String status,
      Color color, {
        DateTime? paidDate,
      }) {
    final bool isPaid = status.toLowerCase() == "paid";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x22D9B65A),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$emiNumber",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              "₹ ${amount ?? 0}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isPaid
                    ? Colors.green.withOpacity(.12)
                    : Colors.red.withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: isPaid
                ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      paidDate != null
                          ? DateFormat("dd MMM yyyy")
                          .format(paidDate)
                          : "Paid",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  ctrl.openChangeStatusSheet(
                    context,
                    index,
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFFD9B65A),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Update",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentsSection() {
    final aadhaarFront = ctrl.customer.value?.aadhaarFront ?? "";
    final aadhaarBack = ctrl.customer.value?.aadhaarBack ?? "";
    final signature = ctrl.customer.value?.signature ?? "";

    final docs = [
      {
        "title": "Aadhaar Front",
        "url": aadhaarFront,
        "icon": Icons.credit_card,
      },
      {
        "title": "Aadhaar Back",
        "url": aadhaarBack,
        "icon": Icons.credit_card_outlined,
      },
      {
        "title": "Signature",
        "url": signature,
        "icon": Icons.edit,
      },
      {
        "title": "Agreement",
        "url": "local",
        "icon": Icons.picture_as_pdf,
        "isDownload": true,
      },
    ];

    final availableDocs = docs.where((d) {
      if (d["isDownload"] == true) return true;
      return (d["url"] as String).trim().isNotEmpty;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.08),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Documents",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF4E19C),
            ),
          ),

          const SizedBox(height: 16),

          if (availableDocs.isEmpty)
            const Text(
              "No documents available",
              style: TextStyle(
                color: Colors.white70,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableDocs.map((doc) {
                return _documentCard(
                  title: doc["title"] as String,
                  url: doc["url"] as String,
                  icon: doc["icon"] as IconData,
                  isAgreement: doc["isDownload"] == true,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
  Widget _documentCard({
    required String title,
    required String url,
    required IconData icon,
    bool isAgreement = false,
  }) {
    return InkWell(
      onTap: () {
        if (url == "local") {
          ctrl.generateAgreementFromCustomerDetail();
        } else {
          ctrl.viewDoc(url);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 115,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0x44D9B65A),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x22D9B65A),
                border: Border.all(
                  color: const Color(0x55D9B65A),
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xFFD9B65A),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFF4E19C),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0x22D9B65A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isAgreement ? "DOWNLOAD" : "VIEW",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD9B65A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unlockButton() {
    return Obx(() => OutlinedButton.icon(
      onPressed: ctrl.isUnlocking.value ? null : ctrl.unlockNow,
      icon: ctrl.isUnlocking.value
          ? const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : const Icon(Icons.lock_open, color: Color(0xff2E7D32), size: 20),
      label: Text(
        ctrl.isUnlocking.value ? "Unlocking..." : "Unlock Phone",
        style: const TextStyle(
          color: Color(0xff2E7D32),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xffF3FBF6),
        side: const BorderSide(color: Color(0xff2E7D32), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ));
  }

  Widget _lockButton() {
    return Obx(() => ElevatedButton.icon(
      onPressed: ctrl.isLocking.value ? null : ctrl.lockNow,
      icon: ctrl.isLocking.value
          ? const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : const Icon(Icons.lock, color: Colors.white, size: 20),
      label: Text(
        ctrl.isLocking.value ? "Locking..." : "Lock Phone",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffD95763),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ));
  }
}

class _InfoRowV2 extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRowV2(
      this.label,
      this.value,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 70) / 2,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x33D9B65A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value.isEmpty ? "-" : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF4E19C),
            ),
          ),
        ],
      ),
    );
  }
}