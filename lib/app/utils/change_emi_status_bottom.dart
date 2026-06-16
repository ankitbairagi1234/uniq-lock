import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_controller.dart';

import '../../modules/retailer/details /details_controller.dart';

class ChangeStatusSheet extends StatelessWidget {
  final DetailsController ctrl;
  final int index;

  const ChangeStatusSheet({super.key, required this.ctrl, required this.index});

  String _fmt(DateTime d) => "${d.day.toString().padLeft(2, '0')}/"
      "${d.month.toString().padLeft(2, '0')}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("Change Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Status dropdown
          Obx(() => _sheetDropdown(
            title: "Status",
            value: ctrl.selectedStatus.value,
            items: EmiStatus.values,
            label: (s) => s.label,
            onChanged: (v) => ctrl.selectedStatus.value = v,
          )),

          const SizedBox(height: 12),

          // ✅ Date picker field (tap)
          Obx(() {
            final dt = ctrl.selectedPayDate.value;
            final text = dt == null ? "Choose EMI Pay Date" : _fmt(dt);
            return _sheetTapField(
              text,
              icon: Icons.calendar_month,
              onTap: () => ctrl.pickPayDate(context),
            );
          }),

          const SizedBox(height: 24),

          // SizedBox(
          //   width: double.infinity,
          //   height: 52,
          //   child: ElevatedButton(
          //     // onPressed: () {
          //     //   ctrl.applyChange(index);      // ✅ update row
          //     //   Navigator.pop(context);       // ✅ close sheet
          //     //   Get.snackbar("Updated", "EMI status updated",
          //     //       snackPosition: SnackPosition.BOTTOM);
          //     // },
          //     onPressed: () async {
          //       await ctrl.updateEmiFromSheet(index); // ✅ API + refresh
          //       Navigator.pop(context);              // ✅ close after success (if you want always close)
          //     },
          //
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xff4F6BED),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          //     ),
          //     child: const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white)),
          //   ),
          // ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(() {
              final loading = ctrl.isUpdatingEmi.value;

              return ElevatedButton(
                onPressed: () {

                },
                // onPressed: loading
                //     ? null
                //     : () async {
                //   await ctrl.updateEmiFromSheet(index);
                //   if (!ctrl.isUpdatingEmi.value) {
                //     Navigator.pop(context);
                //   }
                // },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F6BED),
                  disabledBackgroundColor: const Color(0xff4F6BED), // same color (no impact)
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: loading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "Update",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }),
          ),
          SizedBox(height: 30,)

        ],
      ),
    );
  }

  Widget _sheetTapField(String hint, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(child: Text(hint, style: TextStyle(color: Colors.grey.shade600))),
            Icon(icon, size: 18)
          ],
        ),
      ),
    );
  }

  Widget _sheetDropdown<T>({
    required String title,
    required T value,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e,
            child: Text(label(e)),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
class ChangeStatusSheet2 extends StatelessWidget {
  final CustomerDetailV2Controller ctrl;
  final int index;

  const ChangeStatusSheet2({super.key, required this.ctrl, required this.index});

  String _fmt(DateTime d) => "${d.day.toString().padLeft(2, '0')}/"
      "${d.month.toString().padLeft(2, '0')}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("Change Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Status dropdown
          Obx(() => _sheetDropdown(
            title: "Status",
            value: ctrl.selectedStatus.value,
            items: CustomerDetailV2EmiStatus.values,
            label: (s) => s.label,
            onChanged: (v) => ctrl.selectedStatus.value = v,
          )),

          const SizedBox(height: 12),

          // ✅ Date picker field (tap)
          Obx(() {
            final dt = ctrl.selectedPayDate.value;
            final text = dt == null ? "Choose EMI Pay Date" : _fmt(dt);
            return _sheetTapField(
              text,
              icon: Icons.calendar_month,
              onTap: () => ctrl.pickPayDate(context),
            );
          }),

          const SizedBox(height: 24),

          // SizedBox(
          //   width: double.infinity,
          //   height: 52,
          //   child: ElevatedButton(
          //     // onPressed: () {
          //     //   ctrl.applyChange(index);      // ✅ update row
          //     //   Navigator.pop(context);       // ✅ close sheet
          //     //   Get.snackbar("Updated", "EMI status updated",
          //     //       snackPosition: SnackPosition.BOTTOM);
          //     // },
          //     onPressed: () async {
          //       await ctrl.updateEmiFromSheet(index); // ✅ API + refresh
          //       Navigator.pop(context);              // ✅ close after success (if you want always close)
          //     },
          //
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xff4F6BED),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          //     ),
          //     child: const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white)),
          //   ),
          // ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(() {
              final loading = ctrl.isUpdatingEmi.value;

              return ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  await ctrl.updateEmiFromSheet(index);
                  if (!ctrl.isUpdatingEmi.value) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F6BED),
                  disabledBackgroundColor: const Color(0xff4F6BED), // same color (no impact)
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: loading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "Update",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }),
          ),
          SizedBox(height: 30,)

        ],
      ),
    );
  }

  Widget _sheetTapField(String hint, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(child: Text(hint, style: TextStyle(color: Colors.grey.shade600))),
            Icon(icon, size: 18)
          ],
        ),
      ),
    );
  }

  Widget _sheetDropdown<T>({
    required String title,
    required T value,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e,
            child: Text(label(e)),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
