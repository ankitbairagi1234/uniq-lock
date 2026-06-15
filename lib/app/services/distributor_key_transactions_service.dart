import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/transaction_response.dart';

class DistributorKeyTransactionsService {
  Future<TransactionResponse?> getKeyTransactions({
    required String keyType,
    required int page,
    required int limit,
  }) async {
    try {
      final url = RetailerAPI.getDistributorKeyTransactions(
        keyType: keyType,
        page: page,
        limit: limit,
      );

      debugPrint("✅ KEY TX HIT: $url");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(url);

      debugPrint("✅ KEY TX STATUS: ${res.statusCode}");
      debugPrint("✅ KEY TX RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return TransactionResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ KEY TX API ERROR: ${e.response?.statusCode} ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ KEY TX UNKNOWN ERROR: $e");
      return null;
    }
  }
}
