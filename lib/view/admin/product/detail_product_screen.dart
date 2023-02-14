import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view/admin/botnavbar_admin.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';

import '../../../common/style/style.dart';
import '../../widgets/loading.dart';
import 'update_product_screen.dart';

class DetailAdminProductScreen extends StatefulWidget {
  final ProductModel product;
  const DetailAdminProductScreen({super.key, required this.product});

  @override
  State<DetailAdminProductScreen> createState() =>
      _DetailAdminProductScreenState();
}

class _DetailAdminProductScreenState extends State<DetailAdminProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProductViewModel>(context, listen: false)
        .changeIndexProductCategory(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 24, bottom: 24).r,
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
                  style:
                      AppFont.subtitle.copyWith(color: AppColor.secondaryColor),
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
              _deleteEditProductButton(),
            ],
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
              onPressed: () {},
              child: Text(
                'Penilaian Product',
                style:
                    AppFont.mediumText.copyWith(color: AppColor.thirdTextColor),
              ),
            ),
          ],
        ),
        Consumer<ProductViewModel>(
          builder: (context, notfier, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                2,
                (index) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill,
                              imageUrl:
                                  'https://cf.shopee.co.id/file/182adc5f2a32e0101f6390c6c9e990b8',
                              placeholder: (context, url) => const Loading(
                                  width: 40, height: 40, borderRadius: 100),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('placeholder_image',
                                    width: double.maxFinite, height: 40.h),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vencinthia Veronika',
                                    style: AppFont.boldMediumText),
                                SizedBox(height: 12.h),
                                Text('Bawang Merahnya Fresh dan bagus',
                                    style: AppFont.mediumText),
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
            );
          },
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

  Consumer _deleteEditProductButton() {
    return Consumer<ProductViewModel>(
      builder: (context, notifier, _) => Row(
        children: [
          Expanded(
            flex: 1,
            child: ButtonWidget(
              height: 45,
              width: double.maxFinite,
              text: 'Edit Product',
              onTap: () {
                Navigator.of(context).push(
                  NavigatorFadeHelper(
                    child: UpdateProductScreen(product: widget.product),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 1,
            child: ButtonWidget(
              height: 45,
              width: double.maxFinite,
              text: 'Delete Product',
              onTap: () {
                _delete(widget.product.id!);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _delete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete This?"),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<ProductViewModel>(
                  builder: (context, notifier, _) => TextButton(
                    onPressed: () async {
                      await notifier.deleteProduct(id).then(
                            (_) => Navigator.of(context).pushAndRemoveUntil(
                                NavigatorFadeHelper(
                                    child: const BotNavBarAdmin()),
                                (route) => false),
                          );
                    },
                    child: const Text("Yes"),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
