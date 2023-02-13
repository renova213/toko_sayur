import 'package:firebase_auth/firebase_auth.dart';
import 'package:toko_sayur/data/network/db_service.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/model/register_model.dart';
import 'package:toko_sayur/model/user_model.dart';

class RemoteRepository {
  final DBService service = DBService();

  Future<User> login(LoginModel login) async {
    try {
      return await service.login(login);
    } catch (_) {
      rethrow;
    }
  }

  Future register(RegisterModel register) async {
    try {
      return await service.register(register);
    } catch (_) {
      rethrow;
    }
  }

  Future forgotPassword(String email) async {
    try {
      return await service.forgotPassword(email);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addUser(UserModel user, String id) async {
    try {
      service.addDocumentCustomID('user', user.toJson(), id);
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      return await service
          .getDocumentByID('user', id)
          .then((e) => UserModel.fromMap(e.data()!));
    } catch (_) {
      rethrow;
    }
  }
}
