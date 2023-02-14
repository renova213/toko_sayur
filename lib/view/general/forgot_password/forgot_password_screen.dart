import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view/widgets/custom_field.dart';
import 'package:toko_sayur/view_model/forgot_password_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Color(0xFFB7B7B7),
            ),
          ),
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          title: Text('Forgot Password', style: AppFont.headline6),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _formField(),
              SizedBox(height: 20.h),
              Consumer<ForgotPasswordViewModel>(
                builder: (context, register, _) => Consumer<UserViewModel>(
                  builder: (context, user, _) => ButtonWidget(
                    height: 50,
                    width: double.maxFinite,
                    text: 'Forgot Password',
                    onTap: () async {
                      if (!EmailValidator.validate(_emailController.text)) {
                        return Fluttertoast.showToast(msg: 'Use Valid Email');
                      }

                      try {
                        await register
                            .forgotPassword(_emailController.text)
                            .then(
                              (_) => Fluttertoast.showToast(
                                  msg:
                                      'Link reset password has been sent, please check your email'),
                            )
                            .then(
                          (_) {
                            _emailController.clear();
                          },
                        );
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomField _formField() {
    return CustomField(
      controller: _emailController,
      hintText: 'Your Email',
      icon: const Icon(Icons.email),
      obscureText: false,
    );
  }
}
