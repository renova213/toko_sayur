import 'package:flutter/material.dart';
import 'package:toko_sayur/data/repository/admin_remote_repository.dart';

import '../common/util/enum_state.dart';
import '../model/checkout_model.dart';

class AdminCheckoutViewModel extends ChangeNotifier {
  final AdminRemoteRepository remoteRepository = AdminRemoteRepository();

  List<CheckoutModel> _checkoutProducts = [];
  AppState _appState = AppState.loading;

  List<CheckoutModel> get checkoutProducts => _checkoutProducts;
  AppState get appState => _appState;

  Future<void> getAllCheckoutProducts() async {
    try {
      changeAppState(AppState.loading);
      _checkoutProducts = await remoteRepository.getAllCheckoutProduct();
      changeAppState(AppState.loaded);
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> updateCheckoutProducts(
      String id, String userId, CheckoutModel checkout) async {
    try {
      await remoteRepository.updateCheckout(id, userId, checkout);
      await getAllCheckoutProducts();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteCheckoutProducts(String id, String userId) async {
    try {
      await remoteRepository.deleteCheckout(id, userId);
      await getAllCheckoutProducts();
    } catch (_) {
      rethrow;
    }
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
