import 'package:flutter/material.dart';
import 'package:toko_sayur/data/repository/remote_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();
  Future<void> forgotPassword(String email) async {
    try {
      await remoteRepository.forgotPassword(email);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
