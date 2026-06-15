// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:zlock_smart_finance/app/services/dio_client.dart';
// import 'package:zlock_smart_finance/app/services/retailer_api.dart';
// import 'package:zlock_smart_finance/model/retailer_dashboard_model.dart';

// class RetailerDashboardService {
//   Future<RetailerDashboardResponse?> getRetailerDashboard() async {
//     try {
//       debugPrint("✅ DASH HIT: ${RetailerAPI.getRetailerDashboard}");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.get(RetailerAPI.getRetailerDashboard);
//
//       debugPrint("✅ DASH STATUS: ${res.statusCode}");
//       debugPrint("✅ DASH RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return RetailerDashboardResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ DASH API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ DASH UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/dashboard_response.dart';

class RetailerDashboardService {
  Future<DashboardResponse?> getRetailerDashboard() async {
    try {
      debugPrint("✅ RETAILER DASH HIT: ${RetailerAPI.getDashBoard}");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(RetailerAPI.getDashBoard);

      debugPrint("✅ RETAILER DASH STATUS: ${res.statusCode}");
      debugPrint("✅ RETAILER DASH RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return DashboardResponse.fromJson(res.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ RETAILER DASH API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ RETAILER DASH UNKNOWN ERROR: $e");
      return null;
    }
  }
}