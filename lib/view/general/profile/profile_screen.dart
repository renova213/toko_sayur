import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/common/util/enum_state.dart';
import 'package:toko_sayur/model/user_model.dart';

import '../../../common/style/style.dart';
import '../../../common/util/navigator_fade_helper.dart';
import '../../../view_model/product_view_model.dart';
import '../../../view_model/user_view_model.dart';
import '../../widgets/loading.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        final String urlImage =
            Provider.of<UserViewModel>(context, listen: false).user.image!;

        Provider.of<ProductViewModel>(context, listen: false)
            .getUrlProductImage(urlImage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text('My Profile', style: AppFont.subtitle),
                SizedBox(height: 45.h),
                SizedBox(
                  width: 140.w,
                  child: Stack(
                    children: [
                      Consumer<ProductViewModel>(
                        builder: (context, notifier, _) => notifier.appState ==
                                AppState.loaded
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: notifier.urlProductImage == null ||
                                        notifier.urlProductImage!.isEmpty
                                    ? Image.asset(
                                        'assets/images/placeholder_image.jpg',
                                        width: 130.w,
                                        height: 130.w,
                                        fit: BoxFit.fill)
                                    : CachedNetworkImage(
                                        width: 130.w,
                                        height: 130.w,
                                        fit: BoxFit.fill,
                                        imageUrl: notifier.urlProductImage!,
                                        placeholder: (context, url) =>
                                            const Loading(
                                                width: 130,
                                                height: 155,
                                                borderRadius: 100),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('placeholder_image',
                                                width: 130.w, height: 130.w),
                                      ),
                              )
                            : const Loading(
                                width: 130, height: 155, borderRadius: 100),
                      ),
                      Positioned(
                        top: 100.h,
                        left: 90.w,
                        child: Consumer<UserViewModel>(
                          builder: (context, user, _) =>
                              Consumer<ProductViewModel>(
                            builder: (context, product, _) => GestureDetector(
                              onTap: () async {
                                await product.getImage();
                                await product.uploadProductImage();
                                await user.updateUser(
                                    UserModel(
                                        fullName: user.user.fullName,
                                        email: user.user.email,
                                        address: user.user.address,
                                        image: product.urlProductImage),
                                    user.user.id!);
                                product.getUrlProductImage(user.user.image!);
                              },
                              child: Container(
                                height: 40.w,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColor.secondaryColor),
                                alignment: Alignment.center,
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                const Divider(color: Colors.black),
                SizedBox(height: 24.h),
                _detailProfile(),
                SizedBox(height: 48.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          NavigatorFadeHelper(child: const LoginScreen()),
                          (route) => false);

                      Fluttertoast.showToast(msg: 'Berhasil Logout');
                    },
                    child: SizedBox(
                      width: 120.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout,
                              color: AppColor.secondaryColor),
                          SizedBox(width: 16.w),
                          Text(
                            'Logout',
                            style: AppFont.largeText
                                .copyWith(color: AppColor.thirdTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Consumer _detailProfile() {
    return Consumer<UserViewModel>(
      builder: (context, notifier, _) => Column(
        children: [
          _detailProfileItem('Full Name', notifier.user.fullName),
          SizedBox(height: 16.h),
          _detailProfileItem('Address', notifier.user.address),
          SizedBox(height: 16.h),
          _detailProfileItem('Email', notifier.user.email),
        ],
      ),
    );
  }

  Row _detailProfileItem(String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: AppFont.largeText.copyWith(
            color: const Color(0xFF999999),
          ),
        ),
        Text(text2, style: AppFont.largeText),
      ],
    );
  }
}
