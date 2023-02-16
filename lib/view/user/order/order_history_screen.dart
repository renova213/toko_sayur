import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/checkout_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../model/checkout_model.dart';
import '../../../view_model/admin_checkout_view_model.dart';
import '../../widgets/loading.dart';

class OrderHistoryScreen extends StatelessWidget {
  final CheckoutModel checkout;
  const OrderHistoryScreen({super.key, required this.checkout});

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
        title: Text('Riwayat Transaksi', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No. Pesanan', style: AppFont.subtitle),
                  Text('00122233344555', style: AppFont.mediumText),
                ],
              ),
              SizedBox(height: 15.h),
              _listProduct(),
              SizedBox(height: 34.h),
              const Divider(color: Color(0xFFB7B7B7)),
              SizedBox(height: 8.h),
              _detailCheckout(),
              SizedBox(height: 19.h),
              Row(
                children: [
                  checkout.statusOrder == 2
                      ? Row(
                          children: [
                            Image.asset('assets/images/confirm.png'),
                            SizedBox(width: 5.w),
                            Consumer<AdminCheckoutViewModel>(
                              builder: (context, checkoutAdmin, _) =>
                                  Consumer<CheckoutViewModel>(
                                builder: (context, checkoutUser, _) =>
                                    Consumer<UserViewModel>(
                                  builder: (context, user, _) => TextButton(
                                    onPressed: () async {
                                      await checkoutAdmin
                                          .updateCheckoutProducts(
                                            checkout.id!,
                                            user.user.id!,
                                            CheckoutModel(
                                                statusOrder: 3,
                                                products: checkout.products,
                                                user: user.user),
                                          )
                                          .then(
                                            (_) async => await checkoutUser
                                                .getCheckoutProducts(
                                                    user.user.id!),
                                          )
                                          .then((_) =>
                                              Navigator.of(context).pop())
                                          .then((_) =>
                                              Navigator.of(context).pop());
                                    },
                                    child: Text(
                                      'Pesanan Sudah Sampai',
                                      style: AppFont.largeText.copyWith(
                                          color: AppColor.thirdTextColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const Spacer(),
                  checkout.statusOrder == 3
                      ? ButtonWidget(
                          height: 35, width: 95, text: 'Nilai', onTap: () {})
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _listProduct() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final data = checkout.products[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                width: 70.w,
                height: 70.w,
                fit: BoxFit.fill,
                imageUrl: data.productImage,
                placeholder: (context, url) =>
                    const Loading(width: 70, height: 70, borderRadius: 0),
                errorWidget: (context, url, error) =>
                    Image.asset('placeholder_image', width: 75.w, height: 75.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.subtitle),
                    SizedBox(height: 4.h),
                    Text(
                        data.quantityProduct == 1
                            ? data.categoryProductName
                            : '${data.categoryProductName} x ${data.quantityProduct}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.mediumText),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(height: 25.h),
                    Text('Rp. ${data.price}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.mediumText),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: checkout.products.length);
  }

  Column _detailCheckout() {
    int subTotal = 0;

    for (var i in checkout.products) {
      subTotal += int.parse(i.price);
    }
    return Column(
      children: [
        _detailCheckoutItem('Total', 'Rp. $subTotal', AppColor.thirdTextColor),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Ongkir', 'Free', Colors.black),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Sub Total', 'Rp. $subTotal', Colors.black),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Pembayaran', 'Cash of Delivery', Colors.black),
      ],
    );
  }

  Row _detailCheckoutItem(String text1, String text2, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: AppFont.mediumText.copyWith(color: color),
        ),
        Text(
          text2,
          style: AppFont.mediumText.copyWith(color: color),
        ),
      ],
    );
  }
}
