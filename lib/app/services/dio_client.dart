// import 'package:dio/dio.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:zlock_smart_finance/app/services/retailer_api.dart';
//
// class ApiClient {
//   ApiClient._();
//
//   static final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: RetailerAPI.baseUrl,
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 20),
//       sendTimeout: const Duration(seconds: 20),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//     ),
//   );
//
//   static void attachToken() {
//     final box = GetStorage();
//     final token = box.read("token");
//     if (token != null && token.toString().isNotEmpty) {
//       dio.options.headers["Authorization"] = "Bearer $token";
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';

class ApiClient {
  ApiClient._();

  static final GetStorage _box = GetStorage();

  /// 🔥 logout multiple trigger avoid
  static bool _isLoggingOut = false;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: RetailerAPI.baseUrl,

      /// 🔥 timeout increase
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      /// 🔥 allow 401 in response
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  )..interceptors.addAll([

    /// ==============================
    /// 🔵 REQUEST INTERCEPTOR
    /// ==============================
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _box.read("token");

        print("\n📤 ========= API REQUEST =========");
        print("📤 URL: ${options.uri}");
        print("📤 METHOD: ${options.method}");
        print("📤 TOKEN: $token");

        if (token != null && token.toString().isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }

        print("📤 HEADERS: ${options.headers}");
        print("📤 ==============================\n");

        return handler.next(options);
      },
    ),

    /// ==============================
    /// 🟢 RESPONSE INTERCEPTOR
    /// ==============================
    InterceptorsWrapper(
      onResponse: (response, handler) async {

        print("\n📥 ========= API RESPONSE =========");
        print("📥 URL: ${response.requestOptions.uri}");
        print("📥 STATUS: ${response.statusCode}");
        print("📥 DATA: ${response.data}");
        print("📥 =================================\n");

        /// 🔴 CASE 1: STATUS 401
        if (response.statusCode == 401) {
          print("🚨 TOKEN EXPIRED (STATUS 401)");
          await _handleLogout();
          return;
        }

        /// 🔴 CASE 2: MESSAGE BASED TOKEN EXPIRE
        if (response.data is Map &&
            response.data["success"] == false &&
            (response.data["message"] ?? "")
                .toString()
                .toLowerCase()
                .contains("token")) {

          print("🚨 TOKEN EXPIRED (MESSAGE MATCH)");
          await _handleLogout();
          return;
        }

        return handler.next(response);
      },
    ),

    /// ==============================
    /// 🔴 ERROR INTERCEPTOR
    /// ==============================
    InterceptorsWrapper(
      onError: (e, handler) async {

        print("\n❌ ========= API ERROR =========");
        print("❌ URL: ${e.requestOptions.uri}");
        print("❌ TYPE: ${e.type}");
        print("❌ STATUS: ${e.response?.statusCode}");
        print("❌ DATA: ${e.response?.data}");
        print("❌ =============================\n");

        /// 🔴 TOKEN EXPIRE
        if (e.response?.statusCode == 401) {
          print("🚨 TOKEN EXPIRED (ERROR BLOCK)");
          await _handleLogout();
          return;
        }

        /// 🔴 TIMEOUT HANDLE
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {

          print("⚠️ TIMEOUT ERROR DETECTED");

          Get.snackbar(
            "Server Issue",
            "Request timeout. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        return handler.next(e);
      },
    ),
  ]);

  /// ==============================
  /// 🔥 OPTIONAL (manual token attach)
  /// ==============================
  static void attachToken() {
    final token = _box.read("token");

    print("🔐 ATTACH TOKEN CALLED: $token");

    if (token != null && token.toString().isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
  }

  /// ==============================
  /// 🔥 LOGOUT FUNCTION
  /// ==============================
  static Future<void> _handleLogout() async {
    if (_isLoggingOut) {
      print("⚠️ Logout already in progress...");
      return;
    }

    _isLoggingOut = true;

    try {
      print("\n🔥 ========= LOGOUT START =========");

      /// 🧹 clear storage
      await _box.erase();
      print("🧹 STORAGE CLEARED");

      /// 🧹 remove controllers
      Get.deleteAll(force: true);
      print("🧹 CONTROLLERS CLEARED");

      /// 🔄 navigate login
      Get.offAllNamed(AppRoutes.LOGIN, predicate: (_) => false);
      print("➡️ NAVIGATED TO LOGIN");

      /// 🔔 snackbar
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          "Session Expired",
          "Please login again",
          snackPosition: SnackPosition.BOTTOM,
        );
      });

      print("🔥 ========= LOGOUT DONE =========\n");

    } catch (e) {
      print("❌ LOGOUT ERROR: $e");
    } finally {
      _isLoggingOut = false;
    }
  }
}