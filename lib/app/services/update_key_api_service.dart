import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/chnage_password_model.dart'; // CommonResponse
import 'package:zlock_smart_finance/app/request/update_key_request.dart';

class UpdateKeyApiService {
  Future<CommonResponse> updateKey({
    required String keyDocId, // ✅ _id from key details
    required UpdateKeyRequest request,
    File? productImageFile, // optional
    Uint8List? signaturePngBytes, // optional
  }) async {
    try {
      debugPrint("✅ UPDATE KEY URL: ${RetailerAPI.updateKey(keyDocId)}");
      debugPrint("✅ UPDATE KEY JSON: ${request.toJson()}");

      final formMap = <String, dynamic>{
        ...request.toJson(),
      };

      // ✅ optional product image
      if (productImageFile != null) {
        formMap["productImages"] = await MultipartFile.fromFile(
          productImageFile.path,
          filename: productImageFile.path.split('/').last,
        );
      }

      // ✅ optional signature
      if (signaturePngBytes != null && signaturePngBytes.isNotEmpty) {
        formMap["signature"] = MultipartFile.fromBytes(
          signaturePngBytes,
          filename: "signature.png",
          contentType: DioMediaType.parse("image/png"),
        );
      }

      final form = FormData.fromMap(formMap);

      final res = await ApiClient.dio.put(
        RetailerAPI.updateKey(keyDocId),
        data: form,
        options: Options(contentType: "multipart/form-data"),
      );

      debugPrint("✅ UPDATE KEY STATUS: ${res.statusCode}");
      debugPrint("✅ UPDATE KEY RESP: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return CommonResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return CommonResponse(status: res.statusCode ?? 0, message: "Invalid server response");
    } on DioException catch (e) {
      debugPrint("❌ UPDATE KEY STATUS: ${e.response?.statusCode}");
      debugPrint("❌ UPDATE KEY RESP: ${e.response?.data}");

      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
          : "";

      return CommonResponse(
        status: e.response?.statusCode ?? 0,
        message: serverMsg.isNotEmpty ? serverMsg : "Update key failed",
      );
    } catch (e) {
      debugPrint("❌ UPDATE KEY ERROR: $e");
      return CommonResponse(status: 0, message: "Something went wrong");
    }
  }
}
