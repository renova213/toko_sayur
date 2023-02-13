import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String productName;
  final String productImage;
  final String productDescription;
  final List<ProductCategoryModel> productCategory;

  ProductModel(
      {this.id,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.productCategory});

  factory ProductModel.fromDoc(DocumentSnapshot doc) => ProductModel(
      id: doc.id,
      productName: (doc.data() as Map)['productName'],
      productDescription: (doc.data() as Map)['productDescription'],
      productImage: (doc.data() as Map)['productImage'],
      productCategory: ((doc.data() as Map)['productCategory'] as List)
          .map((e) => ProductCategoryModel.fromMap(e))
          .toList());

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
            .toList()
      };
}

class ProductCategoryModel {
  final String categoryName;
  final String price;
  final String stock;

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
