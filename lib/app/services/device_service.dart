import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/chnage_password_model.dart';

class DeviceService {
  Future<CommonResponse> lockDevice({
    required String deviceId,
    required String reason,
  }) async {
    return _post(
      url: RetailerAPI.lockDevice,
      payload: {"deviceId": deviceId.trim(), "reason": reason.trim()},
      tag: "LOCK",
    );
  }

  Future<CommonResponse> unlockDevice({
    required String deviceId,
    required String reason,
  }) async {
    return _post(
      url: RetailerAPI.unlockDevice,
      payload: {"deviceId": deviceId.trim(), "reason": reason.trim()},
      tag: "UNLOCK",
    );
  }

  Future<CommonResponse> _post({
    required String url,
    required Map<String, dynamic> payload,
    required String tag,
  }) async {
    try {
      debugPrint("✅ $tag HIT: $url");
      debugPrint("✅ $tag PAYLOAD: ${jsonEncode(payload)}");
      debugPrint("✅ $tag HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.post(url, data: payload);

      debugPrint("✅ $tag STATUS: ${res.statusCode}");
      debugPrint("✅ $tag RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return CommonResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return CommonResponse(status: 0, message: "Invalid server response");
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
          : "";

      final msg = serverMsg.isNotEmpty
          ? serverMsg
          : "Request failed. Please try again.";

      return CommonResponse(status: e.response?.statusCode ?? 0, message: msg);
    } catch (e) {
      return CommonResponse(status: 0, message: "Something went wrong");
    }
  }
}
