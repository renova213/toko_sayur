import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  final String fullName;
  final String email;
  final String address;
  final String phone;
  String? role;
  String? image;

  UserModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.address,
      required this.phone,
      this.role,
      this.image});

  factory UserModel.fromDoc(DocumentSnapshot doc) => UserModel(
      id: doc.id,
      fullName: (doc.data() as Map)['fullName'],
      email: (doc.data() as Map)['email'],
      phone: (doc.data() as Map)['phone'],
      address: (doc.data() as Map)['address'],
      role: (doc.data() as Map)['role'],
      image: (doc.data() as Map)['image'] ?? '');

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        fullName: map['fullName'],
        email: map['email'],
        phone: map['phone'],
        address: map['address'],
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'address': address,
        'phone': phone,
        'image': image ?? '',
        'role': 'user'
      };
}
