import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String? id;
  final String prdocutId;
  final String productName;
  final String productImage;
  final String productDescription;
  final String categoryProductName;
  final String price;

  CartModel(
      {this.id,
      required this.prdocutId,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.categoryProductName,
      required this.price});

  factory CartModel.fromDoc(DocumentSnapshot doc) => CartModel(
      id: doc.id,
      prdocutId: (doc.data() as Map)['prdocutId'],
      productName: (doc.data() as Map)['productName'],
      productDescription: (doc.data() as Map)['productDescription'],
      productImage: (doc.data() as Map)['productImage'],
      price: (doc.data() as Map)['price'],
      categoryProductName: (doc.data() as Map)['categoryProductName']);

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'prdocutId': prdocutId,
        'productImage': productImage,
        'productDescription': productDescription,
        'price': price,
        'categoryProductName': categoryProductName
      };
}
