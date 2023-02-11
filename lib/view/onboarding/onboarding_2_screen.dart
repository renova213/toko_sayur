import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/style.dart';
import '../../common/util/navigator_slide_helper.dart';
import '../login/login_screen.dart';
import '../widgets/button_widget.dart';
import 'onboarding_3_screen.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

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
              Image.asset('assets/images/onboarding_2.png',
                  width: double.maxFinite, height: 253.h),
              SizedBox(height: 16.h),
              Text('Pengiriman Di Jalan',
                  style: AppFont.subtitle, textAlign: TextAlign.center),
              SizedBox(height: 12.h),
              Text(
                'Dapatkan pesanan anda dengan pengiriman cepat',
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
                        child: const Onboarding3Screen(),
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
