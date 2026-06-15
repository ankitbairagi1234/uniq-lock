import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/user_profile_model.dart';
// import 'package:zlock_smart_finance/model/user_profile_model.dart';

// class ProfileService {
//   Future<UserProfileResponse?> getProfile() async {
//     try {
//       final res = await ApiClient.dio.get(RetailerAPI.getUserProfile);
//
//       if (res.data is Map<String, dynamic>) {
//         return UserProfileResponse.fromJson(res.data);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ PROFILE API ERROR: ${e.response?.data}");
//       return null;
//     }
//   }
// }

// class ProfileService {
//   Future<UserProfileResponse?> getProfile() async {
//     try {
//       final res = await ApiClient.dio.get(RetailerAPI.getUserProfile);
//       debugPrint("✅ PROFILE RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return UserProfileResponse.fromJson(res.data);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ PROFILE ERROR TYPE : ${e.type}");
//       debugPrint("❌ PROFILE ERROR MSG  : ${e.message}");
//       debugPrint("❌ PROFILE STATUS    : ${e.response?.statusCode}");
//       debugPrint("❌ PROFILE DATA      : ${e.response?.data}");
//       debugPrint("❌ PROFILE ERROR RAW : ${e.error}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ PROFILE UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

class ProfileService {
  Future<UserProfileResponse?> getProfile() async {
    try {
      final res = await ApiClient.dio.get(RetailerAPI.getProfile);

      debugPrint("✅ PROFILE RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return UserProfileResponse.fromJson(res.data);
      }

      return null;
    } on DioException catch (e) {
      debugPrint("❌ PROFILE ERROR TYPE : ${e.type}");
      debugPrint("❌ PROFILE ERROR MSG  : ${e.message}");
      debugPrint("❌ PROFILE STATUS    : ${e.response?.statusCode}");
      debugPrint("❌ PROFILE DATA      : ${e.response?.data}");
      debugPrint("❌ PROFILE ERROR RAW : ${e.error}");
      return null;
    } catch (e) {
      debugPrint("❌ PROFILE UNKNOWN ERROR: $e");
      return null;
    }
  }
}