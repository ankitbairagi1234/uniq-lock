import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';

// class NewKeyApiService {
//   Future<CommonResponse> addNewKey({
//     required AddKeyRequest request,
//     required File productImageFile,
//     required List<int> signaturePngBytes,
//   }) async {
//     try {
//       debugPrint("✅ ADDKEY HIT: ${RetailerAPI.addNewKey}");
//       debugPrint("✅ ADDKEY JSON: ${request.toJson()}");
//       debugPrint("✅ ADDKEY HEADERS: ${ApiClient.dio.options.headers}");
//       debugPrint("✅ ADDKEY IMAGE: ${productImageFile.path} (${productImageFile.existsSync()})");
//       debugPrint("✅ ADDKEY SIGN bytes: ${signaturePngBytes.length}");
//
//
//       final form = FormData.fromMap({
//         ...request.toJson(),
//
//         // ✅ EXACT KEYS (Postman)
//         "productImages": await MultipartFile.fromFile(
//           productImageFile.path,
//           filename: productImageFile.path.split('/').last,
//         ),
//         "signature": MultipartFile.fromBytes(
//           signaturePngBytes,
//           filename: "signature.png",
//           contentType: DioMediaType.parse("image/png"),
//         ),
//       });
//
//       // optional: print fields
//       for (final f in form.fields) {
//         debugPrint("FIELD => ${f.key}: ${f.value}");
//       }
//       for (final f in form.files) {
//         debugPrint("FILE  => ${f.key}: ${f.value.filename}");
//       }
//
//       // ✅ Use ApiClient.dio (token already inside)
//       final res = await ApiClient.dio.post(
//         RetailerAPI.addNewKey,
//         data: form,
//         options: Options(contentType: "multipart/form-data"),
//       );
//
//       debugPrint("✅ ADDKEY STATUS: ${res.statusCode}");
//       debugPrint("✅ ADDKEY RESPONSE: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return CommonResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return CommonResponse(status: res.statusCode ?? 0, message: "Invalid server response");
//     } on DioException catch (e) {
//       final serverMsg = (e.response?.data is Map)
//           ? (e.response?.data["message"] ?? e.response?.data["msg"] ?? "").toString()
//           : "";
//
//       debugPrint("❌ ADDKEY STATUS: ${e.response?.statusCode}");
//       debugPrint("❌ ADDKEY RESP: ${e.response?.data}");
//
//       return CommonResponse(
//         status: e.response?.statusCode ?? 0,
//         message: serverMsg.isNotEmpty ? serverMsg : "Add key failed. Please try again.",
//       );
//     } catch (e) {
//       debugPrint("❌ ADDKEY ERROR: $e");
//       return CommonResponse(status: 0, message: "Something went wrong");
//     }
//   }
// }

import 'package:zlock_smart_finance/modules/retailer/dashboard/dashboard_retailer.dart';

import '../../model/common_response.dart';

// class NewKeyApiService {
//   Future<CommonResponse> customerAdd({
//     required NewKeyEntry entry,
//     required String name,
//     required String phone,
//     required String email,
//     required String imei1,
//
//     File? profileImg,        // customerProductImageFile
//     File? aadhaarFront,
//     File? aadhaarBack,
//     required List<int> signaturePngBytes,
//
//     Map<String, dynamic>? emi, // optional
//   }) async {
//     try {
//       final map = _mapEntry(entry);
//
//       final form = FormData.fromMap({
//         "name": name.trim(),
//         "phone": phone.trim(),
//         "email": email.trim(),
//         "imei1": imei1.trim(),
//         "deviceType": map["deviceType"], // new/running/iPhone
//         "key_type": map["key_type"],     // 1/2/3
//
//         // ✅ emi -> send as raw json string (multipart best practice)
//         if (emi != null) "emi": emi,
//       });
//
//       // ✅ FILES (only add if present)
//       if (profileImg != null) {
//         form.files.add(MapEntry(
//           "profileImg",
//           await MultipartFile.fromFile(
//             profileImg.path,
//             filename: profileImg.path.split('/').last,
//           ),
//         ));
//       }
//
//       if (aadhaarFront != null) {
//         form.files.add(MapEntry(
//           "aadhaarFront",
//           await MultipartFile.fromFile(
//             aadhaarFront.path,
//             filename: aadhaarFront.path.split('/').last,
//           ),
//         ));
//       }
//
//       if (aadhaarBack != null) {
//         form.files.add(MapEntry(
//           "aadhaarBack",
//           await MultipartFile.fromFile(
//             aadhaarBack.path,
//             filename: aadhaarBack.path.split('/').last,
//           ),
//         ));
//       }
//
//       // ✅ signature bytes -> multipart file
//       form.files.add(MapEntry(
//         "signature",
//         MultipartFile.fromBytes(
//           signaturePngBytes,
//           filename: "signature.png",
//           contentType: MediaType("image", "png"),
//         ),
//       ));
//
//       // ✅ DEBUG PRINT (fields + files)
//       debugPrint("✅ CUSTOMER ADD HIT: ${RetailerAPI.customerAdd}");
//       for (final f in form.fields) {
//         debugPrint("FIELD => ${f.key}: ${f.value}");
//       }
//       for (final f in form.files) {
//         debugPrint("FILE  => ${f.key}: ${f.value.filename}");
//       }
//
//       final res = await ApiClient.dio.post(
//         RetailerAPI.customerAdd,
//         data: form,
//         options: Options(contentType: "multipart/form-data"),
//       );
//
//       debugPrint("✅ CUSTOMER ADD STATUS: ${res.statusCode}");
//       debugPrint("✅ CUSTOMER ADD RESP: ${res.data}");
//
//       if (res.data is Map<String, dynamic>) {
//         return CommonResponse.fromJson(res.data as Map<String, dynamic>);
//       }
//       return CommonResponse(status: 0, successFlag: false, message: "Invalid server response");
//     } on DioException catch (e) {
//       debugPrint("❌ CUSTOMER ADD ERROR: ${e.response?.statusCode} ${e.response?.data}");
//       final msg = (e.response?.data is Map)
//           ? ((e.response?.data["message"] ?? "Request failed").toString())
//           : "Request failed";
//       return CommonResponse(status: e.response?.statusCode ?? 0, successFlag: false, message: msg);
//     } catch (e) {
//       debugPrint("❌ CUSTOMER ADD UNKNOWN ERROR: $e");
//       return CommonResponse(status: 0, successFlag: false, message: "Something went wrong");
//     }
//   }
//
//   Map<String, String> _mapEntry(NewKeyEntry entry) {
//     switch (entry) {
//       case NewKeyEntry.android:
//         return {"deviceType": "new", "key_type": "1"};
//       case NewKeyEntry.running:
//         return {"deviceType": "running", "key_type": "2"};
//       case NewKeyEntry.iphone:
//         return {"deviceType": "iPhone", "key_type": "3"};
//     }
//   }
// }

// class NewKeyApiService {
//   // Future<CommonResponse> customerAdd({
//   //   required NewKeyEntry entry,
//   //   required String name,
//   //   required String phone,
//   //   required String email,
//   //   required String imei1,
//   //   File? profileImg,
//   //   File? aadhaarFront,
//   //   File? aadhaarBack,
//   //   required List<int> signaturePngBytes,
//   //   Map<String, dynamic>? emi,
//   // }) async {
//   //   try {
//   //     final map = _mapEntry(entry);
//   //
//   //     final form = FormData();
//   //
//   //     /// 🔥 CRITICAL → Use explicit string values
//   //     form.fields.add(MapEntry("name", name.trim()));
//   //     form.fields.add(MapEntry("phone", phone.trim()));
//   //     form.fields.add(MapEntry("email", email.trim()));
//   //     form.fields.add(MapEntry("imei1", imei1.trim()));
//   //     form.fields.add(MapEntry("deviceType", map["deviceType"]!));
//   //     form.fields.add(MapEntry("key_type", map["key_type"]!));
//   //
//   //     /// 🔥 EMI must be JSON string
//   //     if (emi != null && emi.isNotEmpty) {
//   //       form.fields.add(MapEntry("emi", jsonEncode(emi)));
//   //     }
//   //
//   //     /// FILES
//   //     if (profileImg != null) {
//   //       form.files.add(MapEntry(
//   //         "profileImg",
//   //         await MultipartFile.fromFile(profileImg.path),
//   //       ));
//   //     }
//   //
//   //     if (aadhaarFront != null) {
//   //       form.files.add(MapEntry(
//   //         "aadhaarFront",
//   //         await MultipartFile.fromFile(aadhaarFront.path),
//   //       ));
//   //     }
//   //
//   //     if (aadhaarBack != null) {
//   //       form.files.add(MapEntry(
//   //         "aadhaarBack",
//   //         await MultipartFile.fromFile(aadhaarBack.path),
//   //       ));
//   //     }
//   //
//   //     form.files.add(MapEntry(
//   //       "signature",
//   //       MultipartFile.fromBytes(signaturePngBytes, filename: "signature.png"),
//   //     ));
//   //
//   //     /// DEBUG
//   //     print("====== FINAL FIELDS ======");
//   //     for (var f in form.fields) {
//   //       print("${f.key} => ${f.value}");
//   //     }
//   //
//   //     print("====== FINAL FILES ======");
//   //     for (var f in form.files) {
//   //       print("${f.key} => ${f.value.filename}");
//   //     }
//   //
//   //     /// 🔥 VERY IMPORTANT
//   //     /// Completely override headers
//   //     final res = await ApiClient.dio.post(
//   //       RetailerAPI.customerAdd,
//   //       data: form,
//   //       options: Options(
//   //         headers: {
//   //           "Accept": "application/json",
//   //         },
//   //         contentType: "multipart/form-data",
//   //       ),
//   //     );
//   //
//   //     print("STATUS => ${res.statusCode}");
//   //     print("RESPONSE => ${res.data}");
//   //
//   //     return CommonResponse.fromJson(res.data);
//   //   } on DioException catch (e) {
//   //     print("ERROR => ${e.response?.data}");
//   //     return CommonResponse(
//   //       status: e.response?.statusCode ?? 0,
//   //       successFlag: false,
//   //       message: "",
//   //     );
//   //   }
//   // }
//
//   Future<CustomerAddResponse> customerAddMultipart({
//     required NewKeyEntry entry,
//     required String name,
//     required String phone,
//     required String email,
//     required String imei1,
//
//     File? profileImg,
//     File? aadhaarFront,
//     File? aadhaarBack,
//     required List<int> signaturePngBytes,
//
//     Map<String, dynamic>? emi,
//   }) async {
//     final map = _mapEntry(entry);
//
//     final form = FormData();
//
//     form.fields.add(MapEntry("name", name.trim()));
//     form.fields.add(MapEntry("phone", phone.trim()));
//     form.fields.add(MapEntry("email", email.trim()));
//     form.fields.add(MapEntry("imei1", imei1.trim()));
//     form.fields.add(MapEntry("deviceType", map["deviceType"]!));
//     form.fields.add(MapEntry("key_type", map["key_type"]!));
//
//     // ✅ send emi only if not null
//     if (emi != null && emi.isNotEmpty) {
//       form.fields.add(MapEntry("emi", jsonEncode(emi))); // if backend parses JSON
//     }
//
//     if (profileImg != null) {
//       form.files.add(MapEntry(
//         "profileImg",
//         await MultipartFile.fromFile(profileImg.path,
//             filename: profileImg.path.split('/').last),
//       ));
//     }
//
//     if (aadhaarFront != null) {
//       form.files.add(MapEntry(
//         "aadhaarFront",
//         await MultipartFile.fromFile(aadhaarFront.path,
//             filename: aadhaarFront.path.split('/').last),
//       ));
//     }
//
//     if (aadhaarBack != null) {
//       form.files.add(MapEntry(
//         "aadhaarBack",
//         await MultipartFile.fromFile(aadhaarBack.path,
//             filename: aadhaarBack.path.split('/').last),
//       ));
//     }
//
//     form.files.add(MapEntry(
//       "signature",
//       MultipartFile.fromBytes(signaturePngBytes,
//           filename: "signature.png",
//           contentType: DioMediaType.parse("image/png")),
//     ));
//
//     debugPrint("✅ CUSTOMER ADD HIT: ${RetailerAPI.customerAdd}");
//     for (final f in form.fields) debugPrint("FIELD => ${f.key}: ${f.value}");
//     for (final f in form.files) debugPrint("FILE  => ${f.key}: ${f.value.filename}");
//
//     // ✅ IMPORTANT: don’t throw on 400, read server message
//     final res = await ApiClient.dio.post(
//       RetailerAPI.customerAdd,
//       data: form,
//       options: Options(
//         contentType: "multipart/form-data",
//         validateStatus: (_) => true,
//       ),
//     );
//
//     debugPrint("✅ CUSTOMER ADD STATUS: ${res.statusCode}");
//     debugPrint("✅ CUSTOMER ADD RESP: ${res.data}");
//
//     if (res.data is Map) {
//       return CustomerAddResponse.fromJson(Map<String, dynamic>.from(res.data));
//     }
//     return CustomerAddResponse(success: false, message: "Invalid server response");
//   }
//   Map<String, String> _mapEntry(NewKeyEntry entry) {
//     switch (entry) {
//       case NewKeyEntry.android:
//         return {"deviceType": "new", "key_type": "1"};
//       case NewKeyEntry.running:
//         return {"deviceType": "running", "key_type": "2"};
//       case NewKeyEntry.iphone:
//         return {"deviceType": "iPhone", "key_type": "3"};
//     }
//   }
//
// }
// class CustomerAddResponse {
//   final bool success;
//   final String message;
//   final dynamic data;
//
//   CustomerAddResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   factory CustomerAddResponse.fromJson(Map<String, dynamic> json) {
//     return CustomerAddResponse(
//       success: json["success"] == true,
//       message: (json["message"] ?? "").toString(),
//       data: json["data"],
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType; // if you use multipart elsewhere

// class NewKeyApiService {
//   /// ✅ RAW JSON (Postman style) - recommended
//   Future<CustomerAddResponse> customerAddRaw({
//     required NewKeyEntry entry,
//     required String name,
//     required String phone,
//     required String email,
//     required String imei1,
//
//     /// Raw JSON me file string jati hai:
//     /// - "" (as postman)
//     /// - OR uploaded URL
//     /// - OR base64 (if backend supports)
//     String profileImg = "",
//     String aadhaarFront = "",
//     String aadhaarBack = "",
//     String signature = "",
//
//     Map<String, dynamic>? emi,
//   }) async {
//     try {
//       final map = _mapEntry(entry);
//
//       final body = <String, dynamic>{
//         "name": name.trim(),
//         "phone": phone.trim(),
//         "email": email.trim(),
//         "imei1": imei1.trim(),
//         "deviceType": map["deviceType"], // new/running/iPhone
//         "key_type": map["key_type"],     // 1/2/3
//
//         // ✅ file strings
//         "profileImg": profileImg,
//         "aadhaarFront": aadhaarFront,
//         "aadhaarBack": aadhaarBack,
//         "signature": signature,
//
//         // ✅ emi object
//         if (emi != null && emi.isNotEmpty) "emi": emi,
//       };
//
//       debugPrint("✅ CUSTOMER ADD RAW HIT: ${RetailerAPI.customerAdd}");
//       debugPrint("✅ CUSTOMER ADD RAW BODY: ${jsonEncode(body)}");
//
//       final res = await ApiClient.dio.post(
//         RetailerAPI.customerAdd,
//         data: body, // ✅ RAW JSON
//         options: Options(
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//           validateStatus: (_) => true,
//         ),
//       );
//
//       debugPrint("✅ CUSTOMER ADD RAW STATUS: ${res.statusCode}");
//       debugPrint("✅ CUSTOMER ADD RAW RESP: ${res.data}");
//
//       if (res.data is Map) {
//         return CustomerAddResponse.fromJson(Map<String, dynamic>.from(res.data));
//       }
//       return CustomerAddResponse(success: false, message: "Invalid server response");
//     } on DioException catch (e) {
//       final data = e.response?.data;
//       final msg = (data is Map)
//           ? ((data["message"] ?? "Request failed").toString())
//           : "Request failed";
//       return CustomerAddResponse(success: false, message: msg);
//     } catch (e) {
//       debugPrint("❌ CUSTOMER ADD RAW ERROR: $e");
//       return CustomerAddResponse(success: false, message: "Something went wrong");
//     }
//   }
//
//   /// (Optional) keep this only if backend fixes multipart parsing later
//   Future<CustomerAddResponse> customerAddMultipart({
//     required NewKeyEntry entry,
//     required String name,
//     required String phone,
//     required String email,
//     required String imei1,
//     File? profileImg,
//     File? aadhaarFront,
//     File? aadhaarBack,
//     required List<int> signaturePngBytes,
//     Map<String, dynamic>? emi,
//   }) async {
//     final map = _mapEntry(entry);
//
//     final form = FormData();
//
//     form.fields.add(MapEntry("name", name.trim()));
//     form.fields.add(MapEntry("phone", phone.trim()));
//     form.fields.add(MapEntry("email", email.trim()));
//     form.fields.add(MapEntry("imei1", imei1.trim()));
//     form.fields.add(MapEntry("deviceType", map["deviceType"]!));
//     form.fields.add(MapEntry("key_type", map["key_type"]!));
//
//     if (emi != null && emi.isNotEmpty) {
//       form.fields.add(MapEntry("emi", jsonEncode(emi)));
//     }
//
//     if (profileImg != null) {
//       form.files.add(MapEntry(
//         "profileImg",
//         await MultipartFile.fromFile(profileImg.path,
//             filename: profileImg.path.split('/').last),
//       ));
//     }
//
//     if (aadhaarFront != null) {
//       form.files.add(MapEntry(
//         "aadhaarFront",
//         await MultipartFile.fromFile(aadhaarFront.path,
//             filename: aadhaarFront.path.split('/').last),
//       ));
//     }
//
//     if (aadhaarBack != null) {
//       form.files.add(MapEntry(
//         "aadhaarBack",
//         await MultipartFile.fromFile(aadhaarBack.path,
//             filename: aadhaarBack.path.split('/').last),
//       ));
//     }
//
//     form.files.add(MapEntry(
//       "signature",
//       MultipartFile.fromBytes(
//         signaturePngBytes,
//         filename: "signature.png",
//         contentType: DioMediaType.parse("image/png"),
//       ),
//     ));
//
//     debugPrint("✅ CUSTOMER ADD MULTIPART HIT: ${RetailerAPI.customerAdd}");
//     for (final f in form.fields) debugPrint("FIELD => ${f.key}: ${f.value}");
//     for (final f in form.files) debugPrint("FILE  => ${f.key}: ${f.value.filename}");
//
//     final res = await ApiClient.dio.post(
//       RetailerAPI.customerAdd,
//       data: form,
//       options: Options(
//         contentType: "multipart/form-data",
//         validateStatus: (_) => true,
//       ),
//     );
//
//     debugPrint("✅ CUSTOMER ADD MULTIPART STATUS: ${res.statusCode}");
//     debugPrint("✅ CUSTOMER ADD MULTIPART RESP: ${res.data}");
//
//     if (res.data is Map) {
//       return CustomerAddResponse.fromJson(Map<String, dynamic>.from(res.data));
//     }
//     return CustomerAddResponse(success: false, message: "Invalid server response");
//   }
//
//   Map<String, String> _mapEntry(NewKeyEntry entry) {
//     switch (entry) {
//       case NewKeyEntry.android:
//         return {"deviceType": "new", "key_type": "1"};
//       case NewKeyEntry.running:
//         return {"deviceType": "running", "key_type": "2"};
//       case NewKeyEntry.iphone:
//         return {"deviceType": "iPhone", "key_type": "3"};
//     }
//   }
// }

import 'package:http_parser/http_parser.dart';

class NewKeyApiService {
  Future<CustomerAddResponse> customerAddMultipart({
    required NewKeyEntry entry,
    required String name,
    required String phone,
    required String email,
    required String imei1,
    String? imei2,
    String? loanBy,

    File? profileImage,   // ✅ KEY: profileImage
    File? aadhaarFront,   // ✅ KEY: aadhaarFront
    File? aadhaarBack,    // ✅ KEY: aadhaarBack
    required List<int> signaturePngBytes, // ✅ KEY: signature (File)

    // ✅ EMI flat fields (Postman style)
    Map<String, dynamic>? emiFlat,
  }) async {
    try {
      final map = _mapEntry(entry);

      final form = FormData();

      // ✅ TEXT FIELDS
      form.fields.add(MapEntry("name", name.trim()));
      form.fields.add(MapEntry("phone", phone.trim()));
      form.fields.add(MapEntry("email", email.trim()));
      form.fields.add(MapEntry("imei1", imei1.trim()));

      if (imei2 != null && imei2.trim().isNotEmpty) {
        form.fields.add(MapEntry("imei2", imei2.trim()));
      }
      if (loanBy != null && loanBy.trim().isNotEmpty) {
        form.fields.add(MapEntry("loanBy", loanBy.trim()));
      }


      // ✅ these exist in your backend earlier (keep, no impact)
      form.fields.add(MapEntry("deviceType", map["deviceType"]!)); // new/running/iPhone
      form.fields.add(MapEntry("key_type", map["key_type"]!));     // 1/2/3

      // ✅ EMI FLAT (only when provided)
      if (emiFlat != null && emiFlat.isNotEmpty) {
        for (final e in emiFlat.entries) {
          final v = e.value;
          if (v == null) continue;
          final s = v.toString().trim();
          if (s.isEmpty) continue;
          form.fields.add(MapEntry(e.key, s)); // send as TEXT like Postman
        }
      }

      // ✅ FILES
      if (profileImage != null && profileImage.existsSync()) {
        form.files.add(MapEntry(
          "profileImage",
          await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
        ));
      }

      if (aadhaarFront != null && aadhaarFront.existsSync()) {
        form.files.add(MapEntry(
          "aadhaarFront",
          await MultipartFile.fromFile(
            aadhaarFront.path,
            filename: aadhaarFront.path.split('/').last,
          ),
        ));
      }

      if (aadhaarBack != null && aadhaarBack.existsSync()) {
        form.files.add(MapEntry(
          "aadhaarBack",
          await MultipartFile.fromFile(
            aadhaarBack.path,
            filename: aadhaarBack.path.split('/').last,
          ),
        ));
      }

      // ✅ signature as FILE (not base64)
      form.files.add(MapEntry(
        "signature",
        MultipartFile.fromBytes(
          signaturePngBytes,
          filename: "signature.png",
          contentType: MediaType("image", "png"),
        ),
      ));

      // ✅ DEBUG
      debugPrint("✅ CUSTOMER ADD MULTIPART HIT: ${RetailerAPI.customerAdd}");
      for (final f in form.fields) debugPrint("FIELD => ${f.key}: ${f.value}");
      for (final f in form.files) debugPrint("FILE  => ${f.key}: ${f.value.filename}");

      final res = await ApiClient.dio.post(
        RetailerAPI.customerAdd,
        data: form,
        options: Options(
          contentType: "multipart/form-data",
          validateStatus: (_) => true, // read msg even on 400
        ),
      );

      debugPrint("✅ CUSTOMER ADD MULTIPART STATUS: ${res.statusCode}");
      debugPrint("✅ CUSTOMER ADD MULTIPART RESP: ${res.data}");

      if (res.data is Map) {
        return CustomerAddResponse.fromJson(Map<String, dynamic>.from(res.data));
      }
      return CustomerAddResponse(success: false, message: "Invalid server response");
    } catch (e) {
      debugPrint("❌ CUSTOMER ADD MULTIPART ERROR: $e");
      return CustomerAddResponse(success: false, message: "Something went wrong");
    }
  }

  Map<String, String> _mapEntry(NewKeyEntry entry) {
    switch (entry) {
      case NewKeyEntry.android:
        return {"deviceType": "new", "key_type": "1"};
      case NewKeyEntry.running:
        return {"deviceType": "running", "key_type": "2"};
      case NewKeyEntry.iphone:
        return {"deviceType": "iPhone", "key_type": "3"};
    }
  }
}
class CustomerAddResponse {
  final bool success;
  final String message;
  final dynamic data;

  CustomerAddResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CustomerAddResponse.fromJson(Map<String, dynamic> json) {
    return CustomerAddResponse(
      success: json["success"] == true,
      message: (json["message"] ?? "").toString(),
      data: json["data"],
    );
  }
}