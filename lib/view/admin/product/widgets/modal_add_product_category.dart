import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';

import '../../../../common/style/style.dart';
import '../../../widgets/button_widget.dart';
import 'field_product.dart';

class ModalAddCharacterBanner extends StatefulWidget {
  const ModalAddCharacterBanner({super.key});

  @override
  State<ModalAddCharacterBanner> createState() => _ModalAddWorkspaceState();
}

class _ModalAddWorkspaceState extends State<ModalAddCharacterBanner> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _categoryNameController.dispose();
    _productPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusField = FocusNode();

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          focusField.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.r),
              topRight: Radius.circular(5.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              _closeButton(context),
              SizedBox(height: 8.h),
              _formAddWorkspace(),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24.r, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formAddWorkspace() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldProduct(
                controller: _categoryNameController,
                hintText: "Category Name",
                width: double.maxFinite,
                height: 55,
                onlyNumber: false),
            SizedBox(height: 8.h),
            FieldProduct(
                onlyNumber: true,
                controller: _productPriceController,
                hintText: "Price",
                width: double.maxFinite,
                height: 55),
            SizedBox(height: 16.h),
            Consumer<ProductViewModel>(
              builder: (context, notifier, _) => ButtonWidget(
                height: 45,
                width: double.maxFinite,
                text: "Add Product Category",
                onTap: () async {
                  if (_categoryNameController.text.isEmpty ||
                      _productPriceController.text.isEmpty) {
                    return Fluttertoast.showToast(
                        msg: "Field Can't Be Empty", textColor: Colors.white);
                  } else {
                    await notifier
                        .addTemporaryCategoryProduct(
                          ProductCategoryModel(
                              price: _productPriceController.text,
                              categoryName: _categoryNameController.text),
                        )
                        .then(
                          (_) => Navigator.pop(context),
                        );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
