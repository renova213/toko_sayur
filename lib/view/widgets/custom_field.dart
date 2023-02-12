import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/style.dart';

class CustomField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? icon;
  final bool obscureText;

  const CustomField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.icon,
      required this.obscureText});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: double.maxFinite,
      child: TextField(
        obscureText: widget.obscureText == true ? obscureText : false,
        controller: widget.controller,
        style: AppFont.mediumText.copyWith(color: const Color(0xFF999999)),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 16).r,
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.r),
          ),
          filled: true,
          prefixIcon: widget.icon,
          suffixIcon: widget.obscureText == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText == false
                        ? Icons.visibility_rounded
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
          hintStyle:
              AppFont.mediumText.copyWith(color: const Color(0xFF999999)),
          fillColor: AppColor.primaryColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.r),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ),
    );
  }
}
