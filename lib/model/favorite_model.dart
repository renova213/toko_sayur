import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_sayur/model/review_model.dart';

class FavoriteModel {
  final String? id;
  final String productId;
  final List<ReviewModel> reviews;
  final String? productName;
  final String? productImage;
  final String? productDescription;
  final List<FavoriteProductCategoryModel>? productCategory;

  FavoriteModel(
      {this.id,
      required this.productId,
      required this.reviews,
      this.productName,
      this.productImage,
      this.productDescription,
      this.productCategory});

  factory FavoriteModel.fromDoc(DocumentSnapshot doc) => FavoriteModel(
      id: doc.id,
      productId: (doc.data() as Map)['productId'],
      productName: (doc.data() as Map)['productName'] ?? '',
      productDescription: (doc.data() as Map)['productDescription'] ?? '',
      productImage: (doc.data() as Map)['productImage'] ?? '',
      productCategory: (doc.data() as Map)['productCategory'] != null
          ? ((doc.data() as Map)['productCategory'] as List)
              .map((e) => FavoriteProductCategoryModel.fromMap(e))
              .toList()
          : [],
      reviews: (doc.data() as Map)['reviews'] != null
          ? ((doc.data() as Map)['reviews'] as List)
              .map((e) => ReviewModel.fromMap(e))
              .toList()
          : []);

  Map<String, dynamic> toJson() => {
        'productId': productId,
      };
}

class FavoriteProductCategoryModel {
  String? categoryName;
  String? price;
  String? stock;

  FavoriteProductCategoryModel({this.categoryName, this.price, this.stock});

  factory FavoriteProductCategoryModel.fromMap(Map<String, dynamic> map) =>
      FavoriteProductCategoryModel(
        categoryName: map['categoryName'] ?? '',
        price: map['price'] ?? '',
        stock: map['stock'] ?? '',
      );
}
