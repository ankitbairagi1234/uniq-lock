import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/edit_retailer_page.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_model.dart';
import 'package:zlock_smart_finance/modules/two_factor_auth/all_auth_setup/change_password.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_details_controller.dart';
import 'package:zlock_smart_finance/model/retailer_details_response.dart';

class ViewRetailerPage extends StatelessWidget {
  final String retailerId;
  final RetailerModel? retailer;
  final String? controllerTag;

  const ViewRetailerPage({super.key, required this.retailerId,
    this.retailer,
    this.controllerTag, // 🔥 NEW

  });

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal(); // ✅ important (UTC → local)
      return DateFormat("dd MMMM yyyy").format(dateTime);
    } catch (e) {
      return isoDate; // fallback
    }
  }
  @override
  Widget build(BuildContext context) {
    // final c = Get.put(RetailerDetailsController(retailerId: retailerId));
    final c = Get.put(
      RetailerDetailsController(
        retailerId: retailerId,
        retailer: retailer, // ✅ PASS HERE ALSO
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFDCE7FF), Color(0xFFF6F8FF)],
              ),
            ),
            child: Row(
              children: [
                _circleBack(),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final d = c.details.value;
                    return Text(
                      d == null ? "Retailer Details" : "Retailer: ${d.retailerName}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          /// BODY
          // Expanded(
          //   child: Obx(() {
          //     if (c.isLoading.value) {
          //       return const Center(
          //         child: CircularProgressIndicator(
          //           color: Color(0xFF3D5CFF),
          //           strokeWidth: 2.5,
          //         ),
          //       );
          //     }
          //
          //     if (c.error.value.isNotEmpty) {
          //       return Center(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text(c.error.value, style: const TextStyle(color: Colors.red)),
          //             const SizedBox(height: 10),
          //             ElevatedButton(
          //               onPressed: c.fetchDetails,
          //               child: const Text("Retry"),
          //             ),
          //           ],
          //         ),
          //       );
          //     }
          //
          //     final d = c.details.value!;
          //     return SingleChildScrollView(
          //       padding: const EdgeInsets.all(16),
          //       child: Column(
          //         children: [
          //           _detailsCard(d),
          //           const SizedBox(height: 16),
          //           _actionSection(),
          //         ],
          //       ),
          //     );
          //   }),
          // ),
          Expanded(
            child: Obx(() {
              // final RetailerController rc = Get.isRegistered<RetailerController>()
              //     ? Get.find<RetailerController>()
              //     : Get.put(RetailerController());

              final RetailerController rc = controllerTag != null
                  ? Get.find<RetailerController>(tag: controllerTag!)
                  : Get.put(RetailerController());
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (c.error.value.isNotEmpty) {
                return Center(child: Text(c.error.value));
              }

              final d = c.details.value!;

              return RefreshIndicator(
                // onRefresh: () async {
                //   print("🔄 MANUAL REFRESH TRIGGERED");
                //   await rc.fetchRetailers(); // 🔥 important
                // },
                onRefresh: () async {
                  print("🔄 MANUAL REFRESH TRIGGERED");

                  await Future.wait([
                    c.fetchDetails(),     // ✅ current page data refresh
                    rc.fetchRetailers(),  // ✅ list bhi refresh (optional but safe)
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // 🔥 required
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _detailsCard(d),
                      const SizedBox(height: 16),
                      _actionSection(d),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---------------- DETAILS CARD ----------------

  Widget _detailsCard(RetailerDetailsData d) {
    final active = d.status == true;

    final RetailerController rc = Get.isRegistered<RetailerController>()
        ? Get.find<RetailerController>()
        : Get.put(RetailerController());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE ROW
          Row(
            children: [
              const Text(
                "Retailer Details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const Spacer(),

              /// status chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFE8F8EE) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  active ? "Active" : "Inactive",
                  style: TextStyle(
                    fontSize: 12,
                    color: active ? const Color(0xFF2FA36B) : const Color(0xFFC62828),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// EDIT BUTTON (same UI)
              // GestureDetector(
              //   onTap: () {
              //     // ✅ edit page me details pass
              //     Get.to(() => EditRetailerPage(), arguments: d);
              //   },
              //   child: Container(
              //     height: 34,
              //     width: 34,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: const Color(0xFF3D5CFF)),
              //     ),
              //     child: const Icon(Icons.edit, size: 18, color: Color(0xFF3D5CFF)),
              //   ),
              // ),

              GestureDetector(
                // onTap: () async {
                //   final updated = await Get.to(() => EditRetailerPage(retailerId: d.retailerId));
                //   if (updated == true) {
                //     // agar aapke view page controller me fetchDetails() hai
                //     Get.find<RetailerDetailsController>().fetchDetails();
                //   }
                // },
                onTap: () async {
                  final updated = await Get.to(
                        () => EditRetailerPage(
                      retailerId: d.retailerId,
                      data: d, // ✅ FULL DATA PASS
                    ),
                  );

                  if (updated == true) {
                    rc.fetchRetailers();
                  }
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF3D5CFF)),
                  ),
                  child: const Icon(Icons.edit, size: 18, color: Color(0xFF3D5CFF)),
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          /// GRID DETAILS (same style)
          _detailRow("Retailer ID", d.customId, "Owner Name", d.ownerName),
          _detailRow("Mobile Number", d.mobile, "Location", d.state),
          _detailRow(
            "Balance",
            "₹${d.balance.toStringAsFixed(2)}",
            "Email",
            d.email,
          ),
          // _detailRow("Created At", d.createdAt, "", ""),
          _detailRow("Created At", formatDate(d.createdAt), "", ""),
        ],
      ),
    );
  }

  Widget _detailRow(String l1, String v1, String l2, String v2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(child: _detailItem(l1, v1)),
          Expanded(child: _detailItem(l2, v2)),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ---------------- ACTION SECTION ----------------

  Widget _actionSection(RetailerDetailsData d) {
    // ✅ SAFE: if controller already exists -> find, else -> put
    final RetailerController rc = Get.isRegistered<RetailerController>()
        ? Get.find<RetailerController>()
        : Get.put(RetailerController());

    final detailsC = Get.find<RetailerDetailsController>(); // ✅ exists on this page

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Action Section",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _pillButton(
                  "+  Credit",
                  const Color(0xFF4A63F3),
                      () => CreditDebitDialog.show(
                    "Credit",
                    rc,
                    detailsC, // ✅ pass details controller for retailerId & refresh
                  ),
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: _pillButton(
              //     "-  Debit",
              //     const Color(0xFF2E3FA8),
              //         () => CreditDebitDialog.show(
              //       "Debit",
              //       rc,
              //       detailsC,
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 14),

          GestureDetector(
            // onTap: () => ChangePasswordDialogForRetailer.show(),
            onTap: () => ChangePasswordDialogForRetailer.show(d.retailerId),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Color(0xFF2E3FA8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ---------------- BACK BUTTON ----------------

  Widget _circleBack() {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F7),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
