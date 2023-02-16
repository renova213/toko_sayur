import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_sayur/model/review_model.dart';

class ProductModel {
  final String? id;
  final String productName;
  final String productImage;
  final String productDescription;
  final List<ReviewModel> reviews;
  final List<ProductCategoryModel> productCategory;

  ProductModel(
      {this.id,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.productCategory,
      required this.reviews});

  factory ProductModel.fromDoc(DocumentSnapshot doc) => ProductModel(
      id: doc.id,
      productName: (doc.data() as Map)['productName'],
      productDescription: (doc.data() as Map)['productDescription'],
      productImage: (doc.data() as Map)['productImage'],
      productCategory: ((doc.data() as Map)['productCategory'] as List)
          .map((e) => ProductCategoryModel.fromMap(e))
          .toList(),
      reviews: (doc.data() as Map)['reviews'] != null
          ? ((doc.data() as Map)['reviews'] as List)
              .map((e) => ReviewModel.fromMap(e))
              .toList()
          : []);

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productImage': productImage,
        'productDescription': productDescription,
        'productCategory': productCategory
            .map((e) => ProductCategoryModel(
                    categoryName: e.categoryName,
                    price: e.price,
                    stock: e.stock)
                .toJson())
            .toList(),
        'reviews': reviews.isEmpty
            ? []
            : reviews
                .map(
                    (e) => ReviewModel(review: e.review, user: e.user).toJson())
                .toList()
      };

  Map<String, dynamic> review() => {
        'reviews': reviews
            .map((e) => ReviewModel(review: e.review, user: e.user).toJson())
            .toList()
      };
}

class ProductCategoryModel {
  final String categoryName;
  final String price;
  String stock;

  ProductCategoryModel(
      {required this.categoryName, required this.price, required this.stock});

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) =>
      ProductCategoryModel(
        categoryName: map['categoryName'],
        price: map['price'],
        stock: map['stock'],
      );

  Map<String, dynamic> toJson() =>
      {'categoryName': categoryName, 'price': price, 'stock': stock};
}
