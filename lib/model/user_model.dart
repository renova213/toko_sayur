class UserModel {
  final String fullName;
  final String email;
  final String address;
  String? role;
  String? image;

  UserModel(
      {required this.fullName,
      required this.email,
      required this.address,
      this.role,
      this.image});

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
      fullName: map['fullName'],
      email: map['email'],
      address: map['address'],
      role: map['role'],
      image: map['image'] ?? '');

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'address': address,
        'image': image ?? '',
        'role': 'user'
      };
}
