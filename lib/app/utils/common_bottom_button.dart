import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/retailer/Add_new_key/new_key_controller.dart';

// class CommonBottomButton extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//   final Color buttonColor;
//   final Color backgroundColor;
//
//   final bool showAgreement;
//   final RxBool? agreeRx;
//
//   const CommonBottomButton({
//     super.key,
//     required this.title,
//     required this.onTap,
//     this.buttonColor = const Color(0xFF3153D8),
//     this.backgroundColor = const Color(0xFFDFE1E7),
//
//     this.showAgreement = false,
//     this.agreeRx,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(32),
//                 topRight: Radius.circular(32),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(13, 14, 13, 20),
//
//               // padding:
//               // const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
//               child: Column(
//                 children: [
//                   if (showAgreement && agreeRx != null)
//                     Obx(() => GestureDetector(
//                       onTap: () => agreeRx!.toggle(),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 12),
//                         margin: const EdgeInsets.only(bottom: 14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffF6F8FF),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: const Color(0xffCBD3EE)),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: agreeRx!.value,
//                               onChanged: (v) =>
//                               agreeRx!.value = v ?? false,
//                               activeColor: const Color(0xff4F6BED),
//                               materialTapTargetSize:
//                               MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                             ),
//                             const SizedBox(width: 6),
//                             const Expanded(
//                               child: Text(
//                                 "I agree to the Terms & Conditions and confirm the customer details are correct.",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xff1E2A5A),
//                                   height: 1.3,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     decoration: BoxDecoration(
//                       color: buttonColor,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class CommonBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color backgroundColor;

  final bool showAgreement;
  final RxBool? agreeRx;

  // ✅ NEW: only submit button disable
  final bool isButtonDisabled;
  final String? controllerTag;

  const CommonBottomButton({
    super.key,
    required this.title,
    required this.onTap,
    // this.buttonColor = const Color(0xFF3153D8),
    // this.backgroundColor = const Color(0xFFDFE1E7),
    this.buttonColor = const Color(0xFFD9B65A),
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.showAgreement = false,
    this.agreeRx,
    this.isButtonDisabled = false,
    this.controllerTag, // ✅

  });

  @override
  Widget build(BuildContext context) {
    // final c = Get.find<NewKeyController>();
    final c = controllerTag == null
        ? Get.find<NewKeyController>()
        : Get.find<NewKeyController>(tag: controllerTag);
    final disabled = isButtonDisabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   color: backgroundColor,
          //   borderRadius: const BorderRadius.only(
          //     topLeft: Radius.circular(32),
          //     topRight: Radius.circular(32),
          //   ),
          // ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF0A0A0A),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border(
              top: BorderSide(
                color: Color(0x55D9B65A),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(13, 14, 13, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Agreement always clickable (no disable)
                if (showAgreement && agreeRx != null)
                  Obx(() => InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => agreeRx!.toggle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0x55D9B65A),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreeRx!.value,
                            onChanged: (v) => agreeRx!.value = v ?? false,
                            activeColor: const Color(0xFFD9B65A),
                            checkColor: Colors.black,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              "I agree to the Terms & Conditions and confirm the customer details are correct.",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                if (showAgreement && agreeRx != null)
                  if (showAgreement && agreeRx != null)
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10),
                    //   child: DownloadAgreementTile(
                    //     agreementUrl: "https://YOUR_DOMAIN.com/files/EMI_Agreement.docx",
                    //     // ✅ yaha aap apna real URL do
                    //   ),
                    // ),
                    Obx(() {
                      final downloading = c.isGeneratingAgreement.value;
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: downloading ? null : c.generateAndDownloadAgreementPdf,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(18),
                          //   gradient: const LinearGradient(
                          //     colors: [Color(0xff4F6BED), Color(0xff6F7CFF)],
                          //   ),
                          // ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFF4E19C),
                                Color(0xFFD9B65A),
                                Color(0xFFB8860B),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66D9B65A),
                                blurRadius: 15,
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  downloading
                                      ? Icons.downloading_rounded
                                      : Icons.description_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Download Agreement",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),

                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      downloading
                                          ? "Generating PDF..."
                                          // : "Auto-filled from entered details • Tap to save & open",
                                          : "Tap to save & open",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12.5,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  downloading ? "..." : "GET",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                SizedBox(height: 10,),


                // ✅ Only submit button disable
                AbsorbPointer(
                  absorbing: disabled,
                  child: Opacity(
                    opacity: disabled ? 0.55 : 1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: disabled ? const Color(0xFF9AA7D8) : buttonColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommonBottomButtonUpdate extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color backgroundColor;

  final bool showAgreement;
  final RxBool? agreeRx;

  const CommonBottomButtonUpdate({
    super.key,
    required this.title,
    required this.onTap,
    // this.buttonColor = const Color(0xFF3153D8),
    // this.backgroundColor = const Color(0xFFDFE1E7),

    this.buttonColor = const Color(0xFFD9B65A),
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.showAgreement = false,
    this.agreeRx,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 14, 13, 20),

              // padding:
              // const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
              child: Column(
                children: [
                  if (showAgreement && agreeRx != null)
                    Obx(() => GestureDetector(
                      onTap: () => agreeRx!.toggle(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xffCBD3EE)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeRx!.value,
                              onChanged: (v) =>
                              agreeRx!.value = v ?? false,
                              activeColor: const Color(0xff4F6BED),
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                "I agree to the Terms & Conditions and confirm the customer details are correct.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff1E2A5A),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommonLogoutBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color backgroundColor;

  final bool showAgreement;
  final RxBool? agreeRx;

  const CommonLogoutBottomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.buttonColor = const Color(0xFFD9B65A),
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.showAgreement = false,
    this.agreeRx,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   color: backgroundColor,
            //   borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(32),
            //     topRight: Radius.circular(32),
            //   ),
            // ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B1B1B),
                  Color(0xFF0A0A0A),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 14, 13, 20),

              // padding:
              // const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
              child: Column(
                children: [
                  if (showAgreement && agreeRx != null)
                    Obx(() => GestureDetector(
                      onTap: () => agreeRx!.toggle(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F8FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xffCBD3EE)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: agreeRx!.value,
                              onChanged: (v) =>
                              agreeRx!.value = v ?? false,
                              activeColor: const Color(0xff4F6BED),
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                "I agree to the Terms & Conditions and confirm the customer details are correct.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff1E2A5A),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 18),
                  //   decoration: BoxDecoration(
                  //     color: buttonColor,
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     title,
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD9B65A).withOpacity(.35),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}