import 'package:flutter/cupertino.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/key_ledger_response.dart';

import 'dio_client.dart';

class KeyTransactionsService {
  Future<KeyLedgerResponse?> getKeyLedger({
    required int page,
    required int limit,
  }) async {
    try {
      final res = await ApiClient.dio.get(
        RetailerAPI.keyLedger,
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      debugPrint("🌍 KEY LEDGER API: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return KeyLedgerResponse.fromJson(res.data);
      }

      return null;
    } catch (e) {
      debugPrint("❌ KEY LEDGER ERROR: $e");
      return null;
    }
  }
}