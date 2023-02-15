import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutModel {
  String? id;
  final int statusOrder;
  final List<CheckoutProductModel> products;

  CheckoutModel({required this.statusOrder, required this.products});

  factory CheckoutModel.fromDoc(DocumentSnapshot doc) => CheckoutModel(
      statusOrder: (doc as Map)['statusOrder'],
      products: ((doc as Map)['statusOrder'] as List)
          .map((e) => CheckoutProductModel.fromMap(e))
          .toList());

  Map<String, dynamic> toJson() => {
        'statusOrder': statusOrder,
        'products': products
            .map(
              (e) => CheckoutProductModel(
                      productId: e.productId,
                      quantityProduct: e.quantityProduct,
                      productName: e.productName,
                      productImage: e.productImage,
                      productDescription: e.productDescription,
                      categoryProductName: e.categoryProductName,
                      price: e.price)
                  .toJson(),
            )
            .toList()
      };
}

class CheckoutProductModel {
  final String productId;
  final int quantityProduct;
  final String productName;
  final String productImage;
  final String productDescription;
  final String categoryProductName;
  final String price;

  CheckoutProductModel(
      {required this.productId,
      required this.quantityProduct,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.categoryProductName,
      required this.price});

  factory CheckoutProductModel.fromMap(Map<String, dynamic> map) =>
      CheckoutProductModel(
          productId: map['prdocutId'],
          quantityProduct: map['quantityProduct'],
          productName: map['productName'],
          productDescription: map['productDescription'],
          productImage: map['productImage'],
          price: map['price'],
          categoryProductName: map['categoryProductName']);

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantityProduct': quantityProduct,
        'productName': productName,
        'productImage': productImage,
        'productDescription': productDescription,
        'price': price,
        'categoryProductName': categoryProductName
      };
}
