import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/style/style.dart';

class FieldProduct extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double height;
  final double width;
  final bool onlyNumber;
  const FieldProduct(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.height,
      required this.width,
      required this.onlyNumber});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.w,
      child: TextField(
        controller: controller,
        style: AppFont.largeText,
        cursorColor: Colors.black,
        inputFormatters: onlyNumber == true
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 16).r,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.secondaryColor),
            borderRadius: BorderRadius.circular(5.r),
          ),
          filled: true,
          hintStyle: AppFont.mediumText,
          fillColor: AppColor.secondaryColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.secondaryColor),
            borderRadius: BorderRadius.circular(5.r),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.secondaryColor),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
      ),
    );
  }
}
