import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: RetailerAPI.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  static void attachToken() {
    final box = GetStorage();
    final token = box.read("token");
    if (token != null && token.toString().isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
  }
}
