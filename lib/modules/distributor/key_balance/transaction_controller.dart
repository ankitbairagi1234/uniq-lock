
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/services/key_transactions_service.dart';
import 'package:zlock_smart_finance/model/key_ledger_response.dart';
import 'package:zlock_smart_finance/modules/distributor/key_balance/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:zlock_smart_finance/app/services/distributor_key_transactions_service.dart';

// class TransactionController extends GetxController {
//   final transactions = <TransactionModel>[].obs;
//
//   final isLoading = false.obs;
//   final isLoadingMore = false.obs;
//   final error = "".obs;
//
//   final ScrollController scrollCtrl = ScrollController();
//   final _service = DistributorKeyTransactionsService();
//
//   int _page = 1;
//   final int _limit = 10;
//   int _total = 0;
//
//   final String keyType = "ANDROID";
//
//   bool get hasMore => transactions.length < _total;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetch(reset: true);
//
//     scrollCtrl.addListener(() {
//       if (!scrollCtrl.hasClients) return;
//       final pos = scrollCtrl.position;
//       if (pos.pixels >= (pos.maxScrollExtent - 120)) {
//         loadMore();
//       }
//     });
//   }
//
//   Future<void> fetch({required bool reset}) async {
//     if (reset) {
//       _page = 1;
//       _total = 0;
//       transactions.clear();
//       error.value = "";
//       isLoading.value = true;
//     } else {
//       if (!hasMore) return;
//       isLoadingMore.value = true;
//     }
//
//     try {
//       final resp = await _service.getKeyTransactions(
//         keyType: keyType,
//         page: _page,
//         limit: _limit,
//       );
//
//       if (resp == null) {
//         error.value = "No response from server";
//         return;
//       }
//
//       if (resp.status != 200) {
//         error.value = "Something went wrong (status: ${resp.status})";
//         return;
//       }
//
//       _total = resp.meta?.total ?? 0;
//
//       // ✅ map raw list -> TransactionModel
//       final mapped = resp.data
//           .whereType<Map>() // safety
//           .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
//           .toList();
//
//       if (reset) {
//         transactions.assignAll(mapped);
//       } else {
//         transactions.addAll(mapped);
//       }
//     } catch (e) {
//       error.value = "Failed to load transactions";
//     } finally {
//       isLoading.value = false;
//       isLoadingMore.value = false;
//     }
//   }
//
//   Future<void> loadMore() async {
//     if (isLoading.value || isLoadingMore.value) return;
//     if (!hasMore) return;
//     _page += 1;
//     await fetch(reset: false);
//   }
//
//   @override
//   void onClose() {
//     scrollCtrl.dispose();
//     super.onClose();
//   }
// }

class TransactionController extends GetxController {
  final transactions = <TransactionModel>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = "".obs;

  final ScrollController scrollCtrl = ScrollController();

  // ✅ SAME SERVICE (IMPORTANT CHANGE)
  final _service = KeyTransactionsService();

  int _page = 1;
  final int _limit = 100;
  int _total = 0;

  // ✅ FILTER TYPE (credit / debit)
  String filterType = "";

  bool get hasMore => transactions.length < _total;

  @override
  void onInit() {
    super.onInit();

    // ✅ GET ARGUMENT (credit / debit)
    final args = Get.arguments;
    if (args is Map && args["type"] != null) {
      filterType = args["type"].toString().toLowerCase();
    }

    debugPrint("🟢 FILTER TYPE: $filterType");

    fetch(reset: true);

    scrollCtrl.addListener(() {
      if (!scrollCtrl.hasClients) return;
      final pos = scrollCtrl.position;
      if (pos.pixels >= (pos.maxScrollExtent - 120)) {
        loadMore();
      }
    });
  }

  // ---------------- FETCH ----------------
  Future<void> fetch({required bool reset}) async {
    if (reset) {
      _page = 1;
      _total = 0;
      transactions.clear();
      error.value = "";
      isLoading.value = true;
    } else {
      if (!hasMore) return;
      isLoadingMore.value = true;
    }

    try {
      final resp = await _service.getKeyLedger(
        page: _page,
        limit: _limit,
      );

      if (resp == null || !resp.success) {
        error.value = "Failed to load data";
        return;
      }

      _total = resp.pagination.total;

      final mapped = _mapTransactions(resp.ledger);

      if (reset) {
        transactions.assignAll(mapped);
      } else {
        transactions.addAll(mapped);
      }

    } catch (e) {
      error.value = "Failed to load transactions";
      debugPrint("❌ ERROR: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // ---------------- LOAD MORE ----------------
  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value) return;
    if (!hasMore) return;

    _page += 1;
    await fetch(reset: false);
  }

  // ---------------- MAPPING (SAME LOGIC 🔥) ----------------
  // List<TransactionModel> _mapTransactions(List<KeyLedgerItem> items) {
  //   return items
  //       .where((e) {
  //     final source = (e.source ?? "").toLowerCase();
  //     // return source == "transfer";
  //     return source == "transfer" || source == "direct";
  //   })
  //       .where((e) {
  //     if (filterType.isEmpty) return true;
  //     final type = (e.type ?? "").toLowerCase();
  //     return type == filterType;
  //   })
  //       .map((e) {
  //     final isCredit = (e.type ?? "").toLowerCase() == "credit";
  //
  //     final dt = DateTime.tryParse(e.createdAt ?? "")?.toLocal();
  //
  //     String dateStr = "-";
  //     String timeStr = "-";
  //
  //     if (dt != null) {
  //       final now = DateTime.now();
  //       final today = DateTime(now.year, now.month, now.day);
  //       final d0 = DateTime(dt.year, dt.month, dt.day);
  //
  //       final diff = today.difference(d0).inDays;
  //
  //       if (diff == 0) {
  //         dateStr = "Today";
  //       } else if (diff == 1) {
  //         dateStr = "Yesterday";
  //       } else {
  //         dateStr = "${dt.day}-${dt.month}-${dt.year}";
  //       }
  //
  //       // time → 02.35 pm format
  //       final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  //       final minute = dt.minute.toString().padLeft(2, '0');
  //       final ampm = dt.hour >= 12 ? "pm" : "am";
  //
  //       timeStr = "$hour.$minute $ampm";
  //     }
  //
  //     final amountStr = "${isCredit ? "+" : "-"}₹${e.totalUnits}";
  //
  //     final name = e.counterpartyName.isNotEmpty == true
  //         ? e.counterpartyName
  //         : "Transaction";
  //
  //     final byText = isCredit
  //         ? "Sent By: $name"
  //         : "Received By: $name";
  //
  //     return TransactionModel(
  //       isCredit: isCredit,
  //       partyName: name,
  //       date: dateStr,
  //       time: timeStr,
  //       amount: amountStr,
  //       byText: byText,
  //     );
  //   })
  //       .toList();
  // }

  List<TransactionModel> _mapTransactions(List<KeyLedgerItem> items) {
    debugPrint("📦 TOTAL API ITEMS: ${items.length}");

    final filtered = items.where((e) {
      final source = (e.source ?? "").toLowerCase();
      final type = (e.type ?? "").toLowerCase();

      debugPrint("👉 ITEM => type: $type | source: $source");

      // ✅ FIX: include direct also
      final isValidSource = source == "transfer" || source == "direct";

      final isValidType =
      filterType.isEmpty ? true : type == filterType;

      return isValidSource && isValidType;
    }).toList();

    debugPrint("✅ FILTERED COUNT: ${filtered.length}");

    return filtered.map((e) {
      final isCredit = (e.type ?? "").toLowerCase() == "credit";

      debugPrint("💰 FINAL => ${e.type} | ${e.source} | units: ${e.totalUnits}");

      final dt = DateTime.tryParse(e.createdAt ?? "")?.toLocal();

      String dateStr = "-";
      String timeStr = "-";

      if (dt != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final d0 = DateTime(dt.year, dt.month, dt.day);

        final diff = today.difference(d0).inDays;

        if (diff == 0) {
          dateStr = "Today";
        } else if (diff == 1) {
          dateStr = "Yesterday";
        } else {
          dateStr = "${dt.day}-${dt.month}-${dt.year}";
        }

        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final minute = dt.minute.toString().padLeft(2, '0');
        final ampm = dt.hour >= 12 ? "pm" : "am";

        timeStr = "$hour.$minute $ampm";
      }

      final amountStr = "${isCredit ? "+" : "-"}₹${e.totalUnits}";

      final name = e.counterpartyName.isNotEmpty == true
          ? e.counterpartyName
          : "Transaction";

      final byText = isCredit
          ? "Sent By: $name"
          : "Received By: $name";

      return TransactionModel(
        isCredit: isCredit,
        partyName: name,
        date: dateStr,
        time: timeStr,
        amount: amountStr,
        byText: byText,
      );
    }).toList();
  }
  @override
  void onClose() {
    scrollCtrl.dispose();
    super.onClose();
  }
}