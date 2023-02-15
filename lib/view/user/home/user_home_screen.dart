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
import '../../../model/favorite_model.dart';
import '../../widgets/loading.dart';
import '../product/detail_product_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: AppColor.secondaryColor,
          leading: const Icon(Icons.menu, color: AppColor.primaryColor),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: AppColor.primaryColor),
            ),
          ],
          title: Text(
            'Market Place',
            style:
                AppFont.subtitle.copyWith(color: AppColor.secondaryTextColor),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 24).r,
          child: Consumer<ProductViewModel>(
            builder: (context, notifier, _) {
              if (notifier.appState == AppState.loaded) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 16,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 2.35),
                    itemBuilder: (context, index) {
                      final data = notifier.products[index];
                      return GestureDetector(
                        onTap: () {
                          notifier.changeIndexProductCategory(0);
                          Navigator.of(context).push(
                            NavigatorFadeHelper(
                              child: DetailProductScreen(product: data),
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
                                    imageUrl: data.productImage,
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
                                            if (favorite.checkProductFavorite(
                                                data.id!)) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Already added in favorite');
                                            } else {
                                              try {
                                                await favorite
                                                    .addFavoriteProduct(
                                                        FavoriteModel(
                                                            productId:
                                                                data.id!),
                                                        user.user.id!)
                                                    .then((_) =>
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Added to cart'));
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                    msg: e.toString());
                                              }
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
                              Text(data.productName,
                                  style: AppFont.boldMediumText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center),
                              SizedBox(height: 8.h),
                              Text(
                                  data.productCategory.length == 1
                                      ? 'Rp. ${data.productCategory.first.price}'
                                      : 'Rp. ${data.productCategory.first.price} - ${data.productCategory.last.price}',
                                  style: AppFont.smallText
                                      .copyWith(color: AppColor.secondaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: notifier.products.length);
              }
              return _loading();
            },
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
