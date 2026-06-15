import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/qr_response_model.dart';

class QrService {
  Future<QrResponse?> getDeviceQr({required String deviceMongoId}) async {
    try {
      final url = RetailerAPI.deviceQr(deviceMongoId);

      debugPrint("✅ QR HIT: $url");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(url);

      debugPrint("✅ QR STATUS: ${res.statusCode}");
      debugPrint("✅ QR RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return QrResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ QR API ERROR: ${e.type}");
      debugPrint("❌ QR STATUS   : ${e.response?.statusCode}");
      debugPrint("❌ QR DATA     : ${e.response?.data}");
      debugPrint("❌ QR RAW      : ${e.error}");
      return null;
    } catch (e) {
      debugPrint("❌ QR UNKNOWN ERROR: $e");
      return null;
    }
  }
}
