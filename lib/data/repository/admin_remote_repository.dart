import 'dart:io';

import 'package:toko_sayur/model/product_model.dart';

import '../../model/checkout_model.dart';
import '../../model/user_model.dart';
import '../network/db_service.dart';

class AdminRemoteRepository {
  final DBService service = DBService();

  //product

  Future<void> updateProduct(Map<String, dynamic> product, String id) async {
    try {
      service.updateDocument("product", product, id);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await service.addDocument('product', product.toJson());
    } catch (_) {
      rethrow;
      // throw 'Failed Add Product';
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await service.deleteDocument('product', id);
    } catch (_) {
      throw 'Failed Add Product';
    }
  }

  //image
  Future<String> uploadImage(File file, String path) async {
    try {
      return await service.uploadImage(file, path);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      return await service.deleteImage(url);
    } catch (_) {
      rethrow;
    }
  }

//checkout
  Future<List<CheckoutModel>> getAllCheckoutProduct() async {
    try {
      List<CheckoutModel> checkouts = [];
      List<UserModel> users = [];

      await service.getDocument('user').then(
        (value) {
          for (var i in value.docs) {
            users.add(
              UserModel.fromMap(i.data()),
            );
          }
        },
      );

      for (var i in users) {
        await service.getSubCollectionByUserID('checkout', i.email).then(
          (value) {
            for (var i in value.docs) {
              checkouts.add(
                CheckoutModel.fromDoc(i),
              );
            }
          },
        );
      }
      return checkouts;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteCheckout(String id, String userId) async {
    try {
      await service.deleteSubCollectionByUserId('checkout', id, userId);
    } catch (_) {
      throw 'Failed Add Product';
    }
  }

  Future<void> updateCheckout(
      String id, String userId, CheckoutModel checkout) async {
    try {
      await service.updateSubCollectionByUserID(
          'checkout', id, userId, checkout.toJson());
    } catch (_) {
      rethrow;
    }
  }
}
