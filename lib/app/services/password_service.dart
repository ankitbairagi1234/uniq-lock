import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/chnage_password_model.dart';


// class PasswordService {
//   Future<CommonResponse> changePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       final payload = {
//         "currentPassword": currentPassword.trim(),
//         "newPassword": newPassword.trim(),
//         "confirmPassword": confirmPassword.trim(),
//       };
//
//       debugPrint("✅ CHANGE PASS HIT: ${RetailerAPI.changePassword}");
//       debugPrint("✅ PAYLOAD: ${jsonEncode(payload)}");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.post(
//         RetailerAPI.changePassword,
//         data: payload,
//       );
//
//       debugPrint("✅ CHANGE PASS STATUS: ${res.statusCode}");
//       debugPrint("✅ CHANGE PASS RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return CommonResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return CommonResponse(status: 0, message: "Invalid server response");
//     } on DioException catch (e) {
//       final serverMsg = (e.response?.data is Map)
//           ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "")
//           .toString()
//           : "";
//
//       final msg = serverMsg.isNotEmpty
//           ? serverMsg
//           : "Change password failed. Please try again.";
//
//       return CommonResponse(status: e.response?.statusCode ?? 0, message: msg);
//     } catch (_) {
//       return CommonResponse(status: 0, message: "Something went wrong");
//     }
//   }
// }

class PasswordService {

  Future<ChangePasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {

    try {

      final payload = {
        "currentPassword": currentPassword.trim(),
        "newPassword": newPassword.trim(),
      };

      debugPrint("✅ CHANGE PASS HIT: ${RetailerAPI.changePassword}");
      debugPrint("✅ PAYLOAD: ${jsonEncode(payload)}");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.put(
        RetailerAPI.changePassword,
        data: payload,
      );

      debugPrint("✅ CHANGE PASS STATUS: ${res.statusCode}");
      debugPrint("✅ CHANGE PASS RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return ChangePasswordResponse.fromJson(res.data);
      }

      return ChangePasswordResponse(
        success: false,
        message: "Invalid server response",
      );

    } on DioException catch (e) {

      debugPrint("❌ CHANGE PASS ERROR STATUS: ${e.response?.statusCode}");
      debugPrint("❌ CHANGE PASS ERROR DATA: ${e.response?.data}");

      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ??
          e.response?.data["msg"] ??
          "")
          : "";

      final msg = serverMsg.toString().isNotEmpty
          ? serverMsg.toString()
          : "Change password failed";

      return ChangePasswordResponse(
        success: false,
        message: msg,
      );

    } catch (_) {

      return ChangePasswordResponse(
        success: false,
        message: "Something went wrong",
      );
    }
  }
  Future<ChangePasswordResponse> changePasswordRetailer({
    required String newPassword,
    required String confirmPassword,
    required String targetId,

  }) async {

    try {

      final payload = {
        "targetId": targetId.trim(),
        "newPassword": newPassword.trim(),
        "confirmPassword": confirmPassword.trim(),

      };

      debugPrint("✅ CHANGE PASS HIT: ${RetailerAPI.changePasswordAdmin}");
      debugPrint("✅ PAYLOAD: ${jsonEncode(payload)}");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.put(
        RetailerAPI.changePasswordAdmin,
        data: payload,
      );

      debugPrint("✅ CHANGE PASS STATUS: ${res.statusCode}");
      debugPrint("✅ CHANGE PASS RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return ChangePasswordResponse.fromJson(res.data);
      }

      return ChangePasswordResponse(
        success: false,
        message: "Invalid server response",
      );

    } on DioException catch (e) {

      debugPrint("❌ CHANGE PASS ERROR STATUS: ${e.response?.statusCode}");
      debugPrint("❌ CHANGE PASS ERROR DATA: ${e.response?.data}");

      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ??
          e.response?.data["msg"] ??
          "")
          : "";

      final msg = serverMsg.toString().isNotEmpty
          ? serverMsg.toString()
          : "Change password failed";

      return ChangePasswordResponse(
        success: false,
        message: msg,
      );

    } catch (_) {

      return ChangePasswordResponse(
        success: false,
        message: "Something went wrong",
      );
    }
  }
}