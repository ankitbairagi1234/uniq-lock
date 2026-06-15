import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/update_emi_response.dart';

class EmiService {
  Future<UpdateEmiResponse?> updateEmi({
    required String emiId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = RetailerAPI.updateEmi(emiId);

      debugPrint("✅ UPDATE EMI HIT: $url");
      debugPrint("✅ UPDATE EMI BODY: $body");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.put(url, data: body);

      debugPrint("✅ UPDATE EMI STATUS: ${res.statusCode}");
      debugPrint("✅ UPDATE EMI RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return UpdateEmiResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ UPDATE EMI ERROR: ${e.type}");
      debugPrint("❌ UPDATE EMI MSG  : ${e.message}");
      debugPrint("❌ UPDATE EMI CODE : ${e.response?.statusCode}");
      debugPrint("❌ UPDATE EMI DATA : ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ UPDATE EMI UNKNOWN: $e");
      return null;
    }
  }
}
