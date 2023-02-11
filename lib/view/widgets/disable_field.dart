import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/style.dart';

class DisableField extends StatelessWidget {
  final double width;
  final String hintText;
  final Function onTap;

  const DisableField(
      {super.key,
      required this.hintText,
      required this.width,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        height: 55.h,
        width: width.w,
        child: TextField(
          readOnly: true,
          style: AppFont.largeText.copyWith(color: AppColor.thirdTextColor),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20).r,
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFCAF5D6)),
              borderRadius: BorderRadius.circular(5.r),
            ),
            filled: true,
            hintStyle:
                AppFont.largeText.copyWith(color: AppColor.thirdTextColor),
            fillColor: const Color(0xFFCAF5D6),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFCAF5D6)),
              borderRadius: BorderRadius.circular(5.r),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFCAF5D6)),
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),
      ),
    );
  }
}
