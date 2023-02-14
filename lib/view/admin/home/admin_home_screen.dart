import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/enum_state.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/view/admin/product/add_product_screen.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';

import '../../../common/style/style.dart';
import '../../widgets/loading.dart';
import '../product/detail_product_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                NavigatorFadeHelper(child: const AddProductScreen()),
              );
            },
            backgroundColor: AppColor.secondaryColor,
            child: const Icon(Icons.add)),
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
                              child: DetailAdminProductScreen(product: data),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          color: const Color(0xFFF5F5F5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                width: double.maxFinite,
                                height: 120.h,
                                fit: BoxFit.fill,
                                imageUrl: data.productImage,
                                placeholder: (context, url) => const Loading(
                                    width: double.maxFinite,
                                    height: 120,
                                    borderRadius: 0),
                                errorWidget: (context, url, error) =>
                                    Image.asset('placeholder_image',
                                        width: double.maxFinite, height: 120.h),
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
