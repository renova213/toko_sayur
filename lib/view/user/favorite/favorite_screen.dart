import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/enum_state.dart';
import 'package:toko_sayur/view_model/favorite_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../common/util/navigator_fade_helper.dart';
import '../../../model/product_model.dart';
import '../../widgets/loading.dart';
import '../product/detail_product_screen.dart';

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
                if (product.appState == AppState.loaded) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 16,
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 2.35),
                      itemBuilder: (context, index) {
                        final data = favorite.favoriteProducts[index];
                        return GestureDetector(
                          onTap: () {
                            product.changeIndexProductCategory(0);
                            Navigator.of(context).push(
                              NavigatorFadeHelper(
                                child: DetailProductScreen(
                                  product: ProductModel(
                                    reviews: data.reviews,
                                    id: data.productId,
                                    productName: data.productName!,
                                    productImage: data.productImage!,
                                    productDescription:
                                        data.productDescription!,
                                    productCategory: data.productCategory!
                                        .map(
                                          (e) => ProductCategoryModel(
                                              categoryName: e.categoryName!,
                                              price: e.price!,
                                              stock: e.stock!),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            color: const Color(0xFFF5F5F5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    CachedNetworkImage(
                                      width: double.maxFinite,
                                      height: 120.h,
                                      fit: BoxFit.fill,
                                      imageUrl: data.productImage!,
                                      placeholder: (context, url) =>
                                          const Loading(
                                              width: double.maxFinite,
                                              height: 120,
                                              borderRadius: 0),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('placeholder_image',
                                              width: double.maxFinite,
                                              height: 120.h),
                                    ),
                                    Positioned(
                                      left: 100.w,
                                      bottom: 70.h,
                                      child: Consumer<FavoriteViewModel>(
                                        builder: (context, favorite, _) =>
                                            Consumer<UserViewModel>(
                                          builder: (context, user, _) =>
                                              IconButton(
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
                                            icon: const Icon(Icons.star,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(data.productName!,
                                    style: AppFont.boldMediumText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center),
                                SizedBox(height: 8.h),
                                Text(
                                    data.productCategory!.length == 1
                                        ? 'Rp. ${data.productCategory!.first.price}'
                                        : 'Rp. ${data.productCategory!.first.price} - ${data.productCategory!.last.price}',
                                    style: AppFont.smallText.copyWith(
                                        color: AppColor.secondaryColor),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: favorite.favoriteProducts.length);
                }
                return _loading();
              },
            ),
          ),
        ),
      ),
    );
  }

  GridView _loading() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 12,
            crossAxisSpacing: 16,
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.6),
        itemBuilder: (context, index) {
          return const Loading(width: 0, height: 0, borderRadius: 0);
        },
        itemCount: 20);
  }
}
