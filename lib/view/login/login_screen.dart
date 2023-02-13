import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/view/admin/botnavbar_admin.dart';
import 'package:toko_sayur/view/forgot_password/forgot_password_screen.dart';
import 'package:toko_sayur/view/register/register_screen.dart';
import 'package:toko_sayur/view/user/home/user_home_screen.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view/widgets/custom_field.dart';
import 'package:toko_sayur/view/widgets/disable_field.dart';
import 'package:toko_sayur/view_model/login_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../common/style/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

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
                      onPressed: () {
                        Navigator.of(context).push(
                          NavigatorFadeHelper(
                              child: const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style: AppFont.mediumText
                            .copyWith(color: AppColor.thirdTextColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Consumer<LoginViewModel>(
                    builder: (context, login, _) => Consumer<UserViewModel>(
                      builder: (context, user, _) => ButtonWidget(
                        height: 50,
                        width: double.maxFinite,
                        text: 'Login',
                        onTap: () async {
                          try {
                            await login
                                .login(
                                  LoginModel(
                                      email: _emailController.text,
                                      password: _passwordController.text),
                                )
                                .then(
                                  (_) async =>
                                      await user.getUser(login.user.email!),
                                )
                                .then(
                                  (_) => Fluttertoast.showToast(
                                      msg: 'Berhasil Login'),
                                )
                                .then(
                              (_) {
                                _emailController.clear();
                                _passwordController.clear();
                              },
                            ).then(
                              (_) {
                                if (user.user.role == 'admin') {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      NavigatorFadeHelper(
                                        child: const BotNavBarAdmin(),
                                      ),
                                      (route) => false);
                                }
                                if (user.user.role == 'user') {
                                  return Navigator.of(context)
                                      .pushAndRemoveUntil(
                                          NavigatorFadeHelper(
                                            child: const UserHomeScreen(),
                                          ),
                                          (route) => false);
                                }
                              },
                            );
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        },
                      ),
                    ),
                  ),
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
                        onPressed: () {
                          Navigator.of(context).push(
                            NavigatorFadeHelper(
                              child: const RegisterScreen(),
                            ),
                          );
                        },
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
          controller: _emailController,
          hintText: 'Email',
          icon: const Icon(Icons.mail),
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomField(
            controller: _passwordController,
            hintText: 'Password',
            obscureText: true,
            icon: const Icon(Icons.lock)),
      ],
    );
  }
}
