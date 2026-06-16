// class UpdateEmiResponse {
//   final int status;
//   final String message;
//   final UpdateEmiData? data;
//
//   UpdateEmiResponse({
//     required this.status,
//     required this.message,
//     this.data,
//   });
//
//   factory UpdateEmiResponse.fromJson(Map<String, dynamic> json) {
//     return UpdateEmiResponse(
//       status: (json["status"] ?? 0) as int,
//       message: (json["message"] ?? "").toString(),
//       data: json["data"] == null ? null : UpdateEmiData.fromJson(json["data"]),
//     );
//   }
// }

class UpdateEmiResponse {
  final bool success;
  final String message;

  UpdateEmiResponse({
    required this.success,
    required this.message,
  });

  factory UpdateEmiResponse.fromJson(
      Map<String, dynamic> json) {
    return UpdateEmiResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
class UpdateEmiData {
  final String emiId;
  final String status;
  final String paymentMode;
  final String paidAt;
  final double overdueAmount;

  UpdateEmiData({
    required this.emiId,
    required this.status,
    required this.paymentMode,
    required this.paidAt,
    required this.overdueAmount,
  });

  factory UpdateEmiData.fromJson(Map<String, dynamic> json) {
    double _d(v) => (v is num) ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

    return UpdateEmiData(
      emiId: (json["emiId"] ?? "").toString(),
      status: (json["status"] ?? "").toString(),
      paymentMode: (json["paymentMode"] ?? "").toString(),
      paidAt: (json["paidAt"] ?? "").toString(),
      overdueAmount: _d(json["overdueAmount"]),
    );
  }
}

class EmiScheduleResponse {
  final bool success;
  final EmiScheduleData? data;

  EmiScheduleResponse({
    required this.success,
    this.data,
  });

  factory EmiScheduleResponse.fromJson(Map<String, dynamic> json) {
    return EmiScheduleResponse(
      success: json["success"] ?? false,
      data: json["data"] == null
          ? null
          : EmiScheduleData.fromJson(json["data"]),
    );
  }
}

class EmiScheduleData {
  final List<EmiScheduleItem> schedule;

  EmiScheduleData({
    required this.schedule,
  });

  factory EmiScheduleData.fromJson(Map<String, dynamic> json) {
    return EmiScheduleData(
      schedule: (json["schedule"] as List? ?? [])
          .map((e) => EmiScheduleItem.fromJson(e))
          .toList(),
    );
  }
}

class EmiScheduleItem {
  final int emiNumber;
  final double emiAmount;
  final String status;
  final String? dueDate;
  final String? paidDate;

  EmiScheduleItem({
    required this.emiNumber,
    required this.emiAmount,
    required this.status,
    this.dueDate,
    this.paidDate,
  });

  factory EmiScheduleItem.fromJson(Map<String, dynamic> json) {
    return EmiScheduleItem(
      emiNumber: json["emi_number"] ?? 0,
      emiAmount: (json["emi_amount"] ?? 0).toDouble(),
      status: (json["status"] ?? "").toString(),
      dueDate: json["due_date"],
      paidDate: json["paid_date"],
    );
  }
}