import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/model/checkout_model.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view/widgets/disable_field.dart';
import 'package:toko_sayur/view_model/admin_checkout_view_model.dart';

import '../../../common/style/style.dart';
import '../../../view_model/product_view_model.dart';
import '../../widgets/loading.dart';

class DetailOrderAdminScreen extends StatelessWidget {
  final CheckoutModel checkout;
  const DetailOrderAdminScreen({super.key, required this.checkout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Color(0xFFB7B7B7),
          ),
        ),
        centerTitle: true,
        title: Text('Konfirmasi Pesanan', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _listProduct(),
              SizedBox(height: 17.h),
              const Divider(
                color: Color(0xFF898989),
              ),
              SizedBox(height: 17.h),
              Consumer<AdminCheckoutViewModel>(
                builder: (context, notifier, _) => Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: checkout.statusOrder == 0
                          ? ButtonWidget(
                              height: 40,
                              width: double.maxFinite,
                              text: 'Konfirmasi Pesanan',
                              onTap: () async {
                                await notifier
                                    .updateCheckoutProducts(
                                      checkout.id!,
                                      checkout.user.email,
                                      CheckoutModel(
                                          statusOrder: 2,
                                          products: checkout.products,
                                          user: checkout.user),
                                    )
                                    .then((_) => Navigator.of(context).pop());
                              },
                            )
                          : DisableField(
                              hintText: checkout.statusOrder == 2
                                  ? 'Pesanan Dikonfirmasi'
                                  : 'Pesanan Selesai',
                              width: 0,
                              onTap: () {}),
                    ),
                    SizedBox(width: 9.w),
                    Expanded(
                      flex: 3,
                      child: checkout.statusOrder == 0
                          ? SizedBox(
                              height: 50.h,
                              child: Consumer<ProductViewModel>(
                                builder: (context, product, _) =>
                                    OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColor.secondaryColor),
                                  ),
                                  onPressed: () async {
                                    await notifier
                                        .deleteCheckoutProducts(
                                            checkout.id!, checkout.user.email)
                                        .then((_) async => await product
                                            .updateFailedCheckoutStock(
                                                checkout))
                                        .then(
                                          (_) => Fluttertoast.showToast(
                                                  msg: 'Pesanan Ditolak')
                                              .then(
                                            (_) => Navigator.of(context).pop(),
                                          ),
                                        );
                                  },
                                  child: Text(
                                    'Tolak',
                                    style: AppFont.smallText.copyWith(
                                        color: AppColor.thirdTextColor),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _listProduct() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final data = checkout.products[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.fill,
                  imageUrl: data.productImage,
                  placeholder: (context, url) =>
                      const Loading(width: 70, height: 70, borderRadius: 0),
                  errorWidget: (context, url, error) => Image.asset(
                      'placeholder_image',
                      width: 75.w,
                      height: 75.w),
                ),
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
                    Text(
                        data.quantityProduct == 1
                            ? data.categoryProductName
                            : '${data.categoryProductName} x ${data.quantityProduct}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.mediumText),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(height: 25.h),
                    Text('Rp. ${data.price}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.mediumText),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: checkout.products.length);
  }
}
