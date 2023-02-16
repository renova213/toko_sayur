import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/style/style.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view/admin/botnavbar_admin.dart';
import 'package:toko_sayur/view/admin/product/product_category_screen.dart';
import 'package:toko_sayur/view/admin/product/widgets/description_field_product.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';

import '../../../view_model/product_view_model.dart';
import '../../widgets/loading.dart';
import 'widgets/disable_field_product.dart';
import 'widgets/field_product.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;
  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<ProductViewModel>(context, listen: false).clearImage();
      Provider.of<ProductViewModel>(context, listen: false)
          .getUrlProductImage(widget.product.productImage);
      Provider.of<ProductViewModel>(context, listen: false)
          .getTemporaryCategoryProduct(widget.product.productCategory);
    });
    _productNameController.text = widget.product.productName;
    _productDescriptionController.text = widget.product.productDescription;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _productDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Product',
            style:
                AppFont.subtitle.copyWith(color: AppColor.secondaryTextColor),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 24).r,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<ProductViewModel>(
                  builder: (context, notifier, _) => GestureDetector(
                    onTap: () {
                      notifier.getImage();
                    },
                    child: notifier.image != null
                        ? Image.file(notifier.image!,
                            height: 185.h,
                            width: double.maxFinite,
                            fit: BoxFit.fill)
                        : CachedNetworkImage(
                            width: double.maxFinite,
                            height: 185.h,
                            fit: BoxFit.fill,
                            imageUrl: widget.product.productImage,
                            placeholder: (context, url) => const Loading(
                                width: double.maxFinite,
                                height: 185,
                                borderRadius: 0),
                            errorWidget: (context, url, error) => Image.asset(
                                'placeholder_image',
                                width: double.maxFinite,
                                height: 185.h),
                          ),
                  ),
                ),
                SizedBox(height: 12.h),
                _formField(),
                SizedBox(height: 20.h),
                Consumer<ProductViewModel>(
                  builder: (context, notifier, _) => ButtonWidget(
                    height: 55,
                    width: double.maxFinite,
                    text: 'Update Product',
                    onTap: () async {
                      if (_productNameController.text.isNotEmpty &&
                              _productDescriptionController.text.isNotEmpty &&
                              notifier.urlProductImage != null ||
                          notifier.temporaryCategoryProducts.isNotEmpty) {
                        try {
                          try {
                            if (notifier.image != null) {
                              await notifier.uploadProductImage().then(
                                    (_) => notifier.deleteImage(
                                        widget.product.productImage),
                                  );
                            }
                          } catch (_) {}

                          await notifier
                              .updateProduct(
                                  ProductModel(
                                          reviews: widget.product.reviews,
                                          productName:
                                              _productNameController.text,
                                          productDescription:
                                              _productDescriptionController
                                                  .text,
                                          productImage:
                                              notifier.urlProductImage!,
                                          productCategory: notifier
                                              .temporaryCategoryProducts)
                                      .toJson(),
                                  widget.product.id!)
                              .then(
                                (_) => Fluttertoast.showToast(
                                    msg: 'Berhasil Upload'),
                              )
                              .then(
                                (_) => Navigator.of(context).pushAndRemoveUntil(
                                    NavigatorFadeHelper(
                                        child: const BotNavBarAdmin()),
                                    (route) => false),
                              );
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Field can't be empty");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _formField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldProduct(
            onlyNumber: false,
            controller: _productNameController,
            hintText: 'Product Name',
            height: 55,
            width: double.maxFinite),
        SizedBox(height: 16.h),
        DescriptionFieldProduct(
            controller: _productDescriptionController,
            hintText: 'Product Description',
            width: double.maxFinite),
        SizedBox(height: 16.h),
        Consumer<ProductViewModel>(
          builder: (context, notifier, _) => Row(
            children: [
              DisableFieldProduct(
                  hintText: 'Product Category', width: 170, onTap: () {}),
              const Spacer(),
              Text(
                "${notifier.temporaryCategoryProducts.length} Categories",
                style: AppFont.largeText,
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    NavigatorFadeHelper(
                      child: Consumer<ProductViewModel>(
                        builder: (context, notifier, _) =>
                            ProductCategoryScreen(
                                productCategories:
                                    notifier.temporaryCategoryProducts),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.edit, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
