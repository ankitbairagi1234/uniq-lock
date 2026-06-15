import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zlock_smart_finance/app/constants/map_open_halper.dart';
import 'package:zlock_smart_finance/app/utils/date_formate.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_controller.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';

class CustomerDetailV2Page extends StatelessWidget {
  CustomerDetailV2Page({super.key});

  final CustomerDetailV2Controller ctrl = Get.find<CustomerDetailV2Controller>();
  final NewKeyController c = Get.find<NewKeyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        title: const Text("Details"),
        centerTitle: true,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() {
        if (ctrl.selectedTab.value != 0) return const SizedBox.shrink();

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          decoration: const BoxDecoration(
            color: Color(0xffF6F7FB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _unlockButton()),
              const SizedBox(width: 14),
              Expanded(child: _lockButton()),
            ],
          ),
        );
      }),
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
            selectedColor: const Color(0xff4F6BED),
            onSelected: (_) => ctrl.selectedTab.value = e.key,
            labelStyle: TextStyle(
              color: ctrl.selectedTab.value == e.key
                  ? Colors.white
                  : Colors.black,
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
            const SizedBox(height: 16),
            _deviceStatus(),
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
          const Text("Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _numberTile(Icons.sim_card, "SIM 1", ctrl.customerPhone),
          _divider(),
          _numberTile(Icons.qr_code, "IMEI 1", ctrl.imei1),
          _divider(),
          _numberTile(Icons.qr_code, "IMEI 2", ctrl.imei2),
          _divider(),
          _numberTile(Icons.phone_android, "Brand/Model", ctrl.brandModel),
        ],
      ),
    );
  }

  Widget _inputField({
    IconData? icon,
    String? svgPath,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.grey, size: 20),
          if (svgPath != null)
            SvgPicture.asset(svgPath, width: 20, height: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xff4F6BED)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      )
    ],
  );



  Widget _commandsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),

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

          const SizedBox(height: 18),

          /// 🔴 SPECIAL COMMANDS (NOW HERE)
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: ctrl.specialCommands.length,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     childAspectRatio: 1.1,
          //     crossAxisSpacing: 12,
          //     mainAxisSpacing: 12,
          //   ),
          //   itemBuilder: (_, i) {
          //     final key = ctrl.specialCommands[i];
          //
          //     /// ❌ Remove "Remove Key" from grid
          //     if (key == "Remove Key") return const SizedBox();
          //
          //     return _actionCard(
          //       title: key,
          //       iconPath: ctrl.iconFor(key),
          //       onTap: () => onSpecialCommandTap(key),
          //     );
          //   },
          // ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ctrl.orderedCommands.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) {
              final title = ctrl.orderedCommands[i];

              /// 👉 SPECIAL COMMANDS (Location, Mobile No)
              if (ctrl.specialCommands.contains(title)) {
                return _actionCard(
                  title: title,
                  iconPath: ctrl.iconFor(title),
                  onTap: () => onSpecialCommandTap(title),
                );
              }

              /// 👉 NORMAL COMMANDS
              final internalKey =
                  ctrl.displayToInternalCommand[title] ?? title;

              return Obx(() {
                final command = ctrl.commands[internalKey];
                final isComingSoon =
                ctrl.comingSoonCommands.contains(title);

                return _miniCommandCard(
                  title: title,
                  iconPath: ctrl.iconFor(internalKey),
                  value: command?.value ?? false,
                  loading: ctrl.isCommandLoading(internalKey),
                  onChanged: isComingSoon
                      ? (_) {
                    Get.snackbar(
                        "Coming Soon", "$title will be available soon");
                  }
                      : (v) => ctrl.onCommandToggle(internalKey, v),
                  isDisabled: isComingSoon,
                );
              });
            },
          ),

          const SizedBox(height: 18),

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
          const SizedBox(height: 30),

          /// 🔥 REMOVE KEY BIG BUTTON (BOTTOM)
          // Obx(() {
          //   final loading = ctrl.isCommandLoading("Remove Key");
          //
          //   return GestureDetector(
          //     onTap: loading ? null : () => onSpecialCommandTap("Remove Key"),
          //     child: Container(
          //       width: double.infinity,
          //       padding: const EdgeInsets.symmetric(vertical: 18),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(14),
          //       ),
          //       alignment: Alignment.center,
          //       child: loading
          //           ? const CircularProgressIndicator(color: Colors.white)
          //           : const Text(
          //         "Remove Device",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   );
          // }),
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
                                  child: Text("Remove"),
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Remove Device",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),

    );
  }


  Widget _socialMediaModernCard({
    required bool value,
    required bool isLoading,
    required ValueChanged<bool>? onChanged,
  }) {
    Widget icon(String asset) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        padding: const EdgeInsets.all(9),
        child: SvgPicture.asset(
          asset,
          placeholderBuilder: (_) => const Center(
            child: SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorBuilder: (_, __, ___) => const Icon(
            Icons.apps,
            size: 18,
            color: Color(0xff4F6BED),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFF7F9FF), Color(0xFFEAF0FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xff4F6BED).withOpacity(.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [

          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Social Media",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xff1E2A5A),
                ),
              ),
              isLoading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: const Color(0xff4F6BED),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔥 CENTER DESIGN
          Stack(
            alignment: Alignment.center,
            children: [

              /// glow
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff4F6BED).withOpacity(.08),
                ),
              ),

              /// ✅ CENTER LOGO (REPLACED LOCK ICON)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff4F6BED), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff4F6BED).withOpacity(.15),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/images/lock_pe.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// 🔵 ICONS AROUND
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [

                    // Positioned(
                    //     top: 0,
                    //     left: 78,
                    //     child: icon("assets/icons/commands/youtube.svg")),
                    Positioned(
                        top: 0,
                        left: 78,
                        child: icon("assets/icons/commands/youtube_colour.svg")),

                    // Positioned(
                    //     top: 40,
                    //     right: 10,
                    //     child: icon("assets/icons/commands/whatsapp.svg")),
                    Positioned(
                        top: 40,
                        right: 10,
                        child: icon("assets/icons/commands/whatsupp_colour.svg")),

                    Positioned(
                        right: 8,
                        top: 110,
                        child: icon("assets/icons/commands/wa_business.svg",)),


                    Positioned(
                        bottom: 0,
                        left: 78,
                        child: icon("assets/icons/commands/facebook_color.svg")),

                    Positioned(
                        left: 8,
                        top: 110,
                        child: icon("assets/icons/commands/insta_colour.svg")),

                    Positioned(
                        top: 40,
                        left: 10,
                        child: icon("assets/icons/commands/arattai_colour.svg")),
                  ],
                ),
              ),
            ],
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xff4F6BED)),
          color: Colors.white,
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

  Future<void> onSpecialCommandTap(String title) async {
    if (title == 'Location') {
      showLocationPopup();
      return;
    }

    if (title == 'Mobile No') {
      showMobileNumberPopup(
        registeredNumber: ctrl.customerPhone,
        currentNumber: ctrl.customerPhone,
      );
      return;
    }

    if (title == 'Remove Key') {
      await ctrl.sendRemoveKeyCommand();

      // ctrl.confirmAndRemoveKey(); // ✅ NEW

      // ctrl.confirmAndRemoveKey();
      return;
    }
  }

  void showMobileNumberPopup({
    required String registeredNumber,
    required String currentNumber,
  }) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRowForSim("Registered\nNumber", registeredNumber),
              const SizedBox(height: 12),
              _infoRowForSim("Current\nNumber", currentNumber.isEmpty ? "-" : currentNumber),
              const SizedBox(height: 14),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3153D8),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Dismiss",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRowForSim(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff2E3A8C), width: 1.2),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label  :",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
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
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEAF0FF),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔹 HEADER
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          ctrl.stopAutoLocationRefresh();
                          Get.back();
                        },
                        child: const Icon(Icons.close)),
                    const Spacer(),
                    const Text(
                      "LockPe Pro",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 12),

                /// 🔹 TABS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabItem("Details", false),
                    _tabItem("Commands", true),
                    _tabItem("EMI", false),
                  ],
                ),

                const SizedBox(height: 18),

                /// 🔹 LOCATION CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Recent Locations",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 🕒 TIME
                      Text(
                        ctrl.lastUpdatedText.value,
                        style: const TextStyle(color: Colors.grey),
                      ),


                    const SizedBox(height: 8),

                      /// 📍 LOCATION ROW
                      Row(
                        children:  [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 6),
                          // Text(
                          //   "Location",
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          /// 📍 ADDRESS
                          Text(
                            ctrl.deviceAddress.value,
                            style: const TextStyle(fontSize: 13),
                          ),

                        ],
                      ),

                      const SizedBox(height: 8),

                      // /// 📍 ADDRESS
                      // Text(
                      //   ctrl.deviceAddress.value,
                      //   style: const TextStyle(fontSize: 13),
                      // ),

                      const SizedBox(height: 8),

                      /// 🟢 STATUS ROW
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
                          const Text("Live Tracking ON"),

                          const Spacer(),

                          // Text(
                          //   ctrl.lastUpdatedText.value,
                          //   style: const TextStyle(
                          //     fontSize: 11,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 🔄 LOADER
                      if (ctrl.isLocationLoading.value)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          ),
                        ),

                      const SizedBox(height: 10),

                      /// 📍 VIEW MAP BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.location_on),
                          label: const Text("View on Map"),
                          style: ElevatedButton.styleFrom(
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

                /// 🔹 LIVE TRACK TOGGLE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: const SwitchListTile(
                    value: true,
                    onChanged: null,
                    title: Text("Live Tracking ON"),
                    secondary: Icon(Icons.circle, color: Colors.green),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 BUTTONS
                Column(
                  children: [

                    /// 🔄 REFRESH
                    GestureDetector(
                      onTap: () => ctrl.fetchDeviceLocation(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Refresh Location",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ❌ CANCEL
                    GestureDetector(
                      onTap: () {
                        ctrl.stopAutoLocationRefresh();
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text("Cancel"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _importantInfoCard(),
          const SizedBox(height: 16),
          _loanProgress(),
          const SizedBox(height: 16),
          _emiSettings(),
          const SizedBox(height: 16),
          _emiTable(context),
        ],
      ),
    );
  }

  Widget _importantInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Important Info.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoColumnLeft(),
              const SizedBox(width: 12),
              Container(width: 1, height: 150, color: Colors.grey.shade300),
              const SizedBox(width: 12),
              _infoColumnRight(),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() => Column(
        children: [
          _tableHeader(),
          const Divider(),
          ...List.generate(ctrl.emis.length, (i) {
            final e = ctrl.emis[i];
            final color = e.status == CustomerDetailV2EmiStatus.paid
                ? Colors.green
                : Colors.red;

            return _emiRow(
              context,
              i,
              e.date,
              e.amount,
              e.status.label,
              color,
            );
          }),
        ],
      )),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
        Expanded(child: Text("Date", style: TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text("Amount", style: TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text("Action", style: TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _emiRow(
      BuildContext context,
      int index,
      String date,
      String amount,
      String status,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(date)),
          Expanded(child: Text(amount)),
          Expanded(child: Text(status, style: TextStyle(color: color))),
          Expanded(
            child: ElevatedButton(
              onPressed: () => ctrl.openChangeStatusSheet(context, index),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4F6BED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                "Action",
                style: TextStyle(color: Colors.white, fontSize: 12),
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
        "icon": Icons.picture_as_pdf, // ✅ PDF icon
        "isDownload": true, // ✅ NEW FLAG
      },
    ];

    // final availableDocs =
    // docs.where((d) => (d["url"] as String).trim().isNotEmpty).toList();

    final availableDocs = docs.where((d) {
      if (d["isAgreement"] == true) return true; // ✅ always show
      return (d["url"] as String).trim().isNotEmpty;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Documents",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          if (availableDocs.isEmpty)
            const Text("No documents available")
          else
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: availableDocs.map((doc) {
                return _documentCard(
                  title: doc["title"] as String,
                  url: doc["url"] as String,
                  icon: doc["icon"] as IconData,
                  isAgreement: doc["isAgreement"] == true, // ✅ important
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
        if (url =="local") {
          ctrl.generateAgreementFromCustomerDetail(); // 🔥 MAIN CALL
        } else {
          ctrl.viewDoc(url);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF3F6FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: const Color(0xff4F6BED)),
            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff4F6BED),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              isAgreement ? "Download" : "View", // ✅ dynamic
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xff4F6BED),
              ),
            )
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
  final String label, value;
  const _InfoRowV2(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}