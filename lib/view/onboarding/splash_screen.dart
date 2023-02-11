import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/view/onboarding/onboarding_1_screen.dart';

import '../../common/style/style.dart';
import '../../common/util/navigator_fade_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AssetImage? assetImage;
  startTime() async {
    await Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        NavigatorFadeHelper(
          child: const Onboarding1Screen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assetImage = const AssetImage('assets/images/logo.png');
    Future.microtask(() {});
    startTime();
  }

  @override
  void didChangeDependencies() {
    precacheImage(assetImage!, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Toko Sayur',
                    style: AppFont.headline4
                        .copyWith(color: AppColor.secondaryTextColor)),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text('UD MANDIRI',
                    style: AppFont.headline4
                        .copyWith(color: AppColor.secondaryTextColor)),
              ),
              SizedBox(height: 35.h),
              Image.asset('assets/images/logo.png',
                  width: 267.w, height: 192.h),
            ],
          ),
        ),
      ),
    );
  }
}
