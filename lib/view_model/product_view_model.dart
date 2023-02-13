import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_sayur/data/repository/admin_remote_repository.dart';
import 'package:toko_sayur/model/product_model.dart';

import '../common/util/enum_state.dart';

class ProductViewModel extends ChangeNotifier {
  final AdminRemoteRepository remoteRepository = AdminRemoteRepository();
  AppState _appState = AppState.loading;
  List<ProductModel> _products = [];
  List<ProductCategoryModel> _temporaryCategoryProducts = [];
  String? _urlProductImage;
  File? _image;
  String? _imageName;
  final _imagePicker = ImagePicker();

  AppState get appState => _appState;
  List<ProductModel> get products => _products;
  List<ProductCategoryModel> get temporaryCategoryProducts =>
      _temporaryCategoryProducts;
  String? get urlProductImage => _urlProductImage;
  File? get image => _image;
  String? get imageName => _imageName;

  Future<void> getProducts() async {
    try {
      changeAppState(AppState.loading);
      _products = await remoteRepository.getProducts();
      changeAppState(AppState.loaded);
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await remoteRepository.addProduct(product);
      getProducts();
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  //image
  Future<void> uploadProductImage() async {
    try {
      _urlProductImage = await remoteRepository.uploadImage(
          File(_image!.path), 'files/$_imageName');
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _image = File(image.path);
      _imageName = image.name;
    }
    notifyListeners();
  }

  Future<void> clearImage() async {
    _image = null;
    _urlProductImage = '';
    _imageName = '';
    notifyListeners();
  }

  //crud temporary category product
  Future<void> getTemporaryCategoryProduct(
      List<ProductCategoryModel> productCategories) async {
    _temporaryCategoryProducts = productCategories;
    notifyListeners();
  }

  Future<void> addTemporaryCategoryProduct(
      ProductCategoryModel productCategory) async {
    _temporaryCategoryProducts.add(productCategory);
    notifyListeners();
  }

  Future<void> deleteTemporaryCategoryProduct(int index) async {
    _temporaryCategoryProducts.removeAt(index);
    notifyListeners();
  }

  Future<void> updateTemporaryCategoryProduct(
      ProductCategoryModel productCategory, int index) async {
    _temporaryCategoryProducts.removeAt(index);
    _temporaryCategoryProducts.insert(index, productCategory);
    notifyListeners();
  }

  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
