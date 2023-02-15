import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/general_dialog.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';
import 'package:toko_sayur/view/user/checkout/checkout_success_screen.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/checkout_view_model.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../common/style/style.dart';
import '../../../model/checkout_model.dart';
import '../../widgets/loading.dart';
import 'widgets/modal_update_user_address.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CheckoutProductModel> products;
  const CheckoutScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
        title: Text('Checkout', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _profile(),
              _listCheckout(),
              SizedBox(height: 12.h),
              const Divider(
                color: Color(0xFFB7B7B7),
              ),
              _detailCheckout(),
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.centerRight,
                child: Consumer<UserViewModel>(
                  builder: (context, user, _) => Consumer<CheckoutViewModel>(
                    builder: (context, checkout, _) =>
                        Consumer<ProductViewModel>(
                      builder: (context, product, _) => ButtonWidget(
                        height: 40,
                        width: 160,
                        text: 'Checkout',
                        onTap: () async {
                          await checkout
                              .addCheckoutProduct(
                                  CheckoutModel(
                                      statusOrder: 0, products: products),
                                  user.user.id!)
                              .then(
                                (_) async => await product.updateStock(
                                  CheckoutModel(
                                      statusOrder: 0, products: products),
                                ),
                              )
                              .then(
                                (value) => Navigator.pushReplacement(
                                  context,
                                  NavigatorFadeHelper(
                                    child: const CheckoutSuccessScreen(),
                                  ),
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Consumer _profile() {
    return Consumer<UserViewModel>(
      builder: (context, notifier, _) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alamat', style: AppFont.subtitle),
              TextButton(
                onPressed: () {
                  GeneralDialog.generalDialog(
                    context: context,
                    screen: ModalUpdateUserAddress(user: notifier.user),
                  );
                },
                child: Text(
                  'Ubah',
                  style: AppFont.largeText
                      .copyWith(color: AppColor.thirdTextColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              notifier.user.image == null || notifier.user.image!.isEmpty
                  ? Image.asset('assets/images/placeholder_image.jpg',
                      width: 80.w, height: 80.w, fit: BoxFit.fill)
                  : CachedNetworkImage(
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.fill,
                      imageUrl: notifier.user.image!,
                      placeholder: (context, url) =>
                          const Loading(width: 80, height: 80, borderRadius: 0),
                      errorWidget: (context, url, error) => Image.asset(
                          'placeholder_image',
                          width: 80.w,
                          height: 80.w),
                    ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notifier.user.fullName, style: AppFont.largeText),
                    Text(
                      notifier.user.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFont.mediumText.copyWith(
                        color: const Color(0xFF686161),
                      ),
                    ),
                    Text(
                      notifier.user.phone,
                      style: AppFont.mediumText.copyWith(
                        color: const Color(0xFF686161),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(
            color: Color(0xFFB7B7B7),
          ),
        ],
      ),
    );
  }

  ListView _listCheckout() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final data = products[index];
          return Row(
            children: [
              CachedNetworkImage(
                width: 70.w,
                height: 70.w,
                fit: BoxFit.fill,
                imageUrl: data.productImage,
                placeholder: (context, url) =>
                    const Loading(width: 70, height: 70, borderRadius: 0),
                errorWidget: (context, url, error) =>
                    Image.asset('placeholder_image', width: 75.w, height: 75.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.subtitle),
                    SizedBox(height: 4.h),
                    Text(data.categoryProductName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.mediumText),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Rp. ${data.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFont.mediumText),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: products.length);
  }

  Column _detailCheckout() {
    int subTotal = 0;

    for (var i in products) {
      subTotal += int.parse(i.price);
    }
    return Column(
      children: [
        _detailCheckoutItem('Total', 'Rp. $subTotal', AppColor.thirdTextColor),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Ongkir', 'Free', Colors.black),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Sub Total', 'Rp. $subTotal', Colors.black),
        SizedBox(height: 4.h),
        _detailCheckoutItem('Pembayaran', 'Cash of Delivery', Colors.black),
      ],
    );
  }

  Row _detailCheckoutItem(String text1, String text2, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: AppFont.mediumText.copyWith(color: color),
        ),
        Text(
          text2,
          style: AppFont.mediumText.copyWith(color: color),
        ),
      ],
    );
  }
}
