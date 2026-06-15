import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/key_transfer_models.dart';

// class DistributorKeyTransferService {
//   Future<KeyTransferResponse?> transferKeys(KeyTransferRequest req) async {
//     try {
//       final url = RetailerAPI.transferKeysToRetailer;
//
//       debugPrint("✅ KEY TRANSFER HIT: $url");
//       debugPrint("✅ BODY: ${req.toJson()}");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.post(url, data: req.toJson());
//
//       debugPrint("✅ KEY TRANSFER STATUS: ${res.statusCode}");
//       debugPrint("✅ KEY TRANSFER RESPONSE: ${res.data}");
//
//       if (res.data is Map) {
//         return KeyTransferResponse.fromJson(Map<String, dynamic>.from(res.data));
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ KEY TRANSFER API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ KEY TRANSFER UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

// class DistributorKeyTransferService {
//   final dio = ApiClient.dio;
//
//   /// ================= CREDIT =================
//   Future<KeyTransferResponse?> creditKeys({
//     required int units,
//   }) async {
//     try {
//       final res = await dio.post(
//         "${RetailerAPI.baseUrl}/api/keys/request",
//         data: {
//           "units": units,
//           "keyType": "basic",
//           "isFoc": false,
//           "reason": "Manual credit from app",
//         },
//       );
//
//       debugPrint("✅ CREDIT RESPONSE: ${res.data}");
//
//       if (res.data is Map) {
//         return KeyTransferResponse.fromJson(
//           Map<String, dynamic>.from(res.data),
//         );
//       }
//       return null;
//     } catch (e) {
//       debugPrint("❌ CREDIT ERROR: $e");
//       return null;
//     }
//   }
//
//   /// ================= DEBIT =================
//   Future<KeyTransferResponse?> debitKeys({
//     required String retailerId,
//     required int units,
//   }) async {
//     try {
//       final res = await dio.post(
//         "/api/keys/debit",
//         data: {
//           "receiverId": retailerId,
//           "ownerModel": "Vendor",
//           "units": units,
//         },
//       );
//
//       debugPrint("✅ DEBIT RESPONSE: ${res.data}");
//
//       if (res.data is Map) {
//         return KeyTransferResponse.fromJson(
//           Map<String, dynamic>.from(res.data),
//         );
//       }
//       return null;
//     } catch (e) {
//       debugPrint("❌ DEBIT ERROR: $e");
//       return null;
//     }
//   }
// }
class DistributorKeyTransferService {
  final dio = ApiClient.dio;

  /// ================= CREDIT =================
  // Future<KeyTransferResponse?> creditKeys({
  //   required int units,
  // }) async {
  //   final url = "${RetailerAPI.baseUrl}/api/keys/request";
  //
  //   try {
  //     final body = {
  //       "units": units,
  //       "keyType": "basic",
  //       "isFoc": false,
  //       "reason": "Manual credit from app",
  //     };
  //
  //     debugPrint("🚀 ===== CREDIT API HIT =====");
  //     debugPrint("👉 URL: $url");
  //     debugPrint("👉 BODY: $body");
  //     debugPrint("👉 HEADERS: ${dio.options.headers}");
  //
  //     final res = await dio.post(url, data: body);
  //
  //     debugPrint("✅ STATUS: ${res.statusCode}");
  //     debugPrint("✅ RESPONSE: ${res.data}");
  //
  //     if (res.data is Map) {
  //       return KeyTransferResponse.fromJson(
  //         Map<String, dynamic>.from(res.data),
  //       );
  //     }
  //     return null;
  //   } catch (e) {
  //     debugPrint("❌ CREDIT ERROR: $e");
  //     return null;
  //   }
  // }

  Future<KeyTransferResponse?> creditKeys({
    required int units,required String retailerId,
  }) async {
    final url = "${RetailerAPI.baseUrl}/api/keys/debit";
print("retailer id in credit >>>>>>>>>${retailerId}");
    try {
      final body = {
        "receiverId": retailerId,
        "ownerModel": "Vendor",
        "units": units,

      };

      debugPrint("🚀 ===== CREDIT API HIT =====");
      debugPrint("👉 URL: $url");
      debugPrint("👉 BODY: $body");
      debugPrint("👉 HEADERS: ${dio.options.headers}");

      final res = await dio.post(url, data: body);

      debugPrint("✅ STATUS: ${res.statusCode}");
      debugPrint("✅ RESPONSE: ${res.data}");

      if (res.data is Map) {
        return KeyTransferResponse.fromJson(
          Map<String, dynamic>.from(res.data),
        );
      }
      return null;
    } catch (e) {
      debugPrint("❌ CREDIT ERROR: $e");
      return null;
    }
  }

  /// ================= DEBIT =================
  Future<KeyTransferResponse?> debitKeys({
    required String retailerId, required String receiverId,
    required int units,
  }) async {
    print("retailer Id >>>>>>>>>>>>>${retailerId}");
    print("recever Id >>>>>>>>>>>>>${receiverId}");
    final url = "${RetailerAPI.baseUrl}/api/keys/debit";

    try {
      final body = {
        "owner" : retailerId, //debit
        "receiverId": receiverId,
        "ownerModel": "Vendor",
        "units": units,
      };
      print("${body}");

      debugPrint("🚀 ===== DEBIT API HIT =====");
      debugPrint("👉 URL: $url");
      debugPrint("👉 BODY: $body");
      debugPrint("👉 HEADERS: ${dio.options.headers}");

      final res = await dio.post(url, data: body);

      debugPrint("✅ STATUS: ${res.statusCode}");
      debugPrint("✅ RESPONSE: ${res.data}");

      if (res.data is Map) {
        return KeyTransferResponse.fromJson(
          Map<String, dynamic>.from(res.data),
        );
      }
      return null;
    } catch (e) {
      debugPrint("❌ DEBIT ERROR: $e");
      return null;
    }
  }
}