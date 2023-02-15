import 'package:firebase_auth/firebase_auth.dart';
import 'package:toko_sayur/data/network/db_service.dart';
import 'package:toko_sayur/data/repository/admin_remote_repository.dart';
import 'package:toko_sayur/model/favorite_model.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/model/register_model.dart';
import 'package:toko_sayur/model/user_model.dart';

import '../../model/cart_model.dart';
import '../../model/checkout_model.dart';
import '../../model/product_model.dart';

class RemoteRepository {
  final DBService service = DBService();
  final AdminRemoteRepository adminService = AdminRemoteRepository();

  //auth
  Future<User> login(LoginModel login) async {
    try {
      return await service.login(login);
    } catch (_) {
      rethrow;
    }
  }

  Future register(RegisterModel register) async {
    try {
      return await service.register(register);
    } catch (_) {
      rethrow;
    }
  }

  Future forgotPassword(String email) async {
    try {
      return await service.forgotPassword(email);
    } catch (_) {
      rethrow;
    }
  }

  //product
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

  //user
  Future<void> addUser(UserModel user, String id) async {
    try {
      service.addDocumentCustomID('user', user.toJson(), id);
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      return await service.getDocumentByID('user', id).then(
            (e) => UserModel.fromDoc(e),
          );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user, String id) async {
    try {
      await service.updateDocument('user', user.toJson(), id);
    } catch (_) {
      rethrow;
    }
  }

  //cart
  Future<List<CartModel>> getCartProducts(String userId) async {
    try {
      List<CartModel> carts = [];

      await service.getSubCollectionByUserID('cart', userId).then(
        (value) {
          for (var i in value.docs) {
            carts.add(
              CartModel.fromDoc(i),
            );
          }
        },
      );
      return carts;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addProductCart(CartModel user, String id) async {
    try {
      service.addSubCollectionByUserID('cart', id, user.toJson());
    } catch (_) {
      rethrow;
    }
  }

  //favorite
  Future<List<FavoriteModel>> getFavoriteProducts(String userId) async {
    try {
      List<ProductModel> products = await getProducts();

      List<FavoriteModel> temporaryFavoriteProducts = [];
      List<FavoriteModel> favoriteProducts = [];

      await service.getSubCollectionByUserID('favorite', userId).then(
        (value) {
          for (var i in value.docs) {
            temporaryFavoriteProducts.add(
              FavoriteModel.fromDoc(i),
            );
          }
        },
      );

      for (var i in products) {
        for (var j in temporaryFavoriteProducts) {
          if (i.id! == j.productId) {
            favoriteProducts.add(
              FavoriteModel(
                id: j.id,
                productId: j.productId,
                productName: i.productName,
                productImage: i.productImage,
                productDescription: i.productDescription,
                productCategory: i.productCategory
                    .map(
                      (e) => FavoriteProductCategoryModel(
                          categoryName: e.categoryName,
                          price: e.price,
                          stock: e.stock),
                    )
                    .toList(),
              ),
            );
          }
        }
      }

      return favoriteProducts;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addFavoriteProduct(
      FavoriteModel favoriteProduct, String id) async {
    try {
      service.addSubCollectionByUserID(
          'favorite', id, favoriteProduct.toJson());
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteFavoriteProduct(String id, String userId) async {
    try {
      service.deleteSubCollectionByUserId('favorite', id, userId);
    } catch (_) {
      rethrow;
    }
  }

  //checkout
  Future<void> addCheckoutProduct(CheckoutModel checkout, String userId) async {
    try {
      service.addSubCollectionByUserID('checkout', userId, checkout.toJson());
    } catch (_) {
      rethrow;
    }
  }
}
