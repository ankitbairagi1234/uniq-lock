import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_listing_v2_response.dart';

// class CustomerListingV2Service {
//   Future<CustomerListingV2Response?> getCustomers({
//     required int page,
//     required int limit,
//     String? search,
//   }) async {
//     try {
//       final query = <String, dynamic>{
//         "page": page,
//         "limit": limit,
//       };
//
//       if (search != null && search.trim().isNotEmpty) {
//         query["search"] = search.trim();
//       }
//
//       debugPrint("✅ CUSTOMER LIST V2 HIT: ${RetailerAPI.customersListingV2}");
//       debugPrint("✅ CUSTOMER LIST V2 QUERY: $query");
//       debugPrint("✅ CUSTOMER LIST V2 HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.get(
//         RetailerAPI.customersListingV2,
//         queryParameters: query,
//       );
//
//       debugPrint("✅ CUSTOMER LIST V2 STATUS: ${res.statusCode}");
//       debugPrint("✅ CUSTOMER LIST V2 RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return CustomerListingV2Response.fromJson(
//           res.data as Map<String, dynamic>,
//         );
//       }
//
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ CUSTOMER LIST V2 API ERROR TYPE: ${e.type}");
//       debugPrint("❌ CUSTOMER LIST V2 API ERROR MSG : ${e.message}");
//       debugPrint("❌ CUSTOMER LIST V2 STATUS       : ${e.response?.statusCode}");
//       debugPrint("❌ CUSTOMER LIST V2 DATA         : ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ CUSTOMER LIST V2 UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

class CustomerListingV2Service {
  // Future<CustomerListingV2Response?> getCustomers({
  //   required int page,
  //   required int limit,
  //   String? search,
  // }) async {
  //   try {
  //     final query = <String, dynamic>{
  //       "page": page,
  //       "limit": limit,
  //     };
  //
  //     if (search != null && search.trim().isNotEmpty) {
  //       query["search"] = search.trim();
  //     }
  //
  //     debugPrint("✅ CUSTOMER LIST V2 HIT: ${RetailerAPI.customersListingV2}");
  //     debugPrint("✅ CUSTOMER LIST V2 QUERY: $query");
  //     debugPrint("✅ CUSTOMER LIST V2 HEADERS: ${ApiClient.dio.options.headers}");
  //
  //     final res = await ApiClient.dio.get(
  //       RetailerAPI.customersListingV2,
  //       queryParameters: query,
  //     );
  //
  //     debugPrint("✅ CUSTOMER LIST V2 STATUS: ${res.statusCode}");
  //     debugPrint("✅ CUSTOMER LIST V2 RESPONSE: ${res.data}");
  //
  //     if (res.data is Map<String, dynamic>) {
  //       return CustomerListingV2Response.fromJson(
  //         Map<String, dynamic>.from(res.data),
  //       );
  //     }
  //
  //     return null;
  //   } on DioException catch (e) {
  //     debugPrint("❌ CUSTOMER LIST V2 API ERROR TYPE: ${e.type}");
  //     debugPrint("❌ CUSTOMER LIST V2 API ERROR MSG : ${e.message}");
  //     debugPrint("❌ CUSTOMER LIST V2 STATUS       : ${e.response?.statusCode}");
  //     debugPrint("❌ CUSTOMER LIST V2 DATA         : ${e.response?.data}");
  //     return null;
  //   } catch (e) {
  //     debugPrint("❌ CUSTOMER LIST V2 UNKNOWN ERROR: $e");
  //     return null;
  //   }
  // }
  Future<CustomerListingV2Response?> getCustomers({
    required int page,
    required int limit,
    String? search,
    // required String type,
    String? type, // ✅ make optional

    required int keyType,
  }) async {
    try {
      final query = <String, dynamic>{
        "page": page,
        "limit": limit,
        // "type": type,
        // "key_type": keyType,
      };

      // ✅ ONLY ADD TYPE IF VALID
      if (type != null && type.trim().isNotEmpty) {
        query["type"] = type;
      }
      // ✅ only add if valid
      if (keyType != 0) {
        query["key_type"] = keyType;
      }

      if (search != null && search.trim().isNotEmpty) {
        query["search"] = search.trim();
      }

      final res = await ApiClient.dio.get(
        RetailerAPI.customersListingV2,
        queryParameters: query,
      );
      debugPrint("🌍 API HIT URL: ${RetailerAPI.customersListingV2}");
      debugPrint("🌍 PARAMS: $query");
      debugPrint("🌍 RESPONSE: ${res.data}");
      debugPrint("✅ CUSTOMER LIST V2 QUERY: $query");

      if (res.data is Map<String, dynamic>) {
        return CustomerListingV2Response.fromJson(
          Map<String, dynamic>.from(res.data),
        );
      }

      return null;
    } catch (e) {
      debugPrint("❌ API ERROR: $e");
      return null;
    }
  }

}