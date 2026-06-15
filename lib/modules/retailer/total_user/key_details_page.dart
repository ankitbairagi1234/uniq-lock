import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_page.dart';
import 'package:zlock_smart_finance/modules/retailer/total_user/user_listing_page.dart';
import 'key_details_controller.dart';

class KeyDetailsPage extends StatelessWidget {
  KeyDetailsPage({super.key});

  final KeyDetailsController ctrl = Get.put(KeyDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FF), // 👈 light premium bg

      body: Column(
        children: [
          _header(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ctrl.refreshData(),

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // 🔥 MUST
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (ctrl.isLoading.value) {
                    return _loadingUi(); // ✅ loader widget
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Obx(() => _singleTile(
                        icon: "assets/icons/double_key.svg",
                        title: "Total Key",
                        value: ctrl.totalKey.value.toString(),
                      )),

                      const SizedBox(height: 12),

                      // ✅ New Key dynamic
                      Obx(() => _keySection(
                        title: "Android Key",
                        value: ctrl.newKey.value,
                        stats: ctrl.newKeyStats,
                      )),

                      // ✅ Running Key dynamic
                      Obx(() => _keySection(
                        title: "Running Key",
                        value: ctrl.runningKey.value,
                        stats: ctrl.runningKeyStats,
                      )),

                      // ✅ iPhone Available dynamic
                      Obx(() => _keySection(
                        title: "iPhone Available",
                        value: ctrl.iphoneAvailable.value,
                        stats: ctrl.iphoneStats,
                        apple: true,
                      )),

                      const SizedBox(height: 12),

                      // ✅ bottom tiles dynamic
                      Obx(() => _bottomTiles()),

                      const SizedBox(height:50),
                    ],
                  );
                }),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _loadingUi() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ---------------- Header ----------------
  // Widget _header() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(16, 50, 16, 26),
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Color(0xffDDE7FF),
  //           Color(0xffF5F7FF),
  //         ],
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           onTap: () => Get.back(),
  //           child: Container(
  //             padding: const EdgeInsets.all(10),
  //             decoration: const BoxDecoration(
  //               color: Color(0xffEEF3FF),
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.arrow_back, size: 16),
  //           ),
  //         ),
  //         const Spacer(),
  //         const Text(
  //           "Key Details",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const Spacer(),
  //       ],
  //     ),
  //   );
  // }
  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff6A8DFF),
            Color(0xff9FAEFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
            ),
          ),
          const Spacer(),
          const Text(
            "Key Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
  // ---------------- Top Tile ----------------
  // Widget _singleTile({
  //   required String icon,
  //   required String title,
  //   required String value,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: _box(),
  //     child: Row(
  //       children: [
  //         _icon(icon, const Color(0xffEEF3FF)),
  //         const SizedBox(width: 12),
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xff2C4ACF),
  //           ),
  //         ),
  //         const Spacer(),
  //         Text(
  //           value,
  //           style: const TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _singleTile({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        children: [
          _icon(icon, const Color(0xffE3EAFF)),
          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff3D5AFE),
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffEEF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget _statCard(String title, int value, Color bg, String icon,final VoidCallback? onTap) {
  //   return Expanded(
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 6),
  //         padding: const EdgeInsets.all(14),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: const Color(0xffD9E0F5)),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: bg,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: SvgPicture.asset(icon, height: 18),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 13,
  //                 color: Colors.black54,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Row(
  //               children: [
  //                 Text(
  //                   value.toString(),
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 const Icon(Icons.arrow_outward, size: 14),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _statCard(
  //     String title,
  //     int value,
  //     Color bg,
  //     String icon,
  //     VoidCallback? onTap,
  //     ) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(14),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(color: const Color(0xffD9E0F5)),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ equal spacing
  //         children: [
  //
  //           /// 🔹 TOP ROW (ICON + TITLE)
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(6),
  //                 decoration: BoxDecoration(
  //                   color: bg,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: SvgPicture.asset(
  //                   icon,
  //                   height: 30,
  //                 ),
  //               ),
  //               const SizedBox(width: 6), // ✅ FIX spacing (was height ❌)
  //
  //               Expanded( // ✅ prevents overflow
  //                 child: Text(
  //                   title,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(
  //                     fontSize: 14.5,
  //                     color: Colors.black54,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //
  //           /// 🔹 BOTTOM ROW (VALUE + ARROW)
  //           Row(
  //             children: [
  //               Text(
  //                 value.toString(),
  //                 style: const TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               const Spacer(),
  //               const Icon(Icons.arrow_outward, size: 12),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget _statCard(
  //     String title,
  //     int value,
  //     Color bg,
  //     String icon,
  //     VoidCallback? onTap,
  //     ) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(18),
  //
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 180),
  //       curve: Curves.easeOut,
  //
  //       padding: const EdgeInsets.all(12),
  //
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(18),
  //
  //         // 🔥 PREMIUM GRADIENT
  //         gradient: LinearGradient(
  //           colors: [
  //             Colors.white,
  //             bg.withOpacity(0.18),
  //           ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //
  //         // 🔥 BORDER SOFT
  //         border: Border.all(
  //           color: bg.withOpacity(0.25),
  //         ),
  //
  //         // 🔥 ELEVATION (MAIN MAGIC)
  //         boxShadow: [
  //           BoxShadow(
  //             color: bg.withOpacity(0.25),
  //             blurRadius: 16,
  //             offset: const Offset(0, 8),
  //           ),
  //         ],
  //       ),
  //
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //
  //         children: [
  //
  //           /// 🔹 TOP ROW
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //
  //                 decoration: BoxDecoration(
  //                   color: bg.withOpacity(0.25),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //
  //                 child: SvgPicture.asset(
  //                   icon,
  //                   height: 18, // 🔥 perfect size
  //                 ),
  //               ),
  //
  //               const SizedBox(width: 10),
  //
  //               Expanded(
  //                 child: Text(
  //                   title,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: const TextStyle(
  //                     fontSize: 13.5,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xff555555),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //
  //           /// 🔹 VALUE + ARROW
  //           Padding(
  //
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Row(
  //               children: [
  //                 Text(
  //                   value.toString(),
  //                   style: const TextStyle(
  //                     fontSize: 15, // 🔥 BIG NUMBER
  //                     fontWeight: FontWeight.w800,
  //                     color: Color(0xff1A237E),
  //                   ),
  //                 ),
  //                 const Spacer(),
  //
  //                 Container(
  //                   padding: const EdgeInsets.all(4),
  //                   decoration: BoxDecoration(
  //                     color: Colors.black.withOpacity(0.05),
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.arrow_outward,
  //                     size: 14,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _statCard(
      String title,
      int value,
      Color bg,
      String icon,
      VoidCallback? onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(18),
        //
        //   // gradient: LinearGradient(
        //   //   colors: [
        //   //     Colors.white,
        //   //     bg.withOpacity(0.15),
        //   //   ],
        //   // ),
        //
        //   // boxShadow: [
        //   //   BoxShadow(
        //   //     color: bg.withOpacity(0.25),
        //   //     blurRadius: 12,
        //   //     offset: const Offset(0, 6),
        //   //   ),
        //   // ],
        // ),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        // padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffD9E0F5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bg.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(icon, height: 16),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Row(
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1A237E),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_outward, size: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _bottomTiles() {
    return Row(
      children: [
        Expanded(
          child: _bottomTile(
            "Loan Zone Key",
            ctrl.loanZoneKey.value.toString(),
            "assets/icons/bank.svg",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bottomTile(
            "E-Mandate",
            ctrl.eMandate.value.toString(),
            "assets/icons/e_mand.svg",
          ),
        ),
      ],
    );
  }

  // Widget _keySection({
  //   required String title,
  //   required int value,
  //   required Map stats,
  //   bool apple = false,
  // }) {
  //   final active = (stats["active"] ?? 0) as int;
  //   final lock = (stats["lock"] ?? 0) as int;
  //   final remove = (stats["remove"] ?? 0) as int;
  //
  //   return Container(
  //     margin: const EdgeInsets.only(top: 12),
  //     padding: const EdgeInsets.all(14),
  //     decoration: _box(),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             _icon(
  //               apple ? "assets/icons/apple.svg" : "assets/icons/person_key.svg",
  //               const Color(0xffEEF3FF),
  //             ),
  //             const SizedBox(width: 10),
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xff2C4ACF),
  //               ),
  //             ),
  //             const Spacer(),
  //             Text(
  //               value.toString(),
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 14),
  //
  //         // Row(
  //         //   children: [
  //         //     _statCard(
  //         //       "Active",
  //         //       active,
  //         //       const Color(0xffE6F6EC),
  //         //       "assets/icons/active_user_key.svg",
  //         //           () => Get.to(
  //         //         UsersListingPage(),
  //         //         arguments: _listArgs(sectionTitle: title, statusType: "ACTIVE"),
  //         //       ),
  //         //     ),
  //         //     _statCard(
  //         //       "Lock",
  //         //       lock,
  //         //       const Color(0xffFFF4E5),
  //         //       "assets/icons/lock_user.svg",
  //         //           () => Get.to(
  //         //         UsersListingPage(),
  //         //         arguments: _listArgs(sectionTitle: title, statusType: "LOCKED"),
  //         //       ),
  //         //     ),
  //         //     _statCard(
  //         //       "Remove",
  //         //       remove,
  //         //       const Color(0xffFDECEC),
  //         //       "assets/icons/remove_user.svg",
  //         //           () => Get.to(
  //         //         UsersListingPage(),
  //         //         arguments: _listArgs(sectionTitle: title, statusType: "REMOVED"),
  //         //       ),
  //         //     ),
  //         //   ],
  //         // )
  //         Row(
  //           children: [
  //             _statCard(
  //               "Active",
  //               active,
  //               const Color(0xffE6F6EC),
  //               "assets/icons/active_user_key.svg",
  //                   () => Get.to(
  //                 // UsersListingPage(),
  //                 CustomerListingV2Page(),
  //                 arguments: _listArgs(sectionTitle: title, statusType: "ACTIVE"),
  //               ),
  //             ),
  //             _statCard(
  //               "Lock",
  //               lock,
  //               const Color(0xffFFF4E5),
  //               "assets/icons/lock_user.svg",
  //                   () => Get.to(
  //                 // UsersListingPage(),
  //                 CustomerListingV2Page(),
  //                 arguments: _listArgs(sectionTitle: title, statusType: "LOCK"),
  //               ),
  //             ),
  //             _statCard(
  //               "Remove",
  //               remove,
  //               const Color(0xffFDECEC),
  //               "assets/icons/remove_user.svg",
  //                   () => Get.to(
  //                 // UsersListingPage(),
  //                 CustomerListingV2Page(),
  //                 arguments: _listArgs(sectionTitle: title, statusType: "REMOVE"),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }


  Widget _keySection({
    required String title,
    required int value,
    required Map stats,
    bool apple = false,
  }) {
    final active = (stats["active"] ?? 0) as int;
    final lock = (stats["lock"] ?? 0) as int;
    final remove = (stats["remove"] ?? 0) as int;
    final pending = (stats["pending"] ?? 0) as int; // ✅ NEW

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: _box(),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     _icon(
          //       apple ? "assets/icons/apple.svg" : "assets/icons/person_key.svg",
          //       const Color(0xffEEF3FF),
          //     ),
          //     const SizedBox(width: 10),
          //     Text(
          //       title,
          //       style: const TextStyle(
          //         fontSize: 15,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xff2C4ACF),
          //       ),
          //     ),
          //     const Spacer(),
          //     Text(
          //       value.toString(),
          //       style: const TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            children: [
              _icon(
                apple ? "assets/icons/apple.svg" : "assets/icons/person_key.svg",
                apple ? const Color(0xffFFE5E8) : const Color(0xffE3EAFF),
              ),
              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1A237E),
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6A8DFF), Color(0xff9FAEFF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// ✅ 4 cards responsive grid
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: [

              _statCard(
                "Active",
                active,
                const Color(0xffE6F6EC),
                "assets/icons/active_user_key.svg",
                    () => Get.to(
                  CustomerListingV2Page(),
                  arguments: _listArgs(sectionTitle: title, statusType: "ACTIVE"),
                ),
              ),

              _statCard(
                "Lock",
                lock,
                const Color(0xffFFF4E5),
                "assets/icons/lock_user.svg",
                    () => Get.to(
                  CustomerListingV2Page(),
                  arguments: _listArgs(sectionTitle: title, statusType: "LOCK"),
                ),
              ),

              _statCard(
                "Remove",
                remove,
                const Color(0xffFDECEC),
                "assets/icons/remove_user.svg",
                    () => Get.to(
                  CustomerListingV2Page(),
                  arguments: _listArgs(sectionTitle: title, statusType: "REMOVE"),
                ),
              ),

              _statCard(
                "Pending",
                pending,
                const Color(0xffEEF3FF),
                "assets/icons/upcoming.svg", // ✅ add icon
                    () => Get.to(
                  CustomerListingV2Page(),
                  arguments: _listArgs(sectionTitle: title, statusType: "PENDING"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bottomTile(String title, String value, String icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: _box(),
      child: Row(
        children: [
          _icon(icon, const Color(0xffEEF3FF)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2C4ACF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ---------------- Helpers ----------------
  // BoxDecoration _box() => BoxDecoration(
  //   color: Colors.white,
  //   borderRadius: BorderRadius.circular(18),
  //   boxShadow: [
  //     BoxShadow(
  //       color: Colors.black.withOpacity(0.04),
  //       blurRadius: 10,
  //       offset: const Offset(0, 4),
  //     ),
  //   ],
  // );

  BoxDecoration _box() => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [
        Colors.white,
        Color(0xffF3F6FF),
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 15,
        offset: const Offset(0, 6),
      ),
    ],
  );
  // Widget _icon(String icon, Color bg) {
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     decoration: BoxDecoration(
  //       color: bg,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Center(
  //       child: SvgPicture.asset(icon, height: 20),
  //     ),
  //   );
  // }

  Widget _icon(String icon, Color bg) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bg,
            bg.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          height: 22,
          colorFilter: const ColorFilter.mode(
            Color(0xff3D5AFE), // 👈 blue tint
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
  // Map<String, dynamic> _listArgs({
  //   required String sectionTitle, // "New Key" / "Running Key" / "iPhone Available"
  //   required String statusType,   // ACTIVE / LOCKED / REMOVED
  // }) {
  //   // deviceType mapping strictly as per API enum: ANDROID/IPHONE/RUNNING
  //   String deviceType;
  //   if (sectionTitle == "New Key") {
  //     deviceType = "ANDROID";
  //   } else if (sectionTitle == "Running Key") {
  //     deviceType = "RUNNING";
  //   } else if (sectionTitle == "iPhone Available") {
  //     deviceType = "IPHONE";
  //   } else {
  //     deviceType = "ANDROID"; // safe fallback
  //   }
  //
  //   return {
  //     "type": statusType,      // ✅ NEW,RUNNING,ACTIVE,LOCKED,REMOVED,IPHONE (we use ACTIVE/LOCKED/REMOVED here)
  //     "deviceType": deviceType, // ✅ ANDROID/IPHONE/RUNNING
  //     "today": 0,
  //   };
  // }

  Map<String, dynamic> _listArgs({
    required String sectionTitle,
    required String statusType,
  }) {
    int keyType = 0;

    if (sectionTitle == "Android Key") {
      keyType = 1; // new key
    } else if (sectionTitle == "Running Key") {
      keyType = 2;
    } else if (sectionTitle == "iPhone Available") {
      keyType = 3; // agar backend me hai
    }

    return {
      "type": statusType.toLowerCase(), // active / lock / remove
      "key_type": keyType,
    };
  }
}
