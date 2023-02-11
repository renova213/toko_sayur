import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/style.dart';
import '../../common/util/navigator_slide_helper.dart';
import '../login/login_screen.dart';
import '../widgets/button_widget.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/onboarding_3.png',
                  width: double.maxFinite, height: 253.h),
              SizedBox(height: 16.h),
              Text('Pengiriman Tiba',
                  style: AppFont.subtitle, textAlign: TextAlign.center),
              SizedBox(height: 12.h),
              Text(
                'Pesanan sudah sampai di tempat anda',
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
                  Navigator.of(context).pushAndRemoveUntil(
                      NavigatorSlideHelper(
                          child: const LoginScreen(),
                          direction: AxisDirection.left),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
