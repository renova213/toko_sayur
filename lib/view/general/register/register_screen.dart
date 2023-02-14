import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/model/register_model.dart';
import 'package:toko_sayur/model/user_model.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view/widgets/custom_field.dart';
import 'package:toko_sayur/view_model/register_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          title: Text('Sign up to Continue!', style: AppFont.headline6),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  _formField(),
                  SizedBox(height: 40.h),
                  Consumer<RegisterViewModel>(
                    builder: (context, register, _) => Consumer<UserViewModel>(
                      builder: (context, user, _) => ButtonWidget(
                        height: 50,
                        width: double.maxFinite,
                        text: 'Register',
                        onTap: () async {
                          if (!EmailValidator.validate(_emailController.text)) {
                            return Fluttertoast.showToast(
                                msg: 'Use Valid Email');
                          }
                          if (_passwordController.text.length < 8) {
                            return Fluttertoast.showToast(
                                msg: 'Minimum password 8 characters');
                          }

                          try {
                            await register
                                .register(
                                  RegisterModel(
                                      fullName: _fullNameController.text,
                                      email: _emailController.text,
                                      address: _addressController.text,
                                      password: _passwordController.text),
                                )
                                .then(
                                  (_) async => await user.addUser(
                                      UserModel(
                                          fullName: _fullNameController.text,
                                          email: _emailController.text,
                                          address: _addressController.text),
                                      _emailController.text),
                                )
                                .then(
                                  (_) => Fluttertoast.showToast(
                                      msg: 'Berhasil Register'),
                                )
                                .then(
                              (_) {
                                _fullNameController.clear();
                                _addressController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                              },
                            ).then(
                              (_) => Navigator.pop(context),
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
                        "Already have an account?",
                        style: AppFont.largeText.copyWith(
                          color: const Color(0xFF686161),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Login", style: AppFont.subtitle),
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
        CustomField(
          controller: _fullNameController,
          hintText: 'Full Name',
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomField(
          controller: _emailController,
          hintText: 'Email',
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomField(
          controller: _addressController,
          hintText: 'Address',
          obscureText: false,
        ),
        SizedBox(height: 16.h),
        CustomField(
          controller: _passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
      ],
    );
  }
}
