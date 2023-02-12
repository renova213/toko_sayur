import 'package:flutter/cupertino.dart';
import 'package:toko_sayur/model/register_model.dart';

import '../data/repository/remote_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  Future<void> register(RegisterModel register) async {
    try {
      await remoteRepository.register(register);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
