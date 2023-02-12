import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/util/state_management_helper.dart';
import 'package:toko_sayur/view/onboarding/splash_screen.dart';

import 'common/style/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => StateManagementHelper.providers(
        MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: AppColor.primaryColor),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
