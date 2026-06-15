import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'app/routes/app_pages.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//
//
//   // ✅ if token stored, attach once also
//   ApiClient.attachToken();
//   runApp(const ZLockApp());
// }
//
// class ZLockApp extends StatelessWidget {
//   const ZLockApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "LockPe Pro",
//       initialRoute: AppRoutes.SPLASH,
//       getPages: AppPages.routes,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zlock_smart_finance/app/routes/app_routes.dart';
import 'package:zlock_smart_finance/app/services/dio_client.dart';
import 'app/routes/app_pages.dart';

// 👇 ADD THIS IMPORT
import 'enter_pin_page.dart'; // jahan tumne EnterPinPage rakha hai
import 'app/services/mpin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  /// ✅ attach token
  ApiClient.attachToken();

  /// 🔥 WRAP APP (ONLY CHANGE)
  runApp(
    const ZLockApp(),
  );
}

class ZLockApp extends StatelessWidget {
  const ZLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "New MF",
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}