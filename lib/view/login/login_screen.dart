import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view/widgets/custom_field.dart';
import 'package:toko_sayur/view/widgets/disable_field.dart';

import '../../common/style/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png',
                      width: 108.w, height: 89.h),
                  SizedBox(height: 11.h),
                  Text('Log In Continue!', style: AppFont.headline5),
                  SizedBox(height: 47.h),
                  _formField(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                        style: AppFont.mediumText
                            .copyWith(color: AppColor.thirdTextColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  ButtonWidget(
                      height: 50,
                      width: double.maxFinite,
                      text: 'Login',
                      onTap: () {}),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppFont.largeText.copyWith(
                          color: const Color(0xFF686161),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Register", style: AppFont.subtitle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _formField() {
    return Column(
      children: [
        DisableField(
            hintText: 'Login With Facebook',
            width: double.maxFinite,
            onTap: () {}),
        SizedBox(height: 16.h),
        DisableField(
            hintText: 'Login With Google',
            width: double.maxFinite,
            onTap: () {}),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 1,
              child: Divider(color: Colors.black),
            ),
            SizedBox(width: 16.w),
            Text('OR', style: AppFont.largeText),
            SizedBox(width: 16.w),
            const Expanded(
              flex: 1,
              child: Divider(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        CustomField(
          controller: TextEditingController(),
          hintText: 'Email',
          icon: const Icon(Icons.mail),
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomField(
            controller: TextEditingController(),
            hintText: 'Password',
            obscureText: true,
            icon: const Icon(Icons.lock)),
      ],
    );
  }
}
