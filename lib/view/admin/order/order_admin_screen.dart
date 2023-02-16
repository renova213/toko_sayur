import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view_model/admin_checkout_view_model.dart';

import '../../../common/style/style.dart';
import '../../../common/util/navigator_fade_helper.dart';
import '../../widgets/loading.dart';
import 'detail_order_admin_screen.dart';

class OrderAdminScreen extends StatefulWidget {
  const OrderAdminScreen({super.key});

  @override
  State<OrderAdminScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderAdminScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        Provider.of<AdminCheckoutViewModel>(context, listen: false)
            .getAllCheckoutProducts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Consumer<AdminCheckoutViewModel>(
          builder: (context, notifier, _) => ListView.separated(
              itemBuilder: (context, index) {
                final data = notifier.checkoutProducts[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    NavigatorFadeHelper(
                      child: DetailOrderAdminScreen(checkout: data),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 45.w,
                          height: 45.w,
                          fit: BoxFit.fill,
                          imageUrl: data.products.first.productImage,
                          placeholder: (context, url) => const Loading(
                              width: 45, height: 45, borderRadius: 0),
                          errorWidget: (context, url, error) => Image.asset(
                              'placeholder_image',
                              width: 45.w,
                              height: 45.w),
                        ),
                        SizedBox(width: 18.w),
                        Text(
                          data.user.fullName,
                          style: AppFont.largeText
                              .copyWith(color: AppColor.secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemCount: notifier.checkoutProducts.length),
        ),
      ),
    );
  }
}
