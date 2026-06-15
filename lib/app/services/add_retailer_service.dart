// ✅ services/distributor_add_retailer_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/add_retailer_models.dart';

// class DistributorAddRetailerService {
//   Future<AddRetailerResponse?> addRetailer({
//     required AddRetailerRequest request,
//     File? imageFile, // form-data: image
//   }) async {
//     try {
//       debugPrint("✅ ADD RETAILER HIT: ${RetailerAPI.addRetailer}");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//       debugPrint("✅ BODY: ${request.toJson()}");
//       debugPrint("✅ IMAGE PATH: ${imageFile?.path}");
//
//       final form = FormData.fromMap({
//         ...request.toJson(),
//         if (imageFile != null)
//           "image": await MultipartFile.fromFile(
//             imageFile.path,
//             filename: imageFile.path.split('/').last,
//           ),
//       });
//
//       final res = await ApiClient.dio.post(
//         RetailerAPI.addRetailer,
//         data: form,
//         options: Options(contentType: "multipart/form-data"),
//       );
//
//       debugPrint("✅ ADD RETAILER STATUS: ${res.statusCode}");
//       debugPrint("✅ ADD RETAILER RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return AddRetailerResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ ADD RETAILER API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ ADD RETAILER UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

class DistributorAddRetailerService {
  Future<AddRetailerResponse?> addRetailer({
    required AddRetailerRequest request,
    File? imageFile,
  }) async {
    try {
      final formData = FormData();

      // ✅ Add all fields
      request.toJson().forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // ✅ IMAGE KEY FIX (IMPORTANT)
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            "profileImage", // 🔥 THIS MUST MATCH POSTMAN
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      final res = await ApiClient.dio.post(
        RetailerAPI.addRetailer,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (res.data != null) {
        return AddRetailerResponse.fromJson(res.data);
      }

      return null;
    } on DioException catch (e) {
      debugPrint("❌ ERROR: ${e.response?.data}");
      return null;
    }
  }
}