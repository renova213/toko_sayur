import 'dart:io';

import 'package:toko_sayur/model/product_model.dart';

import '../network/db_service.dart';

class AdminRemoteRepository {
  final DBService service = DBService();

  Future<List<ProductModel>> getProducts() async {
    try {
      List<ProductModel> products = [];

      await service.getDocument('product').then(
        (value) {
          for (var i in value.docs) {
            products.add(
              ProductModel.fromDoc(i),
            );
          }
        },
      );

      return products;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await service.addDocument('product', product.toJson());
    } catch (_) {
      throw 'Failed Add Product';
    }
  }

  Future<String> uploadImage(File file, String path) async {
    try {
      return await service.uploadImage(file, path);
    } catch (_) {
      rethrow;
    }
  }
}
