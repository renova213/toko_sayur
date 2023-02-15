import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String? id;
  int quantityProduct;
  final String productId;
  final String productName;
  final String productImage;
  final String productDescription;
  final String categoryProductName;
  final String price;

  CartModel(
      {this.id,
      required this.quantityProduct,
      required this.productId,
      required this.productName,
      required this.productImage,
      required this.productDescription,
      required this.categoryProductName,
      required this.price});

  factory CartModel.fromDoc(DocumentSnapshot doc) => CartModel(
      id: doc.id,
      quantityProduct: (doc.data() as Map)['quantityProduct'],
      productId: (doc.data() as Map)['productId'],
      productName: (doc.data() as Map)['productName'],
      productDescription: (doc.data() as Map)['productDescription'],
      productImage: (doc.data() as Map)['productImage'],
      price: (doc.data() as Map)['price'],
      categoryProductName: (doc.data() as Map)['categoryProductName']);

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'quantityProduct': quantityProduct,
        'productId': productId,
        'productImage': productImage,
        'productDescription': productDescription,
        'price': price,
        'categoryProductName': categoryProductName
      };
}
