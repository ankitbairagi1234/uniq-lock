// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:zlock_smart_finance/app/services/dio_client.dart';
// import 'package:zlock_smart_finance/app/services/retailer_api.dart';
// import 'package:zlock_smart_finance/model/distributor_dashboard_response.dart';
//
// class DistributorDashboardService {
//   Future<DistributorDashboardResponse?> getDashboard() async {
//     try {
//       final res = await ApiClient.dio.get(RetailerAPI.getDistributorDashboard);
//
//       return DistributorDashboardResponse.fromJson(res.data as Map<String, dynamic>);
//     } on DioException catch (e) {
//       debugPrint("❌ Distributor Dashboard DioError => ${e.response?.statusCode} | ${e.message}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ Distributor Dashboard Error => $e");
//       return null;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/distributor_dashboard_response.dart';

// class DistributorDashboardService {
//   Future<DistributorDashboardResponse?> getDistributorDashboard() async {
//     try {
//       debugPrint("✅ DISTRIBUTOR DASH HIT: ${RetailerAPI.getDistributorDashboard}");
//       debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");
//
//       final res = await ApiClient.dio.get(RetailerAPI.getDistributorDashboard);
//
//       debugPrint("✅ DISTRIBUTOR DASH STATUS: ${res.statusCode}");
//       debugPrint("✅ DISTRIBUTOR DASH RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return DistributorDashboardResponse.fromJson(
//           res.data as Map<String, dynamic>,
//         );
//       }
//
//       return null;
//     } on DioException catch (e) {
//       debugPrint(
//         "❌ DISTRIBUTOR DASH API ERROR: ${e.response?.statusCode}  ${e.response?.data}",
//       );
//       return null;
//     } catch (e) {
//       debugPrint("❌ DISTRIBUTOR DASH UNKNOWN ERROR: $e");
//       return null;
//     }
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/dashboard_response.dart';

class DistributorDashboardService {
  Future<DashboardResponse?> getDistributorDashboard() async {
    try {
      debugPrint("✅ DASH HIT: ${RetailerAPI.getDashBoard}");
      debugPrint("✅ HEADERS: ${ApiClient.dio.options.headers}");

      final res = await ApiClient.dio.get(RetailerAPI.getDashBoard);

      debugPrint("✅ DASH STATUS: ${res.statusCode}");
      debugPrint("✅ DASH RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return DashboardResponse.fromJson(res.data as Map<String, dynamic>);
      }

      return null;
    } on DioException catch (e) {
      debugPrint("❌ DASH API ERROR: ${e.response?.statusCode}  ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ DASH UNKNOWN ERROR: $e");
      return null;
    }
  }
}