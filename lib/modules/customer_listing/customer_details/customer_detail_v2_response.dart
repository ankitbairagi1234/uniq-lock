import 'package:zlock_smart_finance/modules/customer_listing/device_model_response.dart';

class CustomerDetailV2Response {
  final bool success;
  final String role;
  final int count;
  final int enrolled;
  final int notEnrolled;
  final int total;
  final int totalPages;
  final int currentPage;
  final int limit;
  final List<CustomerDetailV2Item> data;

  CustomerDetailV2Response({
    required this.success,
    required this.role,
    required this.count,
    required this.enrolled,
    required this.notEnrolled,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.data,
  });

  factory CustomerDetailV2Response.fromJson(Map<String, dynamic> json) {
    return CustomerDetailV2Response(
      success: json["success"] == true,
      role: (json["role"] ?? "").toString(),
      count: _toInt(json["count"]),
      enrolled: _toInt(json["enrolled"]),
      notEnrolled: _toInt(json["not_enrolled"]),
      total: _toInt(json["total"]),
      totalPages: _toInt(json["totalPages"]),
      currentPage: _toInt(json["currentPage"]),
      limit: _toInt(json["limit"]),
      data: (json["data"] as List? ?? [])
          .map((e) => CustomerDetailV2Item.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class CustomerDetailV2Item {
  final String id;
  final String? userId;
  final String? profileImage;
  final String name;
  final String email;
  final String phone;
  final String? dob;
  final String? aadhaarNumber;
  final String? aadhaarFront;
  final String? aadhaarBack;
  final String? signature;
  final String imei1;
  final String? imei2;
  final String deviceType;
  final String? loanBy;
  final String? keyType;
  final String? retailerId;
  final String? brandId;
  final String? bankId;
  final String? author;
  final bool isLink;
  final bool isActive;
  final String kycStatus;
  final String? kycRejectionReason;
  final String? kycVerifiedAt;
  final CustomerDetailV2Emi? emi;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  // NEW
  final bool isEnrollment;
  final CustomerDeviceInfo? device;
  final KeyActions? keyActions;


  CustomerDetailV2Item({
    required this.id,
    required this.userId,
    required this.profileImage,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.aadhaarNumber,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.signature,
    required this.imei1,
    required this.imei2,
    required this.deviceType,
    required this.loanBy,
    required this.keyType,
    required this.retailerId,
    required this.brandId,
    required this.bankId,
    required this.author,
    required this.isLink,
    required this.isActive,
    required this.kycStatus,
    required this.kycRejectionReason,
    required this.kycVerifiedAt,
    required this.emi,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isEnrollment,
    required this.device,
    required this.keyActions,

  });

  factory CustomerDetailV2Item.fromJson(Map<String, dynamic> json) {
    return CustomerDetailV2Item(
      id: (json["_id"] ?? "").toString(),
      userId: json["userId"]?.toString(),
      profileImage: json["profileImage"]?.toString(),
      name: (json["name"] ?? "").toString(),
      email: (json["email"] ?? "").toString(),
      phone: (json["phone"] ?? "").toString(),
      dob: json["dob"]?.toString(),
      aadhaarNumber: json["aadhaarNumber"]?.toString(),
      aadhaarFront: json["aadhaarFront"]?.toString(),
      aadhaarBack: json["aadhaarBack"]?.toString(),
      signature: json["signature"]?.toString(),
      imei1: (json["imei1"] ?? "").toString(),
      imei2: json["imei2"]?.toString(),
      deviceType: (json["deviceType"] ?? "").toString(),
      loanBy: json["loanBy"]?.toString(),
      keyType: json["key_type"]?.toString(),
      retailerId: json["retailer_id"]?.toString(),
      brandId: json["brand_id"]?.toString(),
      bankId: json["bank_id"]?.toString(),
      author: json["author"]?.toString(),
      isLink: json["is_link"] == true,
      isActive: json["isActive"] == true,
      kycStatus: (json["kycStatus"] ?? "").toString(),
      kycRejectionReason: json["kycRejectionReason"]?.toString(),
      kycVerifiedAt: json["kycVerifiedAt"]?.toString(),
      emi: json["emi"] is Map<String, dynamic>
          ? CustomerDetailV2Emi.fromJson(Map<String, dynamic>.from(json["emi"]))
          : null,
      deletedAt: json["deleted_at"]?.toString(),
      createdAt: (json["createdAt"] ?? "").toString(),
      updatedAt: (json["updatedAt"] ?? "").toString(),
      isEnrollment: json["isEnrollment"] == true,
      device: json["device"] is Map<String, dynamic>
          ? CustomerDeviceInfo.fromJson(Map<String, dynamic>.from(json["device"]))
          : null,
      keyActions: json["keyActions"] != null
          ? KeyActions.fromJson(json["keyActions"])
          : null,
    );
  }
}

class KeyActions {
  final bool remove;

  KeyActions({
    required this.remove,
  });

  factory KeyActions.fromJson(Map<String, dynamic> json) {
    return KeyActions(
      remove: json["remove"] == true,
    );
  }
}
class CustomerDetailV2Emi {
  final num? totalAmount;
  final num? downPayment;
  final num? loanAmount;
  final num? interestRate;
  final num? emiAmount;
  final int? tenureMonths;
  final int? totalEmiPaid;
  final int? totalEmiRemaining;
  final String? startDate;
  final String? endDate;
  final String? nextDueDate;
  final String? bankId;
  final String? loanProvider;
  final String? loanAccountNumber;
  final List<dynamic> paymentHistory;
  final String? status;
  final bool isOverdue;
  final int overdueDays;
  final num overdueAmount;

  CustomerDetailV2Emi({
    required this.totalAmount,
    required this.downPayment,
    required this.loanAmount,
    required this.interestRate,
    required this.emiAmount,
    required this.tenureMonths,
    required this.totalEmiPaid,
    required this.totalEmiRemaining,
    required this.startDate,
    required this.endDate,
    required this.nextDueDate,
    required this.bankId,
    required this.loanProvider,
    required this.loanAccountNumber,
    required this.paymentHistory,
    required this.status,
    required this.isOverdue,
    required this.overdueDays,
    required this.overdueAmount,
  });

  factory CustomerDetailV2Emi.fromJson(Map<String, dynamic> json) {
    return CustomerDetailV2Emi(
      totalAmount: json["total_amount"] as num?,
      downPayment: json["down_payment"] as num?,
      loanAmount: json["loan_amount"] as num?,
      interestRate: json["interest_rate"] as num?,
      emiAmount: json["emi_amount"] as num?,
      tenureMonths: _toInt(json["tenure_months"]),
      totalEmiPaid: _toInt(json["total_emi_paid"]),
      totalEmiRemaining: _toInt(json["total_emi_remaining"]),
      startDate: json["start_date"]?.toString(),
      endDate: json["end_date"]?.toString(),
      nextDueDate: json["next_due_date"]?.toString(),
      bankId: json["bank_id"]?.toString(),
      loanProvider: json["loan_provider"]?.toString(),
      loanAccountNumber: json["loan_account_number"]?.toString(),
      paymentHistory: json["payment_history"] as List? ?? [],
      status: json["status"]?.toString(),
      isOverdue: json["is_overdue"] == true,
      overdueDays: _toInt(json["overdue_days"]),
      overdueAmount: (json["overdue_amount"] as num?) ?? 0,
    );
  }
}


int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}