import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/request/update_retailer_models.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/retailer_details_response.dart';
// class DistributorRetailerDetailsService {
//   Future<RetailerDetailsResponse?> getRetailerDetails(String retailerId) async {
//     try {
//       final url = RetailerAPI.getRetailerDetails(retailerId);
//
//       debugPrint("✅ RETAILER DETAILS HIT: $url");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.get(url);
//
//       debugPrint("✅ DETAILS STATUS: ${res.statusCode}");
//       debugPrint("✅ DETAILS RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return RetailerDetailsResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ DETAILS API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ DETAILS UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

import 'dart:io';

class DistributorRetailerDetailsService {
  Future<RetailerDetailsResponse?> getRetailerDetails(String retailerId) async {
    try {
      final url = RetailerAPI.getRetailerDetails(retailerId);

      debugPrint("✅ RETAILER DETAILS HIT: $url");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(url);

      debugPrint("✅ DETAILS STATUS: ${res.statusCode}");
      debugPrint("✅ DETAILS RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return RetailerDetailsResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ DETAILS API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ DETAILS UNKNOWN ERROR: $e");
      return null;
    }
  }

  // ✅ UPDATE RETAILER (controller ke according)
  Future<RetailerDetailsResponse?> updateRetailer({
    required String retailerId,
    required UpdateRetailerRequest request,
    File? imageFile, // optional
  }) async {
    try {
      final url = RetailerAPI.updateRetailer(retailerId);

      // ✅ create form-data from request
      final map = request.toJson();

      final form = FormData();

      // text fields
      map.forEach((key, value) {
        if (value != null) {
          form.fields.add(MapEntry(key, value.toString()));
        }
      });

      // optional image
      if (imageFile != null) {
        form.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      debugPrint("✅ UPDATE RETAILER HIT: $url");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
      debugPrint("✅ UPDATE FIELDS: ${form.fields}");
      if (imageFile != null) debugPrint("✅ UPDATE IMAGE: ${imageFile.path}");

      final res = await ApiClient.dio.put(
        url,
        data: form,
        options: Options(contentType: "multipart/form-data"),
      );

      debugPrint("✅ UPDATE STATUS: ${res.statusCode}");
      debugPrint("✅ UPDATE RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return RetailerDetailsResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ UPDATE API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ UPDATE UNKNOWN ERROR: $e");
      return null;
    }
  }
}
