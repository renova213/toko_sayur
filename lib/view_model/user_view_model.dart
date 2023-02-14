import 'package:flutter/cupertino.dart';
import 'package:toko_sayur/model/user_model.dart';

import '../common/util/enum_state.dart';
import '../data/repository/remote_repository.dart';

class UserViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  late UserModel _user;
  AppState _appState = AppState.loading;

  UserModel get user => _user;
  AppState get appState => _appState;

  Future<void> getUser(String id) async {
    try {
      changeAppState(AppState.loading);
      _user = await remoteRepository.getUser(id);
      changeAppState(AppState.loaded);
      notifyListeners();
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> addUser(UserModel user, String id) async {
    try {
      await remoteRepository.addUser(user, id);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user, String id) async {
    try {
      await remoteRepository.updateUser(user, id);
      await getUser(id);
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
