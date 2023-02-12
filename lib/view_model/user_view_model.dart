import 'package:flutter/cupertino.dart';
import 'package:toko_sayur/model/user_model.dart';

import '../data/repository/remote_repository.dart';

class UserViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  late UserModel _user;

  UserModel get user => _user;

  Future<void> getUser(String id) async {
    _user = await remoteRepository.getUser(id);
    notifyListeners();
  }

  Future<void> addUser(UserModel user, String id) async {
    await remoteRepository.addUser(user, id);
    notifyListeners();
  }
}
