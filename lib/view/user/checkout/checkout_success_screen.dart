import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/style/style.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';

import '../../../common/util/navigator_fade_helper.dart';
import '../botnavbar_user.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32.r),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Image.asset('assets/images/success.png',
                      width: 200.w, height: 200.h),
                  SizedBox(height: 18.h),
                  Text('Order Successfully', style: AppFont.headline5),
                  SizedBox(height: 62.h),
                  Text('Terimakasih sudah order', style: AppFont.largeText),
                  SizedBox(height: 8.h),
                  Text('Orderan kamu akan kami siapkan',
                      style: AppFont.largeText),
                  SizedBox(height: 145.h),
                  ButtonWidget(
                    height: 71.h,
                    width: double.maxFinite,
                    text: 'Kembali',
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          NavigatorFadeHelper(child: const BotNavBarUser()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
