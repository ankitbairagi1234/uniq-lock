import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zlock_smart_finance/modules/distributor/dashboard/distributor_dash_controller.dart';
import 'package:zlock_smart_finance/modules/distributor/total_retailer/retailer_model.dart';
import 'package:zlock_smart_finance/app/services/distributor_retailers_service.dart';

import 'package:zlock_smart_finance/model/distributor_retailers_response.dart';

enum RetailerListType { total, active, today }

// class RetailerController extends GetxController {
//   final RetailerListType listType;
//
//   RetailerController({this.listType = RetailerListType.total}); // ✅ no impact
//
//   RxList<RetailerModel> retailerList = <RetailerModel>[].obs;
//   RxList<RetailerModel> filteredList = <RetailerModel>[].obs;
//
//   final searchCtrl = TextEditingController();
//
//   // ✅ keep old variables (no impact)
//   RxBool isSaving = false.obs;
//   final debitCtrl = TextEditingController();
//   final creditCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final confirmCtrl = TextEditingController();
//
//   final isLoading = false.obs;
//   final isLoadingMore = false.obs;
//
//   int _page = 1;
//   final int _limit = 10;
//   int _total = 0;
//
//   bool get hasMore => retailerList.length < _total;
//
//   final _service = DistributorRetailersService();
//
//   bool get _isPaginated => listType == RetailerListType.total;
//
//   @override
//   void onInit() {
//     super.onInit();
//     searchCtrl.addListener(_search);
//     fetchRetailers(reset: true);
//   }
//
//   Future<void> fetchRetailers({required bool reset}) async {
//     // ✅ Active/Today are non paginated => always reset
//     final bool doReset = reset || !_isPaginated;
//
//     if (doReset) {
//       _page = 1;
//       _total = 0;
//       retailerList.clear();
//       filteredList.clear();
//       isLoading.value = true;
//     } else {
//       if (!hasMore) return;
//       isLoadingMore.value = true;
//     }
//
//     try {
//       final DistributorRetailersResponse? resp =
//       await _fetchByType(page: _page, limit: _limit);
//
//       if (resp == null || resp.status != 200) return;
//
//       // meta
//       _total = resp.meta?.total ?? resp.data.length;
//       if (_isPaginated) {
//         _page = resp.meta?.page ?? _page;
//       }
//
//       // ✅ IMPORTANT: Strongly typed mapping (NO dynamic)
//       final List<RetailerModel> newItems = resp.data
//           .map<RetailerModel>((e) => RetailerModel.fromApi(e))
//           .toList();
//
//       if (doReset) {
//         retailerList.assignAll(newItems);
//       } else {
//         retailerList.addAll(newItems);
//       }
//
//       _search();
//     } finally {
//       isLoading.value = false;
//       isLoadingMore.value = false;
//     }
//   }
//
//   // ✅ strongly typed return (NO Future<dynamic>)
//   Future<DistributorRetailersResponse?> _fetchByType({
//     required int page,
//     required int limit,
//   }) {
//     switch (listType) {
//       case RetailerListType.active:
//         return _service.getActiveRetailers();
//       case RetailerListType.today:
//         return _service.getTodayRetailers();
//       case RetailerListType.total:
//       default:
//         return _service.getRetailers(page: page, limit: limit);
//     }
//   }
//
//   Future<void> loadMore() async {
//     if (!_isPaginated) return; // ✅ active/today no pagination
//
//     if (isLoading.value || isLoadingMore.value) return;
//     if (!hasMore) return;
//
//     _page += 1;
//     await fetchRetailers(reset: false);
//   }
//
//   void _search() {
//     final q = searchCtrl.text.trim().toLowerCase();
//
//     if (q.isEmpty) {
//       filteredList.assignAll(retailerList); // ✅ correct
//       return;
//     }
//
//     final List<RetailerModel> results = retailerList.where((r) {
//       return r.name.toLowerCase().contains(q) ||
//           r.id.toLowerCase().contains(q) ||
//           r.mobile.toLowerCase().contains(q) ||
//           r.email.toLowerCase().contains(q) ||
//           r.state.toLowerCase().contains(q);
//     }).toList();
//
//     filteredList.assignAll(results); // ✅ correct
//   }
//
//   Future<void> toggleRetailerStatus(RetailerModel retailer, bool newValue) async {
//     if (retailer.isToggling.value) return;
//
//     final oldValue = retailer.isActive.value;
//
//     retailer.isActive.value = newValue; // optimistic
//     retailer.isToggling.value = true;
//
//     try {
//       final resp = await _service.toggleRetailerStatus(retailer.retailerId);
//
//       if (resp == null || resp.status != 200 || resp.data == null) {
//         retailer.isActive.value = oldValue;
//         Get.snackbar("Error", "Failed to update status",
//             snackPosition: SnackPosition.BOTTOM);
//         return;
//       }
//
//       retailer.isActive.value = resp.data!;
//     } finally {
//       retailer.isToggling.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     searchCtrl.dispose();
//     super.onClose();
//   }
// }

// class RetailerController extends GetxController {
//   final RetailerListType listType;
//
//   RetailerController({this.listType = RetailerListType.total});
//
//   RxList<RetailerModel> retailerList = <RetailerModel>[].obs;
//   RxList<RetailerModel> filteredList = <RetailerModel>[].obs;
//
//   final searchCtrl = TextEditingController();
//   final isLoading = false.obs;
//
//   final _service = DistributorRetailersService();
//
//   // ✅ keep old variables (no impact)
//   RxBool isSaving = false.obs;
//   final debitCtrl = TextEditingController();
//   final creditCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final confirmCtrl = TextEditingController();
//
//   /// ✅ DISTRIBUTOR ID (dynamic later)
//   final distributorId = "69bbbaefba37074637663271";
//
//   @override
//   void onInit() {
//     super.onInit();
//     searchCtrl.addListener(_search);
//     fetchRetailers();
//   }
//
//   Future<void> fetchRetailers() async {
//     isLoading.value = true;
//
//     try {
//       final list = await _service.getRetailersFromHierarchy(distributorId);
//
//       List<DistributorRetailerItem> filtered = list;
//
//       /// ✅ FILTER LOGIC
//       if (listType == RetailerListType.active) {
//         filtered = list.where((e) => e.status == true).toList();
//       }
//
//       if (listType == RetailerListType.today) {
//         final today = DateTime.now();
//
//         filtered = list.where((e) {
//           final created = DateTime.tryParse(e.createdAt ?? "");
//           if (created == null) return false;
//
//           return created.year == today.year &&
//               created.month == today.month &&
//               created.day == today.day;
//         }).toList();
//       }
//
//       retailerList.value = filtered
//           .map((e) => RetailerModel.fromApi(e))
//           .toList();
//
//       filteredList.assignAll(retailerList);
//     } catch (e) {
//       debugPrint("❌ Retailer fetch error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _search() {
//     final q = searchCtrl.text.toLowerCase();
//
//     if (q.isEmpty) {
//       filteredList.assignAll(retailerList);
//       return;
//     }
//
//     filteredList.assignAll(
//       retailerList.where((r) =>
//       r.name.toLowerCase().contains(q) ||
//           r.mobile.contains(q) ||
//           r.email.toLowerCase().contains(q)),
//     );
//   }
//
//   @override
//   void onClose() {
//     searchCtrl.dispose();
//     super.onClose();
//   }
// }
class RetailerController extends GetxController {
  final RetailerListType listType;

  final String? vendorType;
  final String? status;
  final String? tag;


  RetailerController({
    this.listType = RetailerListType.total,
    this.vendorType,
    this.status,
    this.tag,
  });
  // RetailerController({this.listType = RetailerListType.total});

  RxList<RetailerModel> retailerList = <RetailerModel>[].obs;
  RxList<RetailerModel> filteredList = <RetailerModel>[].obs;

  final searchCtrl = TextEditingController();

  int page = 1;
  final int limit = 20;
  bool hasMore = true;

  final isLoading = false.obs;
  final isLoadingMore = false.obs; // ✅ restore

  final _service = DistributorRetailersService();

  /// ✅ keep old variables (no impact)
  RxBool isSaving = false.obs;
  final debitCtrl = TextEditingController();
  final creditCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final DistributorDashController distributorController = Get.find();
  // final distributorId = "69bbbaefba37074637663271";

  String get distributorId => distributorController.userId.value;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    searchCtrl.addListener(_search);
    debugPrint("🆔 DISTRIBUTOR ID:INIT- $distributorId");

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchRetailers(loadMore: true);
      }
    });

    fetchRetailers();
  }

  // Future<void> fetchRetailers() async {
  //   print("call this api fo rget retailer list");
  //   isLoading.value = true;
  //   debugPrint("🆔 DISTRIBUTOR ID: $distributorId");
  //
  //   try {
  //     final list = await _service.getRetailersFromHierarchy(distributorId);
  //
  //     List<DistributorRetailerItem> filtered = list;
  //
  //     /// ✅ ACTIVE FILTER
  //     if (listType == RetailerListType.active) {
  //       filtered = list.where((e) => e.status == true).toList();
  //     }
  //
  //     /// ✅ TODAY FILTER
  //     if (listType == RetailerListType.today) {
  //       final today = DateTime.now();
  //
  //       filtered = list.where((e) {
  //         final created = DateTime.tryParse(e.createdAt ?? "");
  //         if (created == null) return false;
  //
  //         return created.year == today.year &&
  //             created.month == today.month &&
  //             created.day == today.day;
  //       }).toList();
  //     }
  //
  //     retailerList.assignAll(
  //       filtered.map((e) => RetailerModel.fromApi(e)).toList(),
  //     );
  //
  //     _search();
  //   } catch (e) {
  //     debugPrint("❌ Retailer fetch error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> fetchRetailers() async {
  //   print("📡 API CALL: get retailer list");
  //   isLoading.value = true;
  //
  //   debugPrint("🆔 DISTRIBUTOR ID: $distributorId");
  //
  //   try {
  //     final list = await _service.getRetailersFromHierarchy(distributorId);
  //
  //     debugPrint("📊 TOTAL LIST FROM API: ${list.length}");
  //
  //     List<DistributorRetailerItem> filtered = list;
  //
  //     /// ✅ ACTIVE FILTER
  //     if (listType == RetailerListType.active) {
  //       filtered = list.where((e) {
  //         debugPrint("🔎 ACTIVE CHECK => ${e.retailerName} | status: ${e.status}");
  //         return e.status == true;
  //       }).toList();
  //
  //       debugPrint("✅ ACTIVE FILTER COUNT: ${filtered.length}");
  //     }
  //
  //     /// ✅ TODAY FILTER (FIXED 🔥)
  //     if (listType == RetailerListType.today) {
  //       final now = DateTime.now();
  //       final today = DateTime(now.year, now.month, now.day);
  //
  //       debugPrint("📅 TODAY DATE: $today");
  //
  //       filtered = list.where((e) {
  //         if (e.createdAt.isEmpty) {
  //           debugPrint("❌ EMPTY DATE => ${e.retailerName}");
  //           return false;
  //         }
  //
  //         DateTime? created;
  //
  //         try {
  //           created = DateTime.parse(e.createdAt).toLocal(); // 🔥 IMPORTANT FIX
  //         } catch (err) {
  //           debugPrint("❌ DATE PARSE ERROR => ${e.createdAt}");
  //           return false;
  //         }
  //
  //         final createdDate =
  //         DateTime(created.year, created.month, created.day);
  //
  //         debugPrint(
  //             "🧪 CHECK => ${e.retailerName} | API: ${e.createdAt} | PARSED: $createdDate");
  //
  //         return createdDate == today;
  //       }).toList();
  //
  //       debugPrint("✅ TODAY FILTER COUNT: ${filtered.length}");
  //     }
  //
  //     retailerList.assignAll(
  //       filtered.map((e) => RetailerModel.fromApi(e)).toList(),
  //     );
  //
  //     debugPrint("📦 FINAL LIST COUNT: ${retailerList.length}");
  //
  //     _search();
  //   } catch (e) {
  //     debugPrint("❌ Retailer fetch error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> fetchRetailers({bool loadMore = false}) async {
  //   if (loadMore) {
  //     if (!hasMore || isLoadingMore.value) return;
  //     isLoadingMore.value = true;
  //     page++;
  //   } else {
  //     isLoading.value = true;
  //     page = 1;
  //     hasMore = true;
  //   }
  //
  //   try {
  //     List<DistributorRetailerItem> list = [];
  //
  //     if (listType == RetailerListType.total) {
  //       list = await _service.getAllRetailers(page: page, limit: limit);
  //     } else if (listType == RetailerListType.active) {
  //       list = await _service.getActiveRetailersNew(page: page, limit: limit);
  //     } else if (listType == RetailerListType.today) {
  //       // list = await _service.getRetailersFromHierarchy(distributorId);
  //       list = await _service.getAllTodayRetailers(
  //         page: page,
  //         limit: limit,
  //         todayOnly: true, // 🔥 USE SAME API
  //       );
  //     }
  //
  //     debugPrint("📊 PAGE $page COUNT: ${list.length}");
  //
  //     if (list.length < limit) {
  //       hasMore = false;
  //     }
  //
  //     final mapped =
  //     list.map((e) => RetailerModel.fromApi(e)).toList();
  //
  //     if (loadMore) {
  //       retailerList.addAll(mapped);
  //     } else {
  //       retailerList.assignAll(mapped);
  //     }
  //
  //     _search();
  //   } catch (e) {
  //     debugPrint("❌ PAGINATION ERROR: $e");
  //   } finally {
  //     isLoading.value = false;
  //     isLoadingMore.value = false;
  //   }
  // }
  Future<void> fetchRetailers({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
      page++;
    } else {
      isLoading.value = true;
      page = 1;
      hasMore = true;
    }

    try {
      List<DistributorRetailerItem> list = [];

      /// 🔥 DISTRIBUTOR / SUB DISTRIBUTOR (NEW FLOW)
      if (listType == RetailerListType.total && vendorType != null) {
        debugPrint("🟢 VENDOR TYPE: $vendorType | STATUS: $status");

        list = await _service.getVendors(
          type: vendorType!, // distributor / sub_distributor
          status: status,    // active / deactive / null
          page: page,
          limit: limit,
        );
      }

      /// 🔥 NORMAL TOTAL RETAILERS
      else if (listType == RetailerListType.total) {
        debugPrint("🟡 NORMAL TOTAL RETAILERS");

        list = await _service.getAllRetailers(
          page: page,
          limit: limit,
        );
      }

      /// 🔥 ACTIVE RETAILERS
      else if (listType == RetailerListType.active) {
        debugPrint("🟢 ACTIVE RETAILERS");

        list = await _service.getActiveRetailersNew(
          page: page,
          limit: limit,
        );
      }

      /// 🔥 TODAY RETAILERS
      else if (listType == RetailerListType.today) {
        debugPrint("📅 TODAY RETAILERS");

        list = await _service.getAllTodayRetailers(
          page: page,
          limit: limit,
          todayOnly: true,
        );
      }

      debugPrint("📊 PAGE $page COUNT: ${list.length}");

      /// ✅ PAGINATION CHECK
      if (list.length < limit) {
        hasMore = false;
      }

      final mapped =
      list.map((e) => RetailerModel.fromApi(e)).toList();

      /// ✅ ADD / REPLACE DATA
      if (loadMore) {
        retailerList.addAll(mapped);
      } else {
        retailerList.assignAll(mapped);
      }

      debugPrint("📦 FINAL LIST COUNT: ${retailerList.length}");

      _search();
    } catch (e) {
      debugPrint("❌ PAGINATION ERROR: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
  /// ✅ SEARCH (same as before)
  void _search() {
    final q = searchCtrl.text.trim().toLowerCase();

    if (q.isEmpty) {
      filteredList.assignAll(retailerList);
      return;
    }

    filteredList.assignAll(
      retailerList.where((r) =>
      r.name.toLowerCase().contains(q) ||
          r.id.toLowerCase().contains(q) ||
          r.mobile.contains(q) ||
          r.email.toLowerCase().contains(q) ||
          r.state.toLowerCase().contains(q)),
    );
  }

  /// ✅ RESTORED TOGGLE (IMPORTANT 🔥)
  // Future<void> toggleRetailerStatus(RetailerModel retailer, bool newValue) async {
  //   if (retailer.isToggling.value) return;
  //
  //   final oldValue = retailer.isActive.value;
  //
  //   retailer.isActive.value = newValue;
  //   retailer.isToggling.value = true;
  //
  //   try {
  //     final resp = await _service.toggleRetailerStatus(retailer.retailerId);
  //
  //     if (resp == null || resp.status != 200 || resp.data == null) {
  //       retailer.isActive.value = oldValue;
  //
  //       Get.snackbar("Error", "Failed to update status",
  //           snackPosition: SnackPosition.BOTTOM);
  //       return;
  //     }
  //
  //     retailer.isActive.value = resp.data!;
  //   } finally {
  //     retailer.isToggling.value = false;
  //   }
  // }

  Future<void> toggleRetailerStatus(RetailerModel retailer, bool newValue) async {
    if (retailer.isToggling.value) return;

    final oldValue = retailer.isActive.value;

    // ✅ Optimistic UI
    retailer.isActive.value = newValue;
    retailer.isToggling.value = true;

    try {
      final resp = await _service.toggleRetailerStatus(
        retailer.retailerId,
        newValue,
      );

      if (resp == null || resp.success != true) {
        retailer.isActive.value = oldValue;

        Get.snackbar("Error", "Failed to update status",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // ✅ FINAL VALUE FROM API (IMPORTANT)
      retailer.isActive.value = resp.isActive;

      Get.snackbar("Success", resp.message,
          snackPosition: SnackPosition.BOTTOM);

    } finally {
      retailer.isToggling.value = false;
    }
  }
  @override
  void onClose() {
    searchCtrl.dispose();
    scrollController.dispose(); // 🔥 ADD THIS

    super.onClose();
  }
}