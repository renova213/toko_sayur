import 'package:flutter/material.dart';
import 'package:toko_sayur/model/checkout_model.dart';

import '../common/util/enum_state.dart';
import '../data/repository/remote_repository.dart';

class CheckoutViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  final List<CheckoutModel> _checkoutProducts = [];
  AppState _appState = AppState.loading;

  List<CheckoutModel> get checkoutProducts => _checkoutProducts;
  AppState get appState => _appState;

  // Future<void> getUser(String id) async {
  //   try {
  //     changeAppState(AppState.loading);
  //     _checkoutProducts = await remoteRepository.get(id);
  //     changeAppState(AppState.loaded);
  //     notifyListeners();
  //   } catch (_) {
  //     changeAppState(AppState.failed);
  //     rethrow;
  //   }
  // }

  Future<void> addCheckoutProduct(CheckoutModel checkout, String userId) async {
    try {
      await remoteRepository.addCheckoutProduct(checkout, userId);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
