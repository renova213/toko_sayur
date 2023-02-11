import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/style.dart';

class ButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Function onTap;
  const ButtonWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
          ),
        ),
        child: Text(
          text,
          style: AppFont.subtitle.copyWith(color: AppColor.secondaryTextColor),
        ),
      ),
    );
  }
}
