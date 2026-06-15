import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/transaction_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/widget/transaction_card.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/transaction_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/widget/transaction_card.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      body: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDDE6FF), Color(0xFFF6F8FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                const Spacer(),
                const Text(
                  "All Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3D5CFF),
                    strokeWidth: 2.5,
                  ),
                );
              }

              if (c.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.error.value, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => c.fetch(reset: true),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              if (c.transactions.isEmpty) {
                return const Center(
                  child: Text("No transactions found"),
                );
              }

              return ListView.builder(
                controller: c.scrollCtrl, // ✅ IMPORTANT
                padding: const EdgeInsets.all(16),
                itemCount: c.transactions.length + (c.isLoadingMore.value ? 1 : 0),
                itemBuilder: (_, i) {
                  print("Transaaction length>>>>>>${c.transactions.length}");
                  if (i == c.transactions.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return TransactionCard(transaction: c.transactions[i]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
