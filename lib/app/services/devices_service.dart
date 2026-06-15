import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/device_list_response.dart';

class DevicesService {
  Future<DeviceListResponse?> getDevices({
    required String type, // ACTIVE etc
    String? search,
    String? deviceType, // ANDROID etc
    required int page,
    required int limit,
    int? today, // 1 or 0
  }) async {
    try {
      final query = <String, dynamic>{
        "type": type,
        "page": page,
        "limit": limit,
      };

      if (search != null && search.trim().isNotEmpty) {
        query["search"] = search.trim();
      }
      if (deviceType != null && deviceType.trim().isNotEmpty) {
        query["deviceType"] = deviceType.trim();
      }
      if (today != null) {
        query["today"] = today;
      }

      // ✅ DEBUG PRINT
      debugPrint("✅ DEVICES HIT: ${RetailerAPI.devicesList}");
      debugPrint("✅ DEVICES QUERY: $query");
      debugPrint("✅ DEVICES HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(
        RetailerAPI.devicesList,
        queryParameters: query,
      );

      debugPrint("✅ DEVICES STATUS: ${res.statusCode}");
      debugPrint("✅ DEVICES RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return DeviceListResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ DEVICES API ERROR TYPE: ${e.type}");
      debugPrint("❌ DEVICES API ERROR MSG : ${e.message}");
      debugPrint("❌ DEVICES STATUS       : ${e.response?.statusCode}");
      debugPrint("❌ DEVICES DATA         : ${e.response?.data}");
      debugPrint("❌ DEVICES RAW          : ${e.error}");
      return null;
    } catch (e) {
      debugPrint("❌ DEVICES UNKNOWN ERROR: $e");
      return null;
    }
  }
}
