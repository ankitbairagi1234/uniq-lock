import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/distributor_retailers_response.dart';
import 'package:zlock_smart_finance/model/toggle_status_response.dart';



// class DistributorRetailersService {
//   final dio = ApiClient.dio;
//
//   // Future<List<DistributorRetailerItem>> getRetailersFromHierarchy(String id) async {
//   //   try {
//   //     final res = await dio.get(
//   //       "${RetailerAPI.baseUrl}/api/v1/auth/vendor/hierarchy",
//   //       queryParameters: {"id": id},
//   //     );
//   //
//   //     if (res.data == null || res.data["success"] != true) return [];
//   //
//   //     final root = res.data["hierarchy"];
//   //
//   //     final List list = _extractVendors(root);
//   //
//   //     return list
//   //         .map((e) => DistributorRetailerItem.fromJson(e))
//   //         .toList();
//   //   } catch (e) {
//   //     debugPrint("❌ hierarchy error: $e");
//   //     return [];
//   //   }
//   // }
//
//
//   Future<List<DistributorRetailerItem>> getActiveRetailersNew() async {
//     try {
//       final url = "${RetailerAPI.baseUrl}/api/v1/auth/vendor/all?status=active";
//
//       debugPrint("🟢 NEW ACTIVE API HIT: $url");
//
//       final res = await dio.get(url);
//
//       debugPrint("✅ STATUS: ${res.statusCode}");
//       debugPrint("📦 RESPONSE: ${res.data}");
//
//       if (res.data == null || res.data["success"] != true) {
//         debugPrint("❌ API FAILED");
//         return [];
//       }
//
//       final List list = res.data["data"] ?? [];
//
//       debugPrint("📊 ACTIVE API COUNT: ${list.length}");
//
//       return list
//           .map((e) => DistributorRetailerItem.fromJson(e))
//           .toList();
//     } catch (e) {
//       debugPrint("❌ ACTIVE NEW API ERROR: $e");
//       return [];
//     }
//   }
//   Future<List<DistributorRetailerItem>> getRetailersFromHierarchy(String id) async {
//     try {
//       debugPrint("📤 API HIT: /hierarchy");
//       debugPrint("📤 PARAM ID: $id");
//
//       final res = await dio.get(
//         "${RetailerAPI.baseUrl}/api/v1/auth/vendor/hierarchy",
//         queryParameters: {"id": id},
//       );
//
//       debugPrint("✅ STATUS CODE: ${res.statusCode}");
//       debugPrint("✅ RESPONSE DATA: ${res.data}");
//
//       if (res.data == null || res.data["success"] != true) {
//         debugPrint("❌ API SUCCESS FALSE OR NULL");
//         return [];
//       }
//
//       final root = res.data["hierarchy"];
//
//       debugPrint("📦 ROOT DATA: $root");
//
//       final List list = _extractVendors(root);
//
//       debugPrint("📊 TOTAL VENDORS FOUND: ${list.length}");
//
//       return list
//           .map((e) => DistributorRetailerItem.fromJson(e))
//           .toList();
//     } on DioException catch (e) {
//       debugPrint("❌ hierarchy ERROR STATUS: ${e.response?.statusCode}");
//       debugPrint("❌ hierarchy ERROR DATA: ${e.response?.data}");
//       debugPrint("❌ hierarchy ERROR MESSAGE: ${e.message}");
//       return [];
//     } catch (e) {
//       debugPrint("❌ UNKNOWN ERROR: $e");
//       return [];
//     }
//   }
//   /// 🔥 RECURSIVE FUNCTION (VERY IMPORTANT)
//   List<Map<String, dynamic>> _extractVendors(Map<String, dynamic> node) {
//     List<Map<String, dynamic>> vendors = [];
//
//     if (node["type"] == "vendor") {
//       vendors.add(node);
//     }
//
//     if (node["children"] != null) {
//       for (var child in node["children"]) {
//         vendors.addAll(_extractVendors(Map<String, dynamic>.from(child)));
//       }
//     }
//
//     return vendors;
//   }
//
//   // Future<ToggleStatusResponse?> toggleRetailerStatus(String retailerId) async {
//   //   try {
//   //     final url = RetailerAPI.toggleRetailerStatus(retailerId);
//   //
//   //     debugPrint("✅ TOGGLE STATUS HIT: $url");
//   //     final res = await ApiClient.dio.put(url);
//   //
//   //     debugPrint("✅ TOGGLE STATUS CODE: ${res.statusCode}");
//   //     debugPrint("✅ TOGGLE RESPONSE: ${res.data}");
//   //
//   //     if (res.data is Map<String, dynamic>) {
//   //       return ToggleStatusResponse.fromJson(res.data as Map<String, dynamic>);
//   //     }
//   //     return null;
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ TOGGLE API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
//   //     return null;
//   //   } catch (e) {
//   //     debugPrint("❌ TOGGLE UNKNOWN ERROR: $e");
//   //     return null;
//   //   }
//   // }
//
//   Future<ToggleStatusResponse?> toggleRetailerStatus(String retailerId, bool newValue) async {
//     try {
//       final url = RetailerAPI.toggleRetailerStatus();
//
//       debugPrint("✅ TOGGLE STATUS HIT: $url");
//
//       final res = await dio.put(
//         url,
//         data: {
//           "id": retailerId,
//           "reason": newValue ? "Activated" : "Deactivated",
//         },
//       );
//
//       debugPrint("✅ TOGGLE STATUS CODE: ${res.statusCode}");
//       debugPrint("✅ TOGGLE RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return ToggleStatusResponse.fromJson(res.data);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ TOGGLE API ERROR: ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ TOGGLE UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
//
// }


class DistributorRetailersService {
  final dio = ApiClient.dio;


  Future<List<DistributorRetailerItem>> getVendors({
    required String type, // distributor / sub_distributor
    String? status, // active / deactive
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String url =
          "${RetailerAPI.baseUrl}/api/v1/auth/vendor/all?type=$type&page=$page&limit=$limit";

      if (status != null) {
        url += "&status=$status";
      }

      debugPrint("🟢 VENDOR API HIT: $url");

      final res = await dio.get(url);

      if (res.data == null || res.data["success"] != true) {
        debugPrint("❌ VENDOR API FAILED");
        return [];
      }

      final List list = res.data["data"] ?? [];

      debugPrint("📊 $type $status COUNT: ${list.length}");

      return list
          .map((e) => DistributorRetailerItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ VENDOR API ERROR: $e");
      return [];
    }
  }
  /// ✅ TOTAL RETAILERS (NEW API)
  Future<List<DistributorRetailerItem>> getAllRetailers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          "${RetailerAPI.baseUrl}/api/v1/auth/vendor/all?page=$page&limit=$limit";

      debugPrint("🟢 TOTAL API HIT: $url");

      final res = await dio.get(url);

      debugPrint("✅ STATUS: ${res.statusCode}");

      if (res.data == null || res.data["success"] != true) {
        debugPrint("❌ TOTAL API FAILED");
        return [];
      }

      final List list = res.data["data"] ?? [];

      debugPrint("📊 TOTAL PAGE $page COUNT: ${list.length}");

      return list
          .map((e) => DistributorRetailerItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ TOTAL API ERROR: $e");
      return [];
    }
  }
  /// ✅ ACTIVE RETAILERS
  Future<List<DistributorRetailerItem>> getActiveRetailersNew({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          "${RetailerAPI.baseUrl}/api/v1/auth/vendor/all?status=active&page=$page&limit=$limit";

      debugPrint("🟢 ACTIVE API HIT: $url");

      final res = await dio.get(url);

      debugPrint("✅ STATUS: ${res.statusCode}");

      if (res.data == null || res.data["success"] != true) {
        debugPrint("❌ ACTIVE API FAILED");
        return [];
      }

      final List list = res.data["data"] ?? [];

      debugPrint("📊 ACTIVE PAGE $page COUNT: ${list.length}");

      return list
          .map((e) => DistributorRetailerItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ ACTIVE API ERROR: $e");
      return [];
    }
  }


  Future<List<DistributorRetailerItem>> getAllTodayRetailers({
    int page = 1,
    int limit = 20,
    bool todayOnly = false, // 🔥 NEW FLAG
  }) async {
    try {
      final url =
          "${RetailerAPI.baseUrl}/api/v1/auth/vendor/all?page=$page&limit=$limit";

      debugPrint("🟢 TOTAL API HIT: $url");

      final res = await dio.get(url);

      debugPrint("✅ STATUS: ${res.statusCode}");

      if (res.data == null || res.data["success"] != true) {
        debugPrint("❌ TOTAL API FAILED");
        return [];
      }

      final List list = res.data["data"] ?? [];

      debugPrint("📊 TOTAL PAGE $page RAW COUNT: ${list.length}");

      List<DistributorRetailerItem> mapped = list
          .map((e) => DistributorRetailerItem.fromJson(e))
          .toList();

      /// 🔥 TODAY FILTER (ONLY WHEN REQUIRED)
      if (todayOnly) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        mapped = mapped.where((e) {
          if (e.createdAt.isEmpty) {
            debugPrint("❌ EMPTY DATE => ${e.retailerName}");
            return false;
          }

          DateTime? created;

          try {
            created = DateTime.parse(e.createdAt).toLocal();
          } catch (err) {
            debugPrint("❌ DATE PARSE ERROR => ${e.createdAt}");
            return false;
          }

          final createdDate =
          DateTime(created.year, created.month, created.day);

          final isToday = createdDate == today;

          debugPrint(
              "🧪 TODAY CHECK => ${e.retailerName} | $createdDate == $today => $isToday");

          return isToday;
        }).toList();

        debugPrint("📅 TODAY FILTER COUNT: ${mapped.length}");
      }

      return mapped;
    } catch (e) {
      debugPrint("❌ TOTAL API ERROR: $e");
      return [];
    }
  }
  /// ✅ TODAY (NO CHANGE)
  Future<List<DistributorRetailerItem>> getRetailersFromHierarchy(String id) async {
    try {
      debugPrint("📤 API HIT: /hierarchy");

      final res = await dio.get(
        "${RetailerAPI.baseUrl}/api/v1/auth/vendor/hierarchy",
        queryParameters: {"id": id},
      );

      if (res.data == null || res.data["success"] != true) {
        return [];
      }

      final root = res.data["hierarchy"];

      final List list = _extractVendors(root);

      debugPrint("📊 HIERARCHY COUNT: ${list.length}");

      return list
          .map((e) => DistributorRetailerItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ HIERARCHY ERROR: $e");
      return [];
    }
  }

  /// 🔁 RECURSIVE
  List<Map<String, dynamic>> _extractVendors(Map<String, dynamic> node) {
    List<Map<String, dynamic>> vendors = [];

    if (node["type"] == "vendor") {
      vendors.add(node);
    }

    if (node["children"] != null) {
      for (var child in node["children"]) {
        vendors.addAll(_extractVendors(Map<String, dynamic>.from(child)));
      }
    }

    return vendors;
  }

  /// ✅ TOGGLE (no change)
  Future<ToggleStatusResponse?> toggleRetailerStatus(String retailerId, bool newValue) async {
    try {
      final url = RetailerAPI.toggleRetailerStatus();

      final res = await dio.put(
        url,
        data: {
          "id": retailerId,
          "reason": newValue ? "Activated" : "Deactivated",
        },
      );

      if (res.data is Map<String, dynamic>) {
        return ToggleStatusResponse.fromJson(res.data);
      }
      return null;
    } catch (e) {
      debugPrint("❌ TOGGLE ERROR: $e");
      return null;
    }
  }
}