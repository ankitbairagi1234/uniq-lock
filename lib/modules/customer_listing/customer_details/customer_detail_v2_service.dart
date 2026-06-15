import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/modules/customer_listing/customer_details/customer_detail_v2_response.dart';


// class CustomerDetailV2Service {
//   Future<CustomerDetailV2Item?>   getCustomerById({
//     required String customerId,
//     int page = 1,
//     int limit = 100,
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
//       debugPrint("✅ CUSTOMER DETAIL V2 HIT: ${RetailerAPI.customersListingV2}");
//       debugPrint("✅ CUSTOMER DETAIL V2 QUERY: $query");
//       debugPrint("✅ CUSTOMER DETAIL V2 ID: $customerId");
//
//       final res = await ApiClient.dio.get(
//         RetailerAPI.customersListingV2,
//         queryParameters: query,
//       );
//
//       debugPrint("✅ CUSTOMER DETAIL V2 STATUS: ${res.statusCode}");
//       debugPrint("✅ CUSTOMER DETAIL V2 RESPONSE: ${res.data}");
//
//       if (res.data is! Map<String, dynamic>) return null;
//
//       final parsed = CustomerDetailV2Response.fromJson(
//         Map<String, dynamic>.from(res.data),
//       );
//
//       for (final item in parsed.data) {
//         if (item.id == customerId) return item;
//       }
//
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ CUSTOMER DETAIL V2 API ERROR TYPE: ${e.type}");
//       debugPrint("❌ CUSTOMER DETAIL V2 API ERROR MSG : ${e.message}");
//       debugPrint("❌ CUSTOMER DETAIL V2 STATUS       : ${e.response?.statusCode}");
//       debugPrint("❌ CUSTOMER DETAIL V2 DATA         : ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ CUSTOMER DETAIL V2 UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

class CustomerDetailV2Service {
  Future<CustomerDetailV2Item?> getCustomerById({
    required String customerId,
    int page = 1,
    int limit = 100,
    String? search,
  }) async {
    try {
      final query = <String, dynamic>{
        "page": page,
        "limit": limit,
      };

      if (search != null && search.trim().isNotEmpty) {
        query["search"] = search.trim();
      }

      debugPrint("✅ CUSTOMER DETAIL V2 HIT: ${RetailerAPI.customersListingV2}");
      debugPrint("✅ CUSTOMER DETAIL V2 QUERY: $query");
      debugPrint("✅ CUSTOMER DETAIL V2 TARGET CUSTOMER ID: $customerId");

      final res = await ApiClient.dio.get(
        RetailerAPI.customersListingV2,
        queryParameters: query,
      );

      debugPrint("✅ CUSTOMER DETAIL V2 STATUS: ${res.statusCode}");
      debugPrint("✅ CUSTOMER DETAIL V2 RESPONSE: ${res.data}");

      if (res.data is! Map<String, dynamic>) return null;

      final parsed = CustomerDetailV2Response.fromJson(
        Map<String, dynamic>.from(res.data),
      );

      for (final item in parsed.data) {
        debugPrint(
          "🧾 LIST ITEM => customerId=${item.id}, "
              "name=${item.name}, "
              "isEnrollment=${item.isEnrollment}, "
              "deviceObject=${item.device != null}, "
              "deviceMongoId=${item.device?.id}, "
              "deviceId=${item.device?.deviceId}",
        );

        if (item.id == customerId) {
          debugPrint("🎯 MATCHED CUSTOMER FOUND => ${item.id}");
          debugPrint("🎯 MATCHED CUSTOMER NAME => ${item.name}");
          debugPrint("🎯 MATCHED CUSTOMER DEVICE OBJECT => ${item.device != null}");
          debugPrint("🎯 MATCHED CUSTOMER DEVICE _ID => ${item.device?.id}");
          debugPrint("🎯 MATCHED CUSTOMER DEVICE_ID => ${item.device?.deviceId}");
          return item;
        }
      }

      debugPrint("❌ No matching customer found for id: $customerId");
      return null;
    } on DioException catch (e) {
      debugPrint("❌ CUSTOMER DETAIL V2 API ERROR TYPE: ${e.type}");
      debugPrint("❌ CUSTOMER DETAIL V2 API ERROR MSG : ${e.message}");
      debugPrint("❌ CUSTOMER DETAIL V2 STATUS       : ${e.response?.statusCode}");
      debugPrint("❌ CUSTOMER DETAIL V2 DATA         : ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ CUSTOMER DETAIL V2 UNKNOWN ERROR: $e");
      return null;
    }
  }
}