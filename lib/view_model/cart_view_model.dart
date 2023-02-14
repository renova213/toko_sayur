import 'package:flutter/foundation.dart';
import 'package:toko_sayur/model/cart_model.dart';

import '../common/util/enum_state.dart';
import '../data/repository/remote_repository.dart';

class CartViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  List<CartModel> _productCarts = [];
  AppState _appState = AppState.loading;

  List<CartModel> get productCarts => _productCarts;
  AppState get appState => _appState;

  Future<void> getCart(String id) async {
    try {
      changeAppState(AppState.loading);
      _productCarts = await remoteRepository.getCartProducts(id);
      changeAppState(AppState.loaded);
      notifyListeners();
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
            e.prdocutId == productId &&
            e.categoryProductName == categoryProductName)
        .toList();

    return contains.isNotEmpty;
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
