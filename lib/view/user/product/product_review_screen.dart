import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toko_sayur/model/review_model.dart';

import '../../../common/style/style.dart';
import '../../widgets/loading.dart';

class ProductReviewScreen extends StatelessWidget {
  final List<ReviewModel> reviews;
  const ProductReviewScreen({super.key, required this.reviews});

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
        title: Text('Product Review', style: AppFont.subtitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: ListView.separated(
            itemBuilder: (context, index) {
              final data = reviews[index];

              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.fill,
                        imageUrl: data.user.image!,
                        placeholder: (context, url) => const Loading(
                            width: 70, height: 70, borderRadius: 100),
                        errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                              'assets/images/placeholder_image.jpg',
                              width: 70.w,
                              height: 70.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          Text(data.user.fullName,
                              style: AppFont.boldMediumText),
                          SizedBox(height: 8.h),
                          Text(data.review, style: AppFont.mediumText),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: reviews.length),
      ),
    );
  }
}
