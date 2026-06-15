import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/model/device_command_model.dart';
import 'dio_client.dart';
import 'retailer_api.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zlock_smart_finance/model/device_command_model.dart';
import 'dio_client.dart';
import 'retailer_api.dart';

class DeviceCommandService {
  Future<DeviceCommandResponse> sendCommand(DeviceCommandRequest req) async {
    try {
      debugPrint("📤 SEND COMMAND URL: ${RetailerAPI.sendDeviceCommand}");
      debugPrint("📤 SEND COMMAND BODY: ${req.toJson()}");

      final res = await ApiClient.dio.post(
        RetailerAPI.sendDeviceCommand,
        data: req.toJson(),
      );

      debugPrint("✅ SEND COMMAND STATUS: ${res.statusCode}");
      debugPrint("✅ SEND COMMAND RESPONSE: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        return DeviceCommandResponse.fromJson(
          Map<String, dynamic>.from(res.data),
        );
      }

      return DeviceCommandResponse(
        success: false,
        message: "Invalid response from server",
        alreadyExists: false,
        command: null,
        fcm: null,
      );
    } on DioException catch (e) {
      debugPrint("❌ COMMAND ERROR TYPE   : ${e.type}");
      debugPrint("❌ COMMAND ERROR MSG    : ${e.message}");
      debugPrint("❌ COMMAND ERROR STATUS : ${e.response?.statusCode}");
      debugPrint("❌ COMMAND ERROR DATA   : ${e.response?.data}");

      String message = "Command failed. Please try again.";

      if (e.response?.data is Map) {
        final map = Map<String, dynamic>.from(e.response!.data);
        message = (map["message"] ?? message).toString();
      }

      return DeviceCommandResponse(
        success: false,
        message: message,
        alreadyExists: false,
        command: null,
        fcm: null,
      );
    } catch (e) {
      debugPrint("❌ COMMAND UNKNOWN ERROR: $e");

      return DeviceCommandResponse(
        success: false,
        message: "Something went wrong",
        alreadyExists: false,
        command: null,
        fcm: null,
      );
    }
  }
}