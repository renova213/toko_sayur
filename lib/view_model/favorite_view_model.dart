import 'package:flutter/foundation.dart';
import 'package:toko_sayur/model/favorite_model.dart';

import '../common/util/enum_state.dart';
import '../data/repository/remote_repository.dart';

class FavoriteViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  List<FavoriteModel> _favoriteProducts = [];
  AppState _appState = AppState.loading;

  List<FavoriteModel> get favoriteProducts => _favoriteProducts;
  AppState get appState => _appState;

  Future<void> getFavoriteProducts(String id) async {
    try {
      changeAppState(AppState.loading);
      _favoriteProducts = await remoteRepository.getFavoriteProducts(id);
      changeAppState(AppState.loaded);
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> addFavoriteProduct(
      FavoriteModel favoriteProducts, String id) async {
    try {
      await remoteRepository.addFavoriteProduct(favoriteProducts, id);
      await getFavoriteProducts(id);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteFavoriteProduct(String userId, String id) async {
    try {
      await remoteRepository.deleteFavoriteProduct(id, userId);
      await getFavoriteProducts(userId);
    } catch (_) {
      rethrow;
    }
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
