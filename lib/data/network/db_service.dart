import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/model/register_model.dart';

import 'base_service.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class DBService implements BaseService {
  @override
  Future addDocument(String collectionName, Map<String, dynamic> data) async {
    try {
      await db.collection(collectionName).add(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addDocumentCustomID(
      String collectionName, Map<String, dynamic> data, String id) async {
    try {
      await db.collection(collectionName).doc(id).set(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getDocument(
      String collectionName) async {
    try {
      return await db.collection(collectionName).get();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentByID(
      String collectionName, String id) async {
    try {
      return await db.collection(collectionName).doc(id).get();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deleteDocument(String collectionName, String id) async {
    try {
      await db.collection(collectionName).doc(id).delete();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future updateDocument(
      String collectionName, Map<String, dynamic> data, String id) async {
    try {
      await db.collection(collectionName).doc(id).update(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<User> login(LoginModel login) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: login.email, password: login.password);

      return auth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  @override
  Future register(RegisterModel register) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: register.email, password: register.password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }
}
