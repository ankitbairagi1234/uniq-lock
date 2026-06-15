import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';

class UpcomingService {
  Future<Map<String, dynamic>?> getUpcomingEmis({
    required int page,
    required int limit,
  }) async {
    try {
      debugPrint("✅ UPCOMING HIT: ${RetailerAPI.getUpcomingEmis}?page=$page&limit=$limit");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(
        RetailerAPI.getUpcomingEmis,
        queryParameters: {"page": page, "limit": limit},
      );

      debugPrint("✅ UPCOMING STATUS: ${res.statusCode}");
      debugPrint("✅ UPCOMING RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ UPCOMING API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ UPCOMING UNKNOWN ERROR: $e");
      return null;
    }
  }
}
