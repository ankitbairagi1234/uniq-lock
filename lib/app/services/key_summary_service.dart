import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/key_summary_model.dart';

class KeySummaryService {
  Future<KeySummaryResponse?> getKeySummary() async {
    try {
      debugPrint("✅ KEY SUMMARY HIT: ${RetailerAPI.keyDetail}");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(RetailerAPI.keyDetail);

      debugPrint("✅ KEY SUMMARY STATUS: ${res.statusCode}");
      debugPrint("✅ KEY SUMMARY RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return KeySummaryResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ KEY SUMMARY API ERROR: ${e.type}");
      debugPrint("❌ KEY SUMMARY STATUS   : ${e.response?.statusCode}");
      debugPrint("❌ KEY SUMMARY DATA     : ${e.response?.data}");
      debugPrint("❌ KEY SUMMARY RAW      : ${e.error}");
      return null;
    } catch (e) {
      debugPrint("❌ KEY SUMMARY UNKNOWN ERROR: $e");
      return null;
    }
  }
}
