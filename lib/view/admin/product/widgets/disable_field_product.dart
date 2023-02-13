import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/style/style.dart';

class DisableFieldProduct extends StatelessWidget {
  final double width;
  final String hintText;
  final Function onTap;

  const DisableFieldProduct(
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
          style: AppFont.mediumText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20).r,
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
      ),
    );
  }
}
