import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/chnage_password_model.dart'; // CommonResponse

class RemoveKeyService {
  Future<CommonResponse> removeKey({required String keyDocId}) async {
    try {
      final url = RetailerAPI.removeKey(keyDocId);
      debugPrint("🗑️ REMOVE KEY URL => $url");

      final res = await ApiClient.dio.delete(url);

      debugPrint("✅ REMOVE KEY STATUS => ${res.statusCode}");
      debugPrint("✅ REMOVE KEY RESP   => ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return CommonResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return CommonResponse(status: res.statusCode ?? 0, message: "Invalid server response");
    } on DioException catch (e) {
      debugPrint("❌ REMOVE KEY STATUS => ${e.response?.statusCode}");
      debugPrint("❌ REMOVE KEY RESP   => ${e.response?.data}");

      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
          : "";

      return CommonResponse(
        status: e.response?.statusCode ?? 0,
        message: serverMsg.isNotEmpty ? serverMsg : "Remove key failed",
      );
    } catch (e) {
      debugPrint("❌ REMOVE KEY ERROR => $e");
      return CommonResponse(status: 0, message: "Something went wrong");
    }
  }
}
