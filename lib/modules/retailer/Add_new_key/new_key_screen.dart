import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:zlock_smart_finance/app/constants/app_colors.dart';
import 'package:zlock_smart_finance/app/utils/common_bottom_button.dart';
import 'package:zlock_smart_finance/modules/retailer/dashboard/dashboard_retailer.dart';
import 'new_key_controller.dart';

class NewKeyScreen extends StatelessWidget {
  final String title;
  final NewKeyEntry entry;

  NewKeyScreen({super.key,required this.title,
    required this.entry,});


  String get _tag => entry.name; // unique per entry

  NewKeyController get c => Get.find<NewKeyController>(tag: _tag);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final ok = await c.confirmExitAndClear();
        if (ok) {
          Get.delete<NewKeyController>(tag: _tag, force: true); // ✅ important
          Get.back();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ IMPORTANT

        backgroundColor: const Color(0xFF0A0A0A),
        body: SingleChildScrollView(
          controller: _scrollController, // ✅

          // padding: const EdgeInsets.fromLTRB(16, 50, 16, 350),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            16,
            50,
            16,
            MediaQuery.of(context).viewInsets.bottom + 350, // ✅ MAGIC
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 16),
              _basicDetails(context),
              const SizedBox(height: 16),
              // _buildSignatureBlock(context),
              const SizedBox(height: 16),
              _collapseHeader(),
              Obx(() => c.showMore.value ? _expandedSection(context) : const SizedBox()),
              _buildSignatureBlock(context),

            ],
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(() {
          final loading = c.isSubmitting.value;
          final isDisabled = !c.agreeTerms.value || loading;

          return CommonBottomButton(
            title: loading ? "Submitting..." : "Submit",
            showAgreement: true,
            agreeRx: c.agreeTerms,
            controllerTag: _tag, // ✅ IMPORTANT

            // ✅ only button disable
            isButtonDisabled: isDisabled,

            onTap: () {
              if (loading) return;

              if (!c.agreeTerms.value) {
                Get.snackbar(
                  "Required",
                  "Please accept Terms & Conditions",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              // debugPrint("🔑 SUBMIT KEY BUTTON CLICKED");
              // c.submitAddKey();

              debugPrint("🔑 SUBMIT KEY BUTTON CLICKED");

              if (entry == NewKeyEntry.running) {
                debugPrint("🏠 RUNNING KEY SUBMIT → Dashboard will show homeQR");
              } else {
                debugPrint("🆕 NEW KEY SUBMIT → Dashboard will show qrCodeRecord");
              }

              c.submitAddKey();

            },
          );
        }),

      ),
    );
  }

  Widget _scrollOnFocus({
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              Future.delayed(const Duration(milliseconds: 300), () {
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: 0.2,
                );
              });
            }
          },
          child: child,
        );
      },
    );
  }

  /// HEADER

  Widget _header(BuildContext context) => Row(
    children: [
      _circleBtn(Icons.arrow_back, () async {
        final ok = await c.confirmExitAndClear();
        if (ok && context.mounted) {
          Get.delete<NewKeyController>(tag: _tag, force: true); // ✅ important
          Navigator.of(context).pop();
        }
      }),
      const Spacer(),
      Text(
        title, // ✅ dynamic
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF4E19C),
        ),
      ),
      const Spacer(flex: 2),
    ],
  );
  /// BASIC DETAILS
  Widget _basicDetails(BuildContext context) => _card(
    Column(
      children: [
        // ListTile(
        //   leading: const CircleAvatar(
        //     backgroundColor: Color(0xffEFF2FF),
        //     child: Icon(Icons.camera_alt_outlined, color: Color(0xff4F6BED)),
        //   ),
        //   title: const Text("Customer + Product Image",
        //       style: TextStyle(fontWeight: FontWeight.w600)),
        //   subtitle: const Text("Upload photos",
        //       style: TextStyle(color: Color(0xff4F6BED))),
        // ),
        Obx(() {
          final path = c.customerProductImagePath.value;
          final hasImage = path.isNotEmpty;

          return InkWell(
            onTap: () => c.showImagePickOptions(context),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: hasImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(path),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
                  : const CircleAvatar(
                backgroundColor: Color(0x22D9B65A),
                child: Icon(Icons.camera_alt_outlined,
                    color: Color(0xFFF4E19C)),
              ),
              title: const Text(
                "Customer + Product Image",
                style: TextStyle(fontWeight: FontWeight.w600,color: Color(0xFFF4E19C)),
              ),
              subtitle: Text(
                hasImage ? "Image selected" : "Upload photos",

                style: const TextStyle(color: Color(0xFFF4E19C)),
              ),
              trailing: const Icon(Icons.chevron_right,color: Color(0xFFD9B65A),),
            ),
          );
        }),

        _scrollOnFocus(
          child: _inputName("Customer Name", c.customerName),
        ),
        _scrollOnFocus(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: c.imei,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: const Color(0xFFD9B65A),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: "IMEI Number",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: const Color(0xFF151515),

                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFFD9B65A),
                  ),
                  onPressed: () {
                    FocusScope.of(Get.context!).unfocus();
                    c.scanImei();
                  },
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0x55D9B65A),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFD9B65A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        _scrollOnFocus(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: c.imei2,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: const Color(0xFFD9B65A),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: "IMEI Number 2 (Optional)",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: const Color(0xFF151515),

                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFFD9B65A),
                  ),
                  onPressed: () {
                    FocusScope.of(Get.context!).unfocus();
                    c.scanImei2();
                  },
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0x55D9B65A),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFD9B65A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),


        _scrollOnFocus(
          child: _inputNumber("Mobile Number",
               c.mobile,
              maxLength: 10,
             digitsOnly: true,
          ),
        ),
        // _scrollOnFocus(
        //   child: _input("IMEI Number", c.imei, suffix: Icons.qr_code_scanner)
        // ),
        // _scrollOnFocus(
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 12),
        //     child: TextField(
        //       controller: c.imei,
        //       keyboardType: TextInputType.number,
        //       inputFormatters: [
        //         FilteringTextInputFormatter.digitsOnly,
        //         LengthLimitingTextInputFormatter(15), // ✅ max 15
        //       ],
        //       decoration: InputDecoration(
        //         hintText: "IMEI Number",
        //         suffixIcon: IconButton(
        //           icon: const Icon(Icons.qr_code_scanner),
        //           onPressed: () {
        //             FocusScope.of(Get.context!).unfocus(); // ✅ keyboard close
        //             c.scanImei(); // ✅ open scanner
        //           },
        //         ),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(16),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        //
        // _scrollOnFocus(
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 12),
        //     child: TextField(
        //       controller: c.imei2,
        //       keyboardType: TextInputType.number,
        //       inputFormatters: [
        //         FilteringTextInputFormatter.digitsOnly,
        //         LengthLimitingTextInputFormatter(15), // ✅ max 15
        //       ],
        //       decoration: InputDecoration(
        //         hintText: "IMEI Number 2 (Optional)",
        //         suffixIcon: IconButton(
        //           icon: const Icon(Icons.qr_code_scanner),
        //           onPressed: () {
        //             FocusScope.of(Get.context!).unfocus();
        //             c.scanImei2(); // 👇 new function
        //           },
        //         ),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(16),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),


        // _dropdown("Loan Provider"),
        _loanProviderDropdown(), //

        // _aadharRow(context), //
        // _scrollOnFoc us(
        //   child: _inputName("Brand/Model", c.brandModel),
        // ),
      ],
    ),
  );

  Widget _aadharRow(BuildContext context) {
    Widget card({
      required String title,
      required RxString pathRx,
      required VoidCallback onTap,
    }) {
      return Obx(() {
        final path = pathRx.value;
        final has = path.isNotEmpty;

        return InkWell(
          onTap: onTap,
          child: Container(
            height: 92,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffCBD3EE)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // preview / plus icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0x22D9B65A),
                  ),
                  child: has
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.add, color: Color(0x22D9B65A), size: 28),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        has ? "Selected" : "Upload",
                        style: const TextStyle(
                          color: Color(0x22D9B65A),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        );
      });
    }

    return Row(
      children: [
        Expanded(
          child: card(
            title: "Aadhaar Front",
            pathRx: c.aadharFrontPath,
            onTap: () => c.pickAadharImage(context, AadharSide.front),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: card(
            title: "Aadhaar Back",
            pathRx: c.aadharBackPath,
            onTap: () => c.pickAadharImage(context, AadharSide.back),
          ),
        ),
      ],
    );
  }

  /// SIGNATURE
  // Widget _buildSignatureBlock(BuildContext context) {
  //   // final ctrl = controller;
  //   final height = 150.0;
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Expanded(
  //               child: Text(
  //                 'Customer Signature*',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () => c.resetSignature(),
  //               child: const Text(
  //                 'Reset',
  //                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //         Container(
  //           height: height,
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(14),
  //             border: Border.all(color: Colors.grey.shade200),
  //           ),
  //           child: Signature(
  //             controller: c.signatureController,
  //             backgroundColor: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSignatureBlock(BuildContext context) {
    return Obx(() {
      final hasSign = c.hasSignature.value;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Customer Signature*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF4E19C),
                    ),
                  ),
                ),
                if (hasSign)
                  GestureDetector(
                    onTap: () => c.resetSignature(),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            /// Tap to Sign OR Preview
            GestureDetector(
              onTap: () => _openSignatureDialog(context),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B1B1B),
                      Color(0xFF0A0A0A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0x55D9B65A),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD9B65A).withOpacity(.10),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: hasSign
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.white,
                    child: Image.memory(
                      c.signatureBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.draw,
                      color: Color(0xFFD9B65A),
                      size: 36,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap to Sign",
                      style: TextStyle(
                        color: Color(0xFFF4E19C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Digital signature pad will open",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  void _openSignatureDialog(BuildContext context) {
    final tempController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              const Text(
                "✍️ Add Signature",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4E19C),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Sign within the box below",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 16),

              /// Signature Box
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x55D9B65A),
                  ),
                ),
                child: Signature(
                  controller: tempController,
                  backgroundColor: Colors.transparent,
                ),
              ),

              const SizedBox(height: 16),

              /// Buttons
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0x55D9B65A),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// Reset
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => tempController.clear(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0x55D9B65A),
                        ),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          color: Color(0xFFD9B65A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// Save
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9B65A),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        if (tempController.isEmpty) {
                          Get.snackbar(
                            "Required",
                            "Please add signature",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        final bytes =
                        await tempController.toPngBytes();

                        c.setSignature(bytes!);

                        Get.back();
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
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
      barrierDismissible: false,
    );
  }
  /// COLLAPSE HEADER
  Widget _collapseHeader() => GestureDetector(
    onTap: () => c.showMore.toggle(),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Click to fill more details",
                  style: TextStyle(
                    color: Color(0xFFF4E19C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "EMI, ECS & E-Mandate....",
                  style: TextStyle(
                    color: Color(0xFFD9B65A),
                  ),
                ),
              ],
            ),
          ),
          Obx(
                () => Icon(
              c.showMore.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: const Color(0xFFD9B65A),
            ),
          ),
        ],
      ),
    ),
  );
  /// EXPANDED CONTENT
  Widget _expandedSection(BuildContext context) => Obx(() {
    final hideAll = c.paymentType.value == PaymentType.withoutEmi;

    return Column(
      children: [
        const SizedBox(height: 16),
        paymentTypeCard(),

        if (!hideAll) ...[
          const SizedBox(height: 16),
          _emiSection(),
          const SizedBox(height: 16),
          _loanDate(context),
        ],
      ],
    );
  });

  /// PAYMENT TYPE
  Widget paymentTypeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color:AppColors.kCardBg,
      //   borderRadius: BorderRadius.circular(20),
      //   boxShadow: const [
      //     BoxShadow(
      //       color: Color(0x0F000000),
      //       blurRadius: 12,
      //       offset: Offset(0, 4),
      //     )
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x55D9B65A),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9B65A).withOpacity(.10),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          RichText(
            text: const TextSpan(
              text: "Payment Type ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF4E19C),
              ),
              children: [
                TextSpan(
                  text: "(optional)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 14),

          /// RADIO ROW 1
          Row(
            children: [
              _radioItem("With EMI", PaymentType.emi),
              const SizedBox(width: 20),
              _radioItem("Without EMI", PaymentType.withoutEmi),
            ],
          ),

          const SizedBox(height: 12),

          /// RADIO ROW 2
          Row(
            children: [
              _radioItem("ECS", PaymentType.ecs),
              const SizedBox(width: 20),
              _radioItem("E-Mandate", PaymentType.eMandate),
            ],
          ),

          const SizedBox(height: 16),

          /// INPUTS
          /// INPUTS (HIDE ONLY WHEN WITHOUT_EMI)
          // Obx(() {
          //   final hideAll = c.paymentType.value == PaymentType.withoutEmi;
          //
          //   if (hideAll) return const SizedBox.shrink();
          //
          //   return Row(
          //     children: [
          //       _scrollOnFocus(
          //         child: _amountField("Product Price", c.productPrice),
          //       ),
          //
          //
          //       const SizedBox(width: 10),
          //       _scrollOnFocus(
          //         child: _amountField("Down Payment", c.downPayment),
          //       ),
          //
          //       const SizedBox(width: 10),
          //       _scrollOnFocus(
          //         child:  _amountField("Balance Payment", c.balancePayment),
          //       ),
          //
          //
          //     ],
          //   );
          // }),
          Obx(() {
            final hideAll = c.paymentType.value == PaymentType.withoutEmi;
            if (hideAll) return const SizedBox.shrink();

            return Row(
              children: [
                Expanded(
                  child: _scrollOnFocus(
                    child: _amountField("Product Price", c.productPrice),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: _scrollOnFocus(
                    child: _amountField("Down Payment", c.downPayment),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: _scrollOnFocus(
                    child: _amountField("Balance Payment", c.balancePayment),
                  ),
                ),
              ],
            );
          }),

        ],
      ),
    );
  }

  Widget _radioItem(String text, PaymentType type) {
    return GestureDetector(
      onTap: () => c.paymentType.value = type,
      child: Obx(() {
        final selected = c.paymentType.value == type;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.kPrimaryBlue : AppColors.kBorder,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.kPrimaryBlue,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.kPrimaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _amountField(
      String hint,
      TextEditingController controller,
      ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      cursorColor: const Color(0xFFD9B65A),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 10,
          color: Colors.white54,
        ),
        filled: true,
        fillColor: const Color(0xFF151515),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
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
    );
  }
  /// EMI
  Widget _emiSection() => _card(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "EMI Payment (optional)",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF4E19C),
          ),
        ),
        const SizedBox(height: 12),

        _emiTabs(),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _scrollOnFocus(
                child: _miniInput("No. of Months", c.months),
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: _scrollOnFocus(
                child: _miniInput("Interest Rate (%)", c.interest),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _input("Monthly EMI Amount", c.monthlyEmi),
      ],
    ),
  );
  /// DATE
  Widget _loanDate(BuildContext context) => _card(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Loan Start Date",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF4E19C),
          ),
        ),        const SizedBox(height: 12),
        Obx(() => TextField(
          readOnly: true,
          onTap: () => c.pickDate(context),

          decoration: InputDecoration(
            hintText: c.loanStartDate.value.isEmpty
                ? "MM/DD/YYYY"
                : c.loanStartDate.value,
            hintStyle: const TextStyle(
              color: Colors.white70,
            ),
            filled: true,
            fillColor: const Color(0xFF151515),
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Color(0xFFD9B65A),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0x55D9B65A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFD9B65A),
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ))
      ],
    ),
  );

  Widget _emiTabs() => Obx(() => Row(
    children: EmiCycle.values.map((e) {
      final active = c.emiCycle.value == e;
      return Expanded(
        child: GestureDetector(
          onTap: () => c.emiCycle.value = e,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFFD9B65A)
                  : const Color(0xFF151515),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x55D9B65A),
              ),
            ),
            child: Center(
                child: Text(
                  e.name.capitalize!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: active
                        ? Colors.black
                        : Colors.white,
                  ),
                )
            ),
          ),
        ),
      );
    }).toList(),
  ));

  Widget _miniInput(
      String hint,
      TextEditingController c,
      ) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: const Color(0xFFD9B65A),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        filled: true,
        fillColor: const Color(0xFF151515),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0x55D9B65A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD9B65A),
          ),
        ),
      ),
    );
  }

  Widget _inputName(
      String hint,
      TextEditingController c, {
        IconData? suffix,
      }) =>
      _scrollOnFocus(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: c,
            keyboardType: TextInputType.name,
            style: const TextStyle(
              color: Colors.white,
            ),
            cursorColor: const Color(0xFFD9B65A),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              filled: true,
              fillColor: const Color(0xFF151515),
              suffixIcon: suffix != null
                  ? Icon(
                suffix,
                color: const Color(0xFFD9B65A),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0x55D9B65A),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFD9B65A),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _inputNumber(
      String hint,
      TextEditingController c, {
        IconData? suffix,
        int? maxLength,
        bool digitsOnly = false,
      }) =>
      _scrollOnFocus(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
            ),
            cursorColor: const Color(0xFFD9B65A),
            inputFormatters: [
              if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
            ],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              filled: true,
              fillColor: const Color(0xFF151515),
              suffixIcon: suffix != null
                  ? Icon(
                suffix,
                color: const Color(0xFFD9B65A),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0x55D9B65A),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFD9B65A),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _input(
      String hint,
      TextEditingController c, {
        IconData? suffix,
      }) =>
      _scrollOnFocus(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
            ),
            cursorColor: const Color(0xFFD9B65A),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              filled: true,
              fillColor: const Color(0xFF151515),
              suffixIcon: suffix != null
                  ? Icon(
                suffix,
                color: const Color(0xFFD9B65A),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0x55D9B65A),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFD9B65A),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
  // Widget _loanProviderDropdown() => Padding(
  //   padding: const EdgeInsets.only(bottom: 12),
  //   child: Obx(() {
  //     return DropdownButtonFormField<String>(
  //       value: c.selectedLoanProvider.value, // null => hint show
  //       items: c.loanProviders
  //           .map((e) => DropdownMenuItem<String>(
  //         value: e,
  //         child: Text(
  //           e,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ))
  //           .toList(),
  //       onChanged: c.setLoanProvider,
  //       isExpanded: true,
  //       decoration: InputDecoration(
  //         hintText: "Loan Provider",
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //     );
  //   }),
  // );

  Widget _loanProviderDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Obx(() {
      return DropdownButtonFormField<String>(
        value: c.selectedLoanProvider.value,
        items: c.loanProviders
            .map(
              (e) => DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: c.setLoanProvider,
        isExpanded: true,
        dropdownColor: const Color(0xFF151515),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFFD9B65A),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: "Loan Provider",
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          filled: true,
          fillColor: const Color(0xFF151515),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0x55D9B65A),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFD9B65A),
              width: 1.5,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }),
  );
  // Widget _card(Widget child) => Container(
  //   padding: const EdgeInsets.all(16),
  //   decoration: BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(20),
  //     boxShadow: const [
  //       BoxShadow(
  //           color: Color(0x11000000),
  //           blurRadius: 10,
  //           offset: Offset(0, 4))
  //     ],
  //   ),
  //   child: child,
  // );

  Widget _card(Widget child) => Container(
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
          color: const Color(0xFFD9B65A).withOpacity(.10),
          blurRadius: 12,
        ),
      ],
    ),
    child: child,
  );
  Widget _circleBtn(IconData i, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
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
  );
}

