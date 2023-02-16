import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/cart_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../common/util/navigator_fade_helper.dart';
import '../../../model/cart_model.dart';
import '../../../model/checkout_model.dart';
import '../../widgets/loading.dart';
import '../checkout/chekcout_screen.dart';
import 'product_review_screen.dart';

class DetailProductScreen extends StatefulWidget {
  final ProductModel product;
  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 24)
                    .r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  width: double.maxFinite,
                  height: 250.h,
                  fit: BoxFit.fill,
                  imageUrl: widget.product.productImage,
                  placeholder: (context, url) => const Loading(
                      width: double.maxFinite, height: 250, borderRadius: 0),
                  errorWidget: (context, url, error) => Image.asset(
                      'placeholder_image',
                      width: double.maxFinite,
                      height: 250.h),
                ),
                SizedBox(height: 16.h),
                Text(widget.product.productName, style: AppFont.headline6),
                SizedBox(height: 8.h),
                Text(
                    widget.product.productCategory.length == 1
                        ? 'Rp. ${widget.product.productCategory.first.price}'
                        : 'Rp. ${widget.product.productCategory.first.price} - ${widget.product.productCategory.last.price}',
                    style: AppFont.subtitle
                        .copyWith(color: AppColor.secondaryColor),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center),
                SizedBox(height: 16.h),
                Text('Deskripsi', style: AppFont.subtitle),
                SizedBox(height: 8.h),
                Text(widget.product.productDescription,
                    style: AppFont.mediumText),
                SizedBox(height: 16.h),
                _productReview(),
                SizedBox(height: 24.h),
                _productCategory(),
                SizedBox(height: 16.h),
                _cartAndCheckoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _productReview() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Penilaian Product', style: AppFont.boldMediumText),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  NavigatorFadeHelper(
                    child: ProductReviewScreen(reviews: widget.product.reviews),
                  ),
                );
              },
              child: Text(
                'Penilaian Product',
                style:
                    AppFont.mediumText.copyWith(color: AppColor.thirdTextColor),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.product.reviews.length < 2
                ? widget.product.reviews.length
                : 2,
            (index) {
              final data = widget.product.reviews[index];
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.fill,
                          imageUrl: data.user.image!,
                          placeholder: (context, url) => const Loading(
                              width: 40, height: 40, borderRadius: 100),
                          errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                                'assets/images/placeholder_image.jpg',
                                width: 40.w,
                                height: 40.w),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.user.fullName,
                                style: AppFont.boldMediumText),
                            SizedBox(height: 12.h),
                            Text(data.review, style: AppFont.mediumText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Consumer _productCategory() {
    return Consumer<ProductViewModel>(
      builder: (context, notifier, _) => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  width: 55.w,
                  height: 55.h,
                  fit: BoxFit.fill,
                  imageUrl: widget.product.productImage,
                  placeholder: (context, url) =>
                      const Loading(width: 55, height: 55, borderRadius: 0),
                  errorWidget: (context, url, error) => Image.asset(
                      'placeholder_image',
                      width: 55.w,
                      height: 55.h),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Rp. ${widget.product.productCategory[notifier.indexProductCategory].price}',
                        style: AppFont.mediumText),
                    SizedBox(height: 8.h),
                    Text(
                        'Stock: ${widget.product.productCategory[notifier.indexProductCategory].stock}',
                        style: AppFont.mediumText),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _gridProductCategory(),
          ],
        ),
      ),
    );
  }

  Consumer _gridProductCategory() {
    return Consumer<ProductViewModel>(
      builder: (context, notifier, _) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            crossAxisCount: 3,
            childAspectRatio: 2 / 1),
        itemCount: widget.product.productCategory.length,
        itemBuilder: (context, index) {
          final data = widget.product.productCategory[index];
          return GestureDetector(
            onTap: () {
              notifier.changeIndexProductCategory(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                border: Border.all(
                    color: notifier.indexProductCategory == index
                        ? Colors.black
                        : Colors.transparent),
              ),
              alignment: Alignment.center,
              child: Text(data.categoryName, style: AppFont.boldMediumText),
            ),
          );
        },
      ),
    );
  }

  Consumer _cartAndCheckoutButton() {
    return Consumer<CartViewModel>(
      builder: (context, cart, _) => Consumer<ProductViewModel>(
        builder: (context, product, _) => Consumer<UserViewModel>(
          builder: (context, user, _) => Row(
            children: [
              Expanded(
                flex: 1,
                child: ButtonWidget(
                  height: 45,
                  width: double.maxFinite,
                  text: 'Add to Cart',
                  onTap: () async {
                    if (int.parse(widget
                            .product
                            .productCategory[product.indexProductCategory]
                            .stock) >
                        0) {
                      if (cart.checkProductCart(
                          widget.product.id!,
                          widget
                              .product
                              .productCategory[product.indexProductCategory]
                              .categoryName)) {
                        Fluttertoast.showToast(msg: 'Already in cart');
                      } else {
                        try {
                          await cart
                              .addProductCart(
                                  CartModel(
                                      productId: widget.product.id!,
                                      quantityProduct: 1,
                                      productName: widget.product.productName,
                                      productImage: widget.product.productImage,
                                      productDescription:
                                          widget.product.productDescription,
                                      categoryProductName: widget
                                          .product
                                          .productCategory[
                                              product.indexProductCategory]
                                          .categoryName,
                                      price: widget
                                          .product
                                          .productCategory[
                                              product.indexProductCategory]
                                          .price),
                                  user.user.id!)
                              .then(
                                (_) => Fluttertoast.showToast(
                                    msg: 'Added to cart'),
                              );
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Stock Empty');
                    }
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 1,
                child: ButtonWidget(
                  height: 45,
                  width: double.maxFinite,
                  text: 'Checkout',
                  onTap: () {
                    if (int.parse(widget
                            .product
                            .productCategory[product.indexProductCategory]
                            .stock) >
                        0) {
                      Navigator.of(context).push(
                        NavigatorFadeHelper(
                          child: CheckoutScreen(
                            function: () async {},
                            products: [
                              CheckoutProductModel(
                                  productId: widget.product.id!,
                                  quantityProduct: 1,
                                  productName: widget.product.productName,
                                  productImage: widget.product.productImage,
                                  productDescription:
                                      widget.product.productDescription,
                                  categoryProductName: widget
                                      .product
                                      .productCategory[
                                          product.indexProductCategory]
                                      .categoryName,
                                  price: widget
                                      .product
                                      .productCategory[
                                          product.indexProductCategory]
                                      .price)
                            ],
                          ),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'Stock Empty');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
