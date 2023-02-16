import 'package:flutter/material.dart';
import 'package:toko_sayur/data/repository/remote_repository.dart';
import 'package:toko_sayur/model/product_model.dart';
import 'package:toko_sayur/model/review_model.dart';

class ReviewViewModel extends ChangeNotifier {
  final RemoteRepository remoteRepository = RemoteRepository();

  Future<void> addReview(List<ReviewModel> review, String productId) async {
    try {
      await remoteRepository.addReview(review, productId);
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  bool checkContainReview(List<ProductModel> reviews, String userId) {
    final contains = reviews
        .where((e) =>
            e.reviews.where((e) => e.user.email == userId).toList().isNotEmpty)
        .toList();

    return contains.isEmpty;
  }
}
