import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/frp_email_response.dart';

import 'dio_client.dart';

class FrpEmailService {
  final dio = ApiClient.dio;

  Future<FrpEmailResponse?> updateFrpEmail({
    required String id,
    required String email,
  }) async {
    final url = RetailerAPI.updateFrpEmail;

    try {
      final body = {
        "id": id,
        "frpEmail": email,
      };

      debugPrint("🚀 ===== FRP EMAIL UPDATE =====");
      debugPrint("👉 URL: $url");
      debugPrint("👉 BODY: $body");
      debugPrint("👉 HEADERS: ${dio.options.headers}");

      final res = await dio.put(url, data: body);

      debugPrint("✅ STATUS: ${res.statusCode}");
      debugPrint("✅ RESPONSE: ${res.data}");

      if (res.data is Map) {
        return FrpEmailResponse.fromJson(
          Map<String, dynamic>.from(res.data),
        );
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ API ERROR: ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ UNKNOWN ERROR: $e");
      return null;
    }
  }
}