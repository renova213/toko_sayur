import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/cart_view_model.dart';
import 'package:toko_sayur/view_model/favorite_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../model/cart_model.dart';
import '../../widgets/loading.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('My Favorite', style: AppFont.subtitle),
            leading: null,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 24).r,
          child: Consumer<FavoriteViewModel>(
            builder: (context, favorite, _) => Consumer<ProductViewModel>(
              builder: (context, product, _) {
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final data = favorite.favoriteProducts[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                width: 70.w,
                                height: 70.w,
                                fit: BoxFit.fill,
                                imageUrl: data.productImage!,
                                placeholder: (context, url) => const Loading(
                                    width: 70, height: 70, borderRadius: 0),
                                errorWidget: (context, url, error) =>
                                    Image.asset('placeholder_image',
                                        width: 75.w, height: 75.w),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.productName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFont.subtitle),
                                    SizedBox(height: 4.h),
                                    Text(
                                        data.productCategory!.first
                                            .categoryName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFont.mediumText),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Consumer<UserViewModel>(
                            builder: (context, user, _) =>
                                Consumer<FavoriteViewModel>(
                              builder: (context, favorite, _) => Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 140,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: AppColor.secondaryColor),
                                      ),
                                      onPressed: () async {
                                        try {
                                          await favorite
                                              .deleteFavoriteProduct(
                                                  user.user.id!, data.id!)
                                              .then(
                                                (_) => Fluttertoast.showToast(
                                                    msg:
                                                        'Remove from favorite'),
                                              );
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                        }
                                      },
                                      child: Text(
                                        'Remove',
                                        style: AppFont.boldSmallText.copyWith(
                                            color: AppColor.thirdTextColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Consumer<CartViewModel>(
                                    builder: (context, cart, _) => ButtonWidget(
                                      height: 35,
                                      width: 140,
                                      text: 'Add to Cart',
                                      onTap: () async {
                                        try {
                                          await cart
                                              .addProductCart(
                                                  CartModel(
                                                      quantityProduct: 1,
                                                      productId: data.productId,
                                                      productName:
                                                          data.productName!,
                                                      productImage:
                                                          data.productImage!,
                                                      productDescription: data
                                                          .productDescription!,
                                                      categoryProductName: data
                                                          .productCategory!
                                                          .first
                                                          .categoryName!,
                                                      price: data
                                                          .productCategory!
                                                          .first
                                                          .price!),
                                                  user.user.id!)
                                              .then((_) async => await favorite
                                                  .deleteFavoriteProduct(
                                                      user.user.id!, data.id!))
                                              .then(
                                                (_) => Fluttertoast.showToast(
                                                    msg: 'Added to Cart'),
                                              );
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: favorite.favoriteProducts.length);
              },
            ),
          ),
        ),
      ),
    );
  }
}
