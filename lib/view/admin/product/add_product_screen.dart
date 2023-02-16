import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/style/style.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view/admin/product/product_category_screen.dart';
import 'package:toko_sayur/view/admin/product/widgets/description_field_product.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';

import '../../../view_model/product_view_model.dart';
import 'widgets/disable_field_product.dart';
import 'widgets/field_product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<ProductViewModel>(context, listen: false).clearImage();
      Provider.of<ProductViewModel>(context, listen: false)
          .getTemporaryCategoryProduct([]);
    });
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
            'Add Product',
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
                        : Container(
                            color: const Color(0xFFD9D9D9),
                            height: 185.h,
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            child: Text('Add Image', style: AppFont.largeText),
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
                    text: 'Add Product',
                    onTap: () async {
                      if (_productNameController.text.isNotEmpty &&
                          _productDescriptionController.text.isNotEmpty &&
                          notifier.image != null &&
                          notifier.temporaryCategoryProducts.isNotEmpty) {
                        try {
                          await notifier
                              .uploadProductImage()
                              .then(
                                (_) async => await notifier.addProduct(
                                  ProductModel(
                                      reviews: [],
                                      productName: _productNameController.text,
                                      productDescription:
                                          _productDescriptionController.text,
                                      productImage: notifier.urlProductImage!,
                                      productCategory:
                                          notifier.temporaryCategoryProducts),
                                ),
                              )
                              .then(
                                (_) => Fluttertoast.showToast(
                                    msg: 'Berhasil Upload'),
                              )
                              .then(
                            (_) {
                              _productDescriptionController.clear();
                              _productNameController.clear();
                              notifier.temporaryCategoryProducts.clear();
                              notifier.clearImage();
                            },
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
