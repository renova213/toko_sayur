import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view/widgets/disable_field.dart';
import 'package:toko_sayur/view_model/checkout_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/review_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../model/review_model.dart';
import '../../widgets/loading.dart';

class ReviewProductScreen extends StatelessWidget {
  final int indexCheckout;
  const ReviewProductScreen({super.key, required this.indexCheckout});

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
        title: Text('Penilaian Produk', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('No. Pesanan', style: AppFont.subtitle),
                Text('00122233344555', style: AppFont.mediumText),
              ],
            ),
            SizedBox(height: 19.h),
            _listProduct(),
          ],
        ),
      ),
    );
  }

  Consumer _listProduct() {
    return Consumer<ProductViewModel>(
      builder: (context, product, _) => Consumer<CheckoutViewModel>(
        builder: (context, checkout, _) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final data =
                    checkout.checkoutProducts[indexCheckout].products[index];

                List<ReviewModel> reviews = [];

                final contains = product.products
                    .where((e) => e.id! == data.productId)
                    .toList();

                final TextEditingController reviewController =
                    TextEditingController();

                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.fill,
                          imageUrl: data.productImage,
                          placeholder: (context, url) => const Loading(
                              width: 70, height: 70, borderRadius: 0),
                          errorWidget: (context, url, error) => Image.asset(
                              'placeholder_image',
                              width: 75.w,
                              height: 75.w),
                        ),
                        SizedBox(width: 12.w),
                        Column(
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
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Consumer<ReviewViewModel>(
                      builder: (context, review, _) => Consumer<UserViewModel>(
                        builder: (context, user, _) =>
                            review.checkContainReview(contains, user.user.id!)
                                ? _reviewField(
                                    reviewController,
                                    (value) async {
                                      reviews.add(ReviewModel(
                                          user: user.user, review: value));

                                      await review
                                          .addReview(reviews, data.productId)
                                          .then((_) async =>
                                              await product.getProducts())
                                          .then(
                                            (_) => Fluttertoast.showToast(
                                                    msg:
                                                        'Terimakasih atas reviewnya')
                                                .then(
                                              (_) => reviewController.clear(),
                                            ),
                                          );
                                    },
                                  )
                                : DisableField(
                                    hintText: 'Terimakasih atas reviewnya',
                                    width: double.maxFinite,
                                    onTap: () {}),
                      ),
                    ),
                  ],
                );
              },
              itemCount:
                  checkout.checkoutProducts[indexCheckout].products.length);
        },
      ),
    );
  }

  SizedBox _reviewField(TextEditingController controller,
      void Function(String value) onSubmitted) {
    return SizedBox(
      height: 45.h,
      width: double.maxFinite,
      child: TextField(
        onSubmitted: (value) => onSubmitted(value),
        controller: controller,
        style: AppFont.mediumText.copyWith(color: const Color(0xFF999999)),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 16).r,
          hintText: 'isi Penilaian',
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.r),
          ),
          filled: true,
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
