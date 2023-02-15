import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view_model/cart_view_model.dart';

import '../../../common/style/style.dart';
import '../../../view_model/product_view_model.dart';
import '../../widgets/loading.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CartViewModel>(context, listen: false)
          .clearTemporaryProductCart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('My Cart', style: AppFont.subtitle),
          leading: null,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _listCart(),
              SizedBox(height: 40.h),
              Row(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Consumer _listCart() {
    return Consumer<CartViewModel>(
      builder: (context, cart, _) {
        return ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = cart.productCarts[index];
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (cart.checkCartContains(data)) {
                        cart.addTemporaryProductCart(data);
                      } else {
                        cart.deleteTemporaryProductCart(data, index);
                      }
                    },
                    child: Container(
                      width: 25.w,
                      height: 25.w,
                      alignment: Alignment.center,
                      color: const Color(0xFFD9D9D9),
                      child: cart.checkCartContains(data)
                          ? null
                          : const Icon(Icons.check),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CachedNetworkImage(
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.fill,
                    imageUrl: data.productImage,
                    placeholder: (context, url) =>
                        const Loading(width: 70, height: 70, borderRadius: 0),
                    errorWidget: (context, url, error) => Image.asset(
                        'placeholder_image',
                        width: 70.w,
                        height: 70.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.productName,
                            maxLines: 2,
                            style: AppFont.subtitle,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: 8.h),
                        Text('Rp. ${data.price}',
                            maxLines: 1,
                            style: AppFont.largeText,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Consumer<ProductViewModel>(
                    builder: (context, product, _) => Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            cart.minusQuantityProduct(data);
                          },
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: const Divider(
                                  color: Colors.black, thickness: 1),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(data.quantityProduct.toString(),
                            style: AppFont.mediumText),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            cart.addQuantityProduct(product.products, data);
                          },
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.add, size: 24.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 14.h),
            itemCount: cart.productCarts.length);
      },
    );
  }
}
