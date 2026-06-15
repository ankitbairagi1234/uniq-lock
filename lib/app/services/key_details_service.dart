import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/key_details_response.dart';

class KeyDetailsService {
  Future<KeyDetailsResponse?> getKeyDetails(String keyId) async {
    try {
      final url = RetailerAPI.keyDetails(keyId);

      debugPrint("✅ KEY DETAILS HIT: $url");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(url);

      debugPrint("✅ KEY DETAILS STATUS: ${res.statusCode}");
      debugPrint("✅ KEY DETAILS RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return KeyDetailsResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ KEY DETAILS ERROR: ${e.type}");
      debugPrint("❌ KEY DETAILS MSG  : ${e.message}");
      debugPrint("❌ KEY DETAILS CODE : ${e.response?.statusCode}");
      debugPrint("❌ KEY DETAILS DATA : ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ KEY DETAILS UNKNOWN: $e");
      return null;
    }
  }
}
