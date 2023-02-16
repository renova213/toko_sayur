import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/common/util/navigator_fade_helper.dart';

import '../../../common/style/style.dart';
import '../../../model/checkout_model.dart';
import 'order_history_screen.dart';

class DetailOrderScreen extends StatelessWidget {
  final int indexCheckout;
  final CheckoutModel checkout;
  const DetailOrderScreen(
      {super.key, required this.checkout, required this.indexCheckout});

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
        title: Text('Lacak Pesanan', style: AppFont.subtitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transaksi Belanja', style: AppFont.subtitle),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        NavigatorFadeHelper(
                          child: OrderHistoryScreen(
                              checkout: checkout, indexCheckout: indexCheckout),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Riwayat',
                      style: AppFont.mediumText
                          .copyWith(color: AppColor.thirdTextColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Text('Pesanan Saya', style: AppFont.subtitle),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _statusOrderItem(
                        assetName: 'wait_order.png',
                        text: 'Menuggu Konfirmasi',
                        statusOrder: checkout.statusOrder,
                        initialStatus: 0),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: _statusOrderItem(
                        assetName: 'process.png',
                        text: 'Pesanan Diproses',
                        statusOrder: checkout.statusOrder,
                        initialStatus: 1),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: _statusOrderItem(
                        assetName: 'delivery_process.png',
                        text: 'Sedang Dikirim',
                        statusOrder: checkout.statusOrder,
                        initialStatus: 2),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: _statusOrderItem(
                        assetName: 'arrive.png',
                        text: 'Sampai Tujuan',
                        statusOrder: checkout.statusOrder,
                        initialStatus: 3),
                  ),
                ],
              ),
              SizedBox(height: 45.h),
              const Divider(
                color: Color(0xFF686161),
              ),
              SizedBox(height: 28.h),
              Text('No. Pesanan', style: AppFont.subtitle),
              SizedBox(height: 11.h),
              Text('00122233344555', style: AppFont.mediumText),
            ],
          ),
        ),
      ),
    );
  }

  Column _statusOrderItem(
      {required String assetName,
      required String text,
      required int statusOrder,
      required int initialStatus}) {
    return Column(
      children: [
        Image.asset('assets/images/$assetName', width: 40.w, height: 40.w),
        SizedBox(height: 8.h),
        Text(
          text,
          style: initialStatus == statusOrder
              ? AppFont.boldMediumText.copyWith(
                  color: const Color(0xFF5E5E5E),
                )
              : AppFont.mediumText.copyWith(
                  color: const Color(0xFF5E5E5E),
                ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
