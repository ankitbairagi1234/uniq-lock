import 'package:dio/dio.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/device_location_model.dart';

class DeviceLocationService {

  final Dio dio;

  DeviceLocationService(this.dio);

  Future<DeviceLocationModel?> getDeviceLocation(String deviceId) async {
    try {

      final res = await dio.get(
        RetailerAPI.deviceLocation(deviceId),
      );

      if (res.data["success"] == true) {
        return DeviceLocationModel.fromJson(res.data);
      }

      return null;

    } catch (e) {
      return null;
    }
  }
}