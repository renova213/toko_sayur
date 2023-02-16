import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toko_sayur/model/login_model.dart';
import 'package:toko_sayur/model/register_model.dart';

abstract class BaseService {
  Future addDocument(String collectionName, Map<String, dynamic> data);
  Future addDocumentCustomID(
      String collectionName, Map<String, dynamic> data, String id);
  Future<void> addSubCollectionByUserID(
      String collectionName, String id, Map<String, dynamic> data);
  Future<void> updateSubCollectionByUserID(String collectionName, String id,
      String userId, Map<String, dynamic> data);
  Future<void> setDocument(
      String collectionName, String id, Map<String, dynamic> data);
  Future updateDocument(
      String collectionName, Map<String, dynamic> data, String id);
  Future deleteDocument(String collectionName, String id);
  Future<QuerySnapshot<Map<String, dynamic>>> getDocument(
      String collectionName);
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentByID(
      String collectionName, String id);
  Future<QuerySnapshot<Map<String, dynamic>>> getSubCollectionByUserID(
      String collectionName, String id);
  Future<User> login(LoginModel login);
  Future register(RegisterModel register);
  Future forgotPassword(String email);
  Future<String> uploadImage(File file, String path);
  Future<void> deleteImage(String url);
  Future<void> deleteSubCollectionByUserId(
      String collection, String id, String userId);
}
