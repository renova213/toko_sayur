import 'package:flutter/foundation.dart';
import 'package:toko_sayur/model/cart_model.dart';
import '../common/util/enum_state.dart';
import '../data/repository/remote_repository.dart';
import '../model/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  List<CartModel> _productCarts = [];
  final List<CartModel> _temporaryProductCarts = [];
  AppState _appState = AppState.loading;

  List<CartModel> get productCarts => _productCarts;
  List<CartModel> get temporaryProductCarts => _temporaryProductCarts;
  AppState get appState => _appState;

  Future<void> getCart(String id) async {
    try {
      changeAppState(AppState.loading);
      _productCarts = await remoteRepository.getCartProducts(id);
      changeAppState(AppState.loaded);
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> addProductCart(CartModel cart, String id) async {
    try {
      await remoteRepository.addProductCart(cart, id);
      await getCart(id);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  bool checkProductCart(String productId, String categoryProductName) {
    final contains = productCarts
        .where((e) =>
            e.productId == productId &&
            e.categoryProductName == categoryProductName)
        .toList();

    return contains.isNotEmpty;
  }

  //crud temporaryCartProduct
  Future<void> addTemporaryProductCart(CartModel cart) async {
    _temporaryProductCarts.add(cart);

    notifyListeners();
  }

  Future<void> deleteTemporaryProductCart(CartModel cart, int index) async {
    _temporaryProductCarts.removeWhere((e) => e.id == cart.id);
    notifyListeners();
  }

  bool checkCartContains(CartModel cart) {
    final contains =
        _temporaryProductCarts.where((e) => e.id == cart.id).toList();

    return contains.isEmpty;
  }

  Future<void> clearTemporaryProductCart() async {
    _temporaryProductCarts.clear();
    notifyListeners();
  }

  void addQuantityProduct(List<ProductModel> products, CartModel cart) {
    int stock = 0;

    for (var i in products) {
      stock = 1;
      if (i.id == cart.productId) {
        for (var j in i.productCategory) {
          if (j.categoryName == cart.categoryProductName) {
            stock = int.parse(j.stock);
          }
        }
      }
    }
    if (cart.quantityProduct < stock) {
      cart.quantityProduct += 1;
    }
    notifyListeners();
  }

  void minusQuantityProduct(CartModel cart) {
    if (cart.quantityProduct > 1) {
      cart.quantityProduct -= 1;
      notifyListeners();
    }
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
