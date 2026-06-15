import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/chnage_password_model.dart';
import 'package:zlock_smart_finance/model/update_profile_response.dart';

class ManageAccountService {
  // Future<CommonResponse> editProfile(Map<String, dynamic> payload) async {
  //   try {
  //     debugPrint("✅ EDIT PROFILE HIT: ${RetailerAPI.editProfile}");
  //     debugPrint("✅ PAYLOAD: ${jsonEncode(payload)}");
  //
  //     final res = await ApiClient.dio.put(
  //       RetailerAPI.editProfile,
  //       data: payload,
  //     );
  //
  //     debugPrint("✅ EDIT STATUS: ${res.statusCode}");
  //     debugPrint("✅ EDIT RESPONSE: ${res.data}");
  //
  //     if (res.data is Map<String, dynamic>) {
  //       return CommonResponse.fromJson(res.data as Map<String, dynamic>);
  //     }
  //     return CommonResponse(status: 0, message: "Invalid server response");
  //   } on DioException catch (e) {
  //     final serverMsg = (e.response?.data is Map)
  //         ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
  //         : "";
  //     return CommonResponse(
  //       status: e.response?.statusCode ?? 0,
  //       message: serverMsg.isNotEmpty ? serverMsg : "Update failed",
  //     );
  //   } catch (_) {
  //     return CommonResponse(status: 0, message: "Something went wrong");
  //   }
  // }

  /// UPDATE PROFILE
  // Future<UpdateProfileResponse> updateProfile(
  //     Map<String, dynamic> payload) async {
  //
  //   try {
  //
  //     debugPrint("✅ UPDATE PROFILE HIT: ${RetailerAPI.updateProfile}");
  //     debugPrint("✅ PAYLOAD: ${jsonEncode(payload)}");
  //
  //     final res = await ApiClient.dio.put(
  //       RetailerAPI.updateProfile,
  //       data: payload,
  //     );
  //
  //     debugPrint("✅ UPDATE STATUS: ${res.statusCode}");
  //     debugPrint("✅ UPDATE RESPONSE: ${res.data}");
  //
  //     if (res.data is Map<String, dynamic>) {
  //       return UpdateProfileResponse.fromJson(res.data);
  //     }
  //
  //     return UpdateProfileResponse(
  //       success: false,
  //       message: "Invalid server response",
  //     );
  //
  //   } on DioException catch (e) {
  //
  //     final serverMsg = (e.response?.data is Map)
  //         ? (e.response?.data["message"] ??
  //         e.response?.data["msg"] ??
  //         "")
  //         .toString()
  //         : "";
  //
  //     return UpdateProfileResponse(
  //       success: false,
  //       message: serverMsg.isNotEmpty ? serverMsg : "Update failed",
  //     );
  //
  //   } catch (_) {
  //
  //     return UpdateProfileResponse(
  //       success: false,
  //       message: "Something went wrong",
  //     );
  //   }
  // }

  Future<UpdateProfileResponse> updateProfileMultipart({
    required Map<String, dynamic> payload,
    File? imageFile,
    Uint8List? signatureBytes,
  }) async {
    try {
      final form = FormData();

      /// TEXT
      payload.forEach((key, value) {
        form.fields.add(MapEntry(key, value.toString()));
      });
      debugPrint("🚀 API HIT: ${RetailerAPI.updateProfile}");
      debugPrint("📤 FORM FIELDS:");
      form.fields.forEach((e) {
        debugPrint("${e.key}: ${e.value}");
      });

      debugPrint("📤 FILES:");
      form.files.forEach((e) {
        debugPrint("${e.key}: ${e.value.filename}");
      });

      /// IMAGE
      if (imageFile != null && imageFile.existsSync()) {
        form.files.add(MapEntry(
          "profileImage",
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ));
      }

      /// SIGNATURE
      if (signatureBytes != null && signatureBytes.isNotEmpty) {
        form.files.add(MapEntry(
          "signature",
          MultipartFile.fromBytes(
            signatureBytes,
            filename: "signature.png",
          ),
        ));
      }

      final res = await ApiClient.dio.put(
        RetailerAPI.updateProfile,
        data: form,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      return UpdateProfileResponse.fromJson(res.data);

    } catch (e) {
      debugPrint("❌ ERROR: $e");

      return UpdateProfileResponse(
        success: false,
        message: "Update failed",
      );
    }
  }
  /// ✅ upload image (form-data key = "image")
  Future<CommonResponse> uploadProfileImage(File imageFile) async {
    try {
      debugPrint("✅ UPLOAD IMAGE HIT: ${RetailerAPI.uploadProfilePicture}");

      final form = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final res = await ApiClient.dio.put(
        RetailerAPI.uploadProfilePicture,
        data: form,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      debugPrint("✅ UPLOAD STATUS: ${res.statusCode}");
      debugPrint("✅ UPLOAD RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return CommonResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return CommonResponse(status: 0, message: "Invalid server response");
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map)
          ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
          : "";
      return CommonResponse(
        status: e.response?.statusCode ?? 0,
        message: serverMsg.isNotEmpty ? serverMsg : "Upload failed",
      );
    } catch (_) {
      return CommonResponse(status: 0, message: "Something went wrong");
    }
  }
}
