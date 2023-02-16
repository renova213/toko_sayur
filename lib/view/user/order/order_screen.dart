import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/view_model/checkout_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../widgets/loading.dart';
import 'detail_order_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        final userId =
            Provider.of<UserViewModel>(context, listen: false).user.id!;
        Provider.of<CheckoutViewModel>(context, listen: false)
            .getCheckoutProducts(userId);
      },
    );
  }

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
        title: Text('Order', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Consumer<CheckoutViewModel>(
          builder: (context, notifier, _) => ListView.separated(
              itemBuilder: (context, index) {
                final data = notifier.checkoutProducts[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    NavigatorFadeHelper(
                      child: DetailOrderScreen(checkout: data),
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
                          data.products.first.productName,
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
