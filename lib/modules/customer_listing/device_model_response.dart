class   CustomerDeviceInfo {
  final String id;
  final String deviceId;
  final String? enrollmentToken;
  final String? fcmToken;
  final String? fcmTokenUpdatedAt;
  final String? fcmPlatform;
  final String? imei1;
  final String? imei2;
  final String? serialNumber;
  final String? macAddress;
  final String? androidVersion;
  final int sdkVersion;
  final String? manufacturer;
  final String? model;
  final String? deviceName;
  final String? status;
  final String? complianceState;
  final String? setupStatus;
  final int setupProgress;
  final String? currentSetupStep;
  final int downloadPercentage;
  final int installPercentage;
  final String? setupError;
  final String? networkType;
  final bool isWifiConnected;
  final bool isMobileHotspot;
  final String? networkSpeedCategory;
  final int adaptiveTimeout;
  final int networkSwitchCount;
  final int batteryLevel;
  final String? playProtectStatus;
  final bool playProtectDisabled;
  final String? installationMethod;
  final List<dynamic> appliedPolicies;
  final String? lastCheckIn;
  final String? lastHeartbeat;
  final String? enrolledAt;
  final int errorCount;
  final int retryCount;
  final int maxRetries;
  final bool factoryResetLocked;
  final bool launcherMode;
  final String? companyName;
  final List<dynamic> tags;
  final List<dynamic> installedApps;
  final String? createdAt;
  final String? updatedAt;

  CustomerDeviceInfo({
    required this.id,
    required this.deviceId,
    required this.enrollmentToken,
    required this.fcmToken,
    required this.fcmTokenUpdatedAt,
    required this.fcmPlatform,
    required this.imei1,
    required this.imei2,
    required this.serialNumber,
    required this.macAddress,
    required this.androidVersion,
    required this.sdkVersion,
    required this.manufacturer,
    required this.model,
    required this.deviceName,
    required this.status,
    required this.complianceState,
    required this.setupStatus,
    required this.setupProgress,
    required this.currentSetupStep,
    required this.downloadPercentage,
    required this.installPercentage,
    required this.setupError,
    required this.networkType,
    required this.isWifiConnected,
    required this.isMobileHotspot,
    required this.networkSpeedCategory,
    required this.adaptiveTimeout,
    required this.networkSwitchCount,
    required this.batteryLevel,
    required this.playProtectStatus,
    required this.playProtectDisabled,
    required this.installationMethod,
    required this.appliedPolicies,
    required this.lastCheckIn,
    required this.lastHeartbeat,
    required this.enrolledAt,
    required this.errorCount,
    required this.retryCount,
    required this.maxRetries,
    required this.factoryResetLocked,
    required this.launcherMode,
    required this.companyName,
    required this.tags,
    required this.installedApps,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerDeviceInfo.fromJson(Map<String, dynamic> json) {
    return CustomerDeviceInfo(
      id: (json["_id"] ?? "").toString(),
      deviceId: (json["device_id"] ?? "").toString(), // IMPORTANT
      enrollmentToken: json["enrollment_token"]?.toString(),
      fcmToken: json["fcm_token"]?.toString(),
      fcmTokenUpdatedAt: json["fcm_token_updated_at"]?.toString(),
      fcmPlatform: json["fcm_platform"]?.toString(),
      imei1: json["imei1"]?.toString(),
      imei2: json["imei2"]?.toString(),
      serialNumber: json["serial_number"]?.toString(),
      macAddress: json["mac_address"]?.toString(),
      androidVersion: json["android_version"]?.toString(),
      sdkVersion: _toInt(json["sdk_version"]),
      manufacturer: json["manufacturer"]?.toString(),
      model: json["model"]?.toString(),
      deviceName: json["device_name"]?.toString(),
      status: json["status"]?.toString(),
      complianceState: json["compliance_state"]?.toString(),
      setupStatus: json["setup_status"]?.toString(),
      setupProgress: _toInt(json["setup_progress"]),
      currentSetupStep: json["current_setup_step"]?.toString(),
      downloadPercentage: _toInt(json["download_percentage"]),
      installPercentage: _toInt(json["install_percentage"]),
      setupError: json["setup_error"]?.toString(),
      networkType: json["network_type"]?.toString(),
      isWifiConnected: json["is_wifi_connected"] == true,
      isMobileHotspot: json["is_mobile_hotspot"] == true,
      networkSpeedCategory: json["network_speed_category"]?.toString(),
      adaptiveTimeout: _toInt(json["adaptive_timeout"]),
      networkSwitchCount: _toInt(json["network_switch_count"]),
      batteryLevel: _toInt(json["battery_level"]),
      playProtectStatus: json["play_protect_status"]?.toString(),
      playProtectDisabled: json["play_protect_disabled"] == true,
      installationMethod: json["installation_method"]?.toString(),
      appliedPolicies: json["applied_policies"] as List? ?? [],
      lastCheckIn: json["last_check_in"]?.toString(),
      lastHeartbeat: json["last_heartbeat"]?.toString(),
      enrolledAt: json["enrolled_at"]?.toString(),
      errorCount: _toInt(json["error_count"]),
      retryCount: _toInt(json["retry_count"]),
      maxRetries: _toInt(json["max_retries"]),
      factoryResetLocked: json["factory_reset_locked"] == true,
      launcherMode: json["launcher_mode"] == true,
      companyName: json["company_name"]?.toString(),
      tags: json["tags"] as List? ?? [],
      installedApps: json["installed_apps"] as List? ?? [],
      createdAt: json["createdAt"]?.toString(),
      updatedAt: json["updatedAt"]?.toString(),
    );
  }
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}