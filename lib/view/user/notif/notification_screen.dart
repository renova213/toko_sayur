import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/style/style.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';

import '../order/order_screen.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Color(0xFFB7B7B7),
          ),
        ),
        centerTitle: true,
        title: Text('List', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  NavigatorFadeHelper(child: const OrderScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(14.r),
                height: 60.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining, color: Colors.white),
                    SizedBox(width: 18.w),
                    Text(
                      'Order',
                      style: AppFont.largeText
                          .copyWith(color: AppColor.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(14.r),
                height: 60.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    SizedBox(width: 18.w),
                    Text(
                      'Notification',
                      style: AppFont.largeText
                          .copyWith(color: AppColor.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
