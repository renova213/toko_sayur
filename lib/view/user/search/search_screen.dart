import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/view/widgets/button_widget.dart';
import 'package:toko_sayur/view_model/product_view_model.dart';

import '../../../common/style/style.dart';
import '../../../common/util/navigator_fade_helper.dart';
import '../../../model/favorite_model.dart';
import '../../../model/product_model.dart';
import '../../../view_model/favorite_view_model.dart';
import '../../../view_model/user_view_model.dart';
import '../../widgets/loading.dart';
import '../product/detail_product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        Provider.of<ProductViewModel>(context, listen: false)
            .recentSearch
            .clear();
        final userId =
            Provider.of<UserViewModel>(context, listen: false).user.id!;

        Provider.of<ProductViewModel>(context, listen: false)
            .saveRecentSearch(userId);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: Color(0xFFB7B7B7),
          ),
        ),
        title: Consumer<ProductViewModel>(
          builder: (context, product, _) => Consumer<UserViewModel>(
            builder: (context, user, _) => TextField(
              onSubmitted: (value) {
                product.addRecentSearch(value, user.user.id!);
                product.searchProduct(value);
              },
              controller: searchController,
              style: AppFont.largeText.copyWith(
                color: const Color(0xFF686161),
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(250, 250, 250, 1),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(250, 250, 250, 1),
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(250, 250, 250, 1),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFFB7B7B7),
            ),
          ),
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, product, _) {
          if (product.searchResult.isEmpty &&
              searchController.text.isNotEmpty) {
            return Center(
              child: Text('Pencarian tidak ditemukan', style: AppFont.subtitle),
            );
          }

          if (searchController.text.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _searchHistory(),
                  SizedBox(height: 40.h),
                  Consumer<UserViewModel>(
                    builder: (context, user, _) => ButtonWidget(
                      height: 45,
                      width: 255,
                      text: 'Clear History',
                      onTap: () {
                        product.clearRecentSearch(user.user.id!);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (product.searchResult.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.all(24.r),
              child: _listSearch(product.searchResult),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  GridView _listSearch(List<ProductModel> searchResult) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 12,
            crossAxisSpacing: 16,
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.35),
        itemBuilder: (context, index) {
          final data = searchResult[index];
          return Consumer<ProductViewModel>(
            builder: (context, product, _) => GestureDetector(
              onTap: () {
                product.changeIndexProductCategory(0);
                Navigator.of(context).push(
                  NavigatorFadeHelper(
                    child: DetailProductScreen(product: data),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12.r),
                color: const Color(0xFFF5F5F5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          width: double.maxFinite,
                          height: 120.h,
                          fit: BoxFit.fill,
                          imageUrl: data.productImage,
                          placeholder: (context, url) => const Loading(
                              width: double.maxFinite,
                              height: 120,
                              borderRadius: 0),
                          errorWidget: (context, url, error) => Image.asset(
                              'placeholder_image',
                              width: double.maxFinite,
                              height: 120.h),
                        ),
                        Positioned(
                          left: 100.w,
                          bottom: 70.h,
                          child: Consumer<FavoriteViewModel>(
                            builder: (context, favorite, _) =>
                                Consumer<UserViewModel>(
                              builder: (context, user, _) => IconButton(
                                onPressed: () async {
                                  if (favorite.checkProductFavorite(data.id!)) {
                                    Fluttertoast.showToast(
                                        msg: 'Already added in favorite');
                                  } else {
                                    try {
                                      await favorite
                                          .addFavoriteProduct(
                                              FavoriteModel(
                                                  productId: data.id!),
                                              user.user.id!)
                                          .then((_) => Fluttertoast.showToast(
                                              msg: 'Added to cart'));
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  }
                                },
                                icon: const Icon(Icons.star,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(data.productName,
                        style: AppFont.boldMediumText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center),
                    SizedBox(height: 8.h),
                    Text(
                        data.productCategory.length == 1
                            ? 'Rp. ${data.productCategory.first.price}'
                            : 'Rp. ${data.productCategory.first.price} - ${data.productCategory.last.price}',
                        style: AppFont.smallText
                            .copyWith(color: AppColor.secondaryColor),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: searchResult.length);
  }

  Consumer _searchHistory() {
    return Consumer<ProductViewModel>(
      builder: (context, product, _) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: product.recentSearch.length,
        itemBuilder: (context, index) {
          final data = product.recentSearch[index];

          return GestureDetector(
            onTap: () {
              searchController.text = data;
              product.searchProduct(data);
            },
            child: Container(
              height: 60.h,
              width: double.maxFinite,
              padding: EdgeInsets.only(left: 30.w, right: 10.w),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFB7B7B7),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data, style: AppFont.mediumText),
                  Consumer<UserViewModel>(
                    builder: (context, user, _) => IconButton(
                      onPressed: () {
                        product.removeRecentSearch(index, user.user.id!);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFB7B7B7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
