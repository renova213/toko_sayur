import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/util/navigator_slide_helper.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';

import '../../../common/style/style.dart';
import '../login/login_screen.dart';
import 'onboarding_2_screen.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        NavigatorSlideHelper(
                            child: const LoginScreen(),
                            direction: AxisDirection.left),
                        (route) => false);
                  },
                  child: Text(
                    'Skip',
                    style: AppFont.largeText.copyWith(
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
              Image.asset('assets/images/onboarding_1.png',
                  width: double.maxFinite, height: 253.h),
              SizedBox(height: 16.h),
              Text('UD MANDIRI SHOPING',
                  style: AppFont.subtitle, textAlign: TextAlign.center),
              SizedBox(height: 12.h),
              Text(
                'Jelajahi sayuran terbaik & pesan',
                textAlign: TextAlign.center,
                style: AppFont.largeText.copyWith(
                  color: const Color(0xFF686161),
                ),
              ),
              SizedBox(height: 40.h),
              ButtonWidget(
                height: 45,
                width: 110,
                text: 'Next',
                onTap: () {
                  Navigator.of(context).push(
                    NavigatorSlideHelper(
                        child: const Onboarding2Screen(),
                        direction: AxisDirection.left),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
