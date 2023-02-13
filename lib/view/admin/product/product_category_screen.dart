import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/style/style.dart';
import 'package:toko_sayur/common/util/general_dialog.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/view/admin/product/widgets/modal_add_product_category.dart';

import '../../../view_model/product_view_model.dart';

class ProductCategoryScreen extends StatefulWidget {
  final List<ProductCategoryModel> productCategories;
  const ProductCategoryScreen({super.key, required this.productCategories});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProductViewModel>(context, listen: false)
        .getTemporaryCategoryProduct(widget.productCategories));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.secondaryColor,
        title: Text(
          'Product Category',
          style: AppFont.subtitle.copyWith(color: AppColor.secondaryTextColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GeneralDialog.generalDialog(
            context: context,
            screen: const ModalAddCharacterBanner(),
          );
        },
        backgroundColor: AppColor.secondaryColor,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 24).r,
        child: Consumer<ProductViewModel>(
          builder: (context, notifier, _) => ListView.separated(
              itemBuilder: (context, index) {
                final data = notifier.temporaryCategoryProducts[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 8.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("#${index + 1}", style: AppFont.largeText),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.categoryName, style: AppFont.subtitle),
                          SizedBox(height: 8.h),
                          Text(data.price, style: AppFont.mediumText),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _delete(index);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemCount: notifier.temporaryCategoryProducts.length),
        ),
      ),
    );
  }

  void _delete(int index) {
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
                      await notifier.deleteTemporaryCategoryProduct(index).then(
                            (_) => Navigator.pop(context),
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
