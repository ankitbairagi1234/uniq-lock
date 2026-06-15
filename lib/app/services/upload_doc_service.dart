import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'package:zlock_smart_finance/app/services/retailer_api.dart';
import 'package:zlock_smart_finance/model/upload_doc_response.dart';

// class DocumentUploadService {
//   Future<String?> uploadPurchaseAgreementPdf(Uint8List pdfBytes) async {
//     try {
//       final fileName = "purchase_agreement_${DateTime.now().millisecondsSinceEpoch}.pdf";
//
//       final form = FormData.fromMap({
//         "image": MultipartFile.fromBytes(
//           pdfBytes,
//           filename: fileName,
//           contentType: DioMediaType("application", "pdf"),
//         ),
//       });
//
//       final res = await ApiClient.dio.put(
//         RetailerAPI.uploadIdPicture, //
//         data: form,
//         options: Options(contentType: "multipart/form-data"),
//       );
//
//       if (res.data is Map<String, dynamic>) {
//         final parsed = UploadDocResponse.fromJson(res.data as Map<String, dynamic>);
//         if (parsed.status == 200 && parsed.url.trim().isNotEmpty) {
//           return parsed.url.trim();
//         }
//         return null;
//       }
//
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ uploadPurchaseAgreementPdf Dio: ${e.response?.data}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ uploadPurchaseAgreementPdf error: $e");
//       return null;
//     }
//   }
// }
class DocumentUploadService {
  Future<String?> uploadPurchaseAgreementPdf(Uint8List pdfBytes) async {
    try {
      final fileName =
          "purchase_agreement_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final form = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          pdfBytes,
          filename: fileName,
          contentType: DioMediaType("application", "pdf"),
        ),
      });

      // ✅ Print exact URL (same as postman)
      debugPrint("🌐 UPLOAD URL => ${RetailerAPI.uploadIdPicture}");

      final res = await ApiClient.dio.put(
        RetailerAPI.uploadIdPicture, // ✅ full url
        data: form,
        options: Options(contentType: "multipart/form-data"),
      );

      debugPrint("✅ UPLOAD STATUS: ${res.statusCode}");
      debugPrint("✅ UPLOAD RESP: ${res.data}");

      if (res.data is Map<String, dynamic>) {
        final parsed = UploadDocResponse.fromJson(res.data as Map<String, dynamic>);
        final url = parsed.url.trim();
        if (parsed.status == 200 && url.isNotEmpty) {
          debugPrint("✅ CLOUDINARY URL => $url");
          return url;
        }
      }

      return null;
    } on DioException catch (e) {
      debugPrint("❌ uploadPurchaseAgreementPdf Dio: ${e.response?.statusCode}");
      debugPrint("❌ uploadPurchaseAgreementPdf Resp: ${e.response?.data}");
      return null;
    } catch (e) {
      debugPrint("❌ uploadPurchaseAgreementPdf error: $e");
      return null;
    }
  }
}
