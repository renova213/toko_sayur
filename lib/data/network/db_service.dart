import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/model/register_model.dart';

import 'base_service.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;

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

  @override
  Future forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = storage.ref().child(path);
      final upload = ref.putFile(file);

      return await (await upload).ref.getDownloadURL();
    } catch (_) {
      throw 'Failed Upload Image';
    }
  }

  @override
  Future<void> deleteImage(String url) async {
    try {
      await storage.refFromURL(url).delete();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getSubCollectionByUserID(
      String collectionName, String id) async {
    try {
      return await db.collection(collectionName).doc(id).collection(id).get();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> addSubCollectionByUserID(
      String collectionName, String id, Map<String, dynamic> data) async {
    try {
      await db.collection(collectionName).doc(id).collection(id).add(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSubCollectionByUserId(
      String collection, String id, String userId) async {
    try {
      await db
          .collection(collection)
          .doc(userId)
          .collection(userId)
          .doc(id)
          .delete();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateSubCollectionByUserID(String collectionName, String id,
      String userId, Map<String, dynamic> data) async {
    try {
      await db
          .collection(collectionName)
          .doc(userId)
          .collection(userId)
          .doc(id)
          .update(data);
    } catch (_) {
      rethrow;
    }
  }
}
