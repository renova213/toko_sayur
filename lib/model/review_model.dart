import 'package:toko_sayur/model/user_model.dart';

class ReviewModel {
  final String review;
  final UserModel user;

  ReviewModel({required this.review, required this.user});

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        review: map['review'],
        user: UserModel.fromMap(
          map['user'],
        ),
      );

  Map<String, dynamic> toJson() => {
        'review': review,
        'user': user.toJson(),
      };
}
