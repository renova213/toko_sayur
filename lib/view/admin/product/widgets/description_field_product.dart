import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/style/style.dart';

class DescriptionFieldProduct extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  const DescriptionFieldProduct(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: TextField(
        maxLines: 5,
        controller: controller,
        style: AppFont.largeText,
        cursorColor: Colors.black,
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
