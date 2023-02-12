import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toko_sayur/data/repository/remote_repository.dart';
import 'package:toko_sayur/model/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  late User user;
  final RemoteRepository remoteRepository = RemoteRepository();

  Future<void> login(LoginModel login) async {
    try {
      user = await remoteRepository.login(login);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
