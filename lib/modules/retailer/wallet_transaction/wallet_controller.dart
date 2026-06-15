import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/app/services/key_transactions_service.dart';
import 'package:zlock_smart_finance/model/key_ledger_response.dart';

enum KeyType { android, iphone }

class TransactionModel {
  final bool isCredit;
  final String title;
  final String name;
  final String date;
  final String time;
  final String amount;

  TransactionModel({
    required this.isCredit,
    required this.title,
    required this.name,
    required this.date,
    required this.time,
    required this.amount,
  });
}
//
// class KeyTransactionsController extends GetxController {
//   var selectedKey = KeyType.android.obs;
//
//   var totalKey = 1126.obs;
//   var usedKey = 217.obs;
//   var balanceKey = 217.obs;
//
//   final transactions = <TransactionModel>[
//     TransactionModel(
//       isCredit: true,
//       title: 'Received By',
//       name: 'P.S. International',
//       date: 'Today',
//       time: '02.35 pm',
//       amount: '-\$12',
//     ),
//     TransactionModel(
//       isCredit: false,
//       title: 'Sent To',
//       name: 'P.S. International',
//       date: '23-May-2025',
//       time: '02.35 pm',
//       amount: '+\$12',
//     ),
//     TransactionModel(
//       isCredit: true,
//       title: 'Received By',
//       name: 'K.K Jewelers',
//       date: '13-May-2025',
//       time: '02.35 pm',
//       amount: '-\$12',
//     ),
//     TransactionModel(
//       isCredit: false,
//       title: 'Sent To',
//       name: 'P.S. International',
//       date: '10-May-2025',
//       time: '01.35 pm',
//       amount: '+\$12',
//     ),
//   ];
// }

class WalletTransactionController extends GetxController {
  var selectedKey = KeyType.android.obs;

  var totalKey = 0.obs;
  var usedKey = 0.obs;
  var balanceKey = 0.obs;

  final transactions = <TransactionModel>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  int _page = 1;
  final int _limit = 20;
  int _total = 0;

  final _service = KeyTransactionsService();
  final scrollController = ScrollController();

  var filterType = "all".obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        loadMore(); // ✅ pagination trigger
      }
    });
    fetchFirstPage();
  }

  // ---------------- FIRST PAGE ----------------
  Future<void> fetchFirstPage() async {
    if (isLoading.value) return;

    isLoading.value = true;
    _page = 1;
    transactions.clear();
    hasMore.value = true;

    try {
      final resp = await _service.getKeyLedger(
        page: _page,
        limit: _limit,
      );

      if (resp == null || !resp.success) return;

      // ✅ summary mapping
      totalKey.value = resp.summary.totalAvailable;
      usedKey.value = resp.summary.totalUsed;
      balanceKey.value = resp.summary.netBalance;

      _total = resp.pagination.total;

      final mapped = _mapTransactions(resp.ledger);
      transactions.assignAll(mapped);

      // ✅ correct pagination
      hasMore.value = transactions.length < _total;
    } catch (e) {
      debugPrint("❌ FETCH FIRST PAGE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- LOAD MORE ----------------
  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;

      final resp = await _service.getKeyLedger(
        page: nextPage,
        limit: _limit,
      );

      if (resp == null || !resp.success) return;

      final mapped = _mapTransactions(resp.ledger);

      transactions.addAll(mapped);
      _page = nextPage;
      _total = resp.pagination.total;

      hasMore.value = transactions.length < _total;
    } catch (e) {
      debugPrint("❌ LOAD MORE ERROR: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ---------------- MAPPING ----------------
  // List<TransactionModel> _mapTransactions(List<KeyLedgerItem> items) {
  //   return items.map((e) {
  //     final isCredit = e.type == "credit";
  //
  //     final dt = DateTime.tryParse(e.createdAt)?.toLocal();
  //
  //     return TransactionModel(
  //       isCredit: isCredit,
  //       title: isCredit ? "Received By" : "Sent To",
  //       name: e.counterpartyName,
  //       date: dt != null
  //           ? "${dt.day}-${dt.month}-${dt.year}"
  //           : "-",
  //       time: dt != null
  //           ? "${dt.hour}:${dt.minute}"
  //           : "-",
  //       amount: "${isCredit ? "+" : "-"}${e.totalUnits}",
  //     );
  //   }).toList();
  // }

  // List<TransactionModel> _mapTransactions(List<KeyLedgerItem> items) {
  //   return items
  //   // ✅ FILTER: only "transfer" show
  //       .where((e) {
  //     final source = (e.source ?? "").toLowerCase();
  //     final isValid = source == "transfer";
  //
  //     debugPrint("🔍 SOURCE: $source -> ${isValid ? "✅ KEEP" : "❌ REMOVE"}");
  //
  //     return isValid;
  //   })
  //       .map((e) {
  //     final isCredit = e.type == "credit";
  //
  //     final dt = DateTime.tryParse(e.createdAt)?.toLocal();
  //
  //     return TransactionModel(
  //       isCredit: isCredit,
  //       title: isCredit ? "Received By" : "Sent To",
  //       name: e.counterpartyName ?? "-",
  //       date: dt != null
  //           ? "${dt.day}-${dt.month}-${dt.year}"
  //           : "-",
  //       time: dt != null
  //           ? "${dt.hour}:${dt.minute}"
  //           : "-",
  //       amount: "${isCredit ? "+" : "-"}${e.totalUnits}",
  //     );
  //   })
  //       .toList();
  // }

  // List<TransactionModel> get filteredTransactions {
  //   if (selectedKey.value == KeyType.android) {
  //     // 👉 transfer only
  //     return transactions
  //         .where((t) => t.title != "Used For")
  //         .toList();
  //   } else {
  //     // 👉 used only
  //     return transactions
  //         .where((t) => t.title == "Used For")
  //         .toList();
  //   }
  // }

  // List<TransactionModel> get filteredTransactions {
  //   // 👉 iPhone tab → no data (already handled UI)
  //   if (selectedKey.value == KeyType.iphone) {
  //     return [];
  //   }
  //
  //   // 👉 Used filter
  //   if (filterType.value == "used") {
  //     return transactions
  //         .where((t) => t.title == "Used For")
  //         .toList();
  //   }
  //
  //   // 👉 Default (Total → ALL)
  //   return transactions;
  // }
  List<TransactionModel> get filteredTransactions {
    // 👉 iPhone tab → no data
    if (selectedKey.value == KeyType.iphone) {
      return [];
    }

    // ✅ ONLY CREDIT SHOW
    return transactions
        .where((t) => t.isCredit == true)
        .toList();
  }
  List<TransactionModel> _mapTransactions(List<KeyLedgerItem> items) {
    return items
    // ✅ FILTER: show transfer + usage
        .where((e) {
      final source = (e.source ?? "").toLowerCase();

      final isTransfer = source == "transfer";
      final isUsage = source == "usage" || source == "used";

      final isValid = isTransfer || isUsage;

      debugPrint(
          "🔍 SOURCE: $source -> ${isValid ? "✅ KEEP" : "❌ REMOVE"}");

      return isValid;
    })
        .map((e) {
      final isCredit = e.type == "credit";

      final dt = DateTime.tryParse(e.createdAt)?.toLocal();

      // ✅ Title handling (important)
      String title;
      if ((e.source ?? "").toLowerCase() == "usage") {
        title = "Used For";
      } else {
        title = isCredit ? "Received By" : "Sent To";
      }

      return TransactionModel(
        isCredit: isCredit,
        title: title,
        // name: e.counterpartyName ?? "-",
        name: (e.source ?? "").toLowerCase() == "usage"
            ? e.description
            : e.counterpartyName ?? "-",
        date: dt != null
            ? "${dt.day}-${dt.month}-${dt.year}"
            : "-",
        time: dt != null
            ? "${dt.hour}:${dt.minute}"
            : "-",
        amount: "${isCredit ? "+" : "-"}${e.totalUnits}",
      );
    })
        .toList();
  }
}