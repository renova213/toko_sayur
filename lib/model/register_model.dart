class RegisterModel {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String password;

  RegisterModel(
      {required this.fullName,
      required this.email,
      required this.address,
      required this.phone,
      required this.password});
}
