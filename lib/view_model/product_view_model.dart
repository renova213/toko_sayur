import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_sayur/data/repository/admin_remote_repository.dart';
import 'package:toko_sayur/data/repository/remote_repository.dart';
import 'package:toko_sayur/model/product_model.dart';

import '../common/util/enum_state.dart';
import '../model/checkout_model.dart';

class ProductViewModel extends ChangeNotifier {
  final AdminRemoteRepository remoteRepository = AdminRemoteRepository();
  final RemoteRepository repository = RemoteRepository();

  AppState _appState = AppState.loading;
  List<ProductModel> _products = [];
  List<ProductCategoryModel> _temporaryCategoryProducts = [];
  String? _urlProductImage;
  File? _image;
  String? _imageName;
  final _imagePicker = ImagePicker();
  int _indexProductCategory = 0;

  AppState get appState => _appState;
  List<ProductModel> get products => _products;
  List<ProductCategoryModel> get temporaryCategoryProducts =>
      _temporaryCategoryProducts;
  String? get urlProductImage => _urlProductImage;
  File? get image => _image;
  String? get imageName => _imageName;
  int get indexProductCategory => _indexProductCategory;

  //crud product
  Future<void> getProducts() async {
    try {
      changeAppState(AppState.loading);
      _products = await repository.getProducts();
      changeAppState(AppState.loaded);
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  Future<void> updateProduct(Map<String, dynamic> product, String id) async {
    try {
      await remoteRepository.updateProduct(product, id);
      await getProducts();
    } catch (_) {
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

  Future<void> deleteProduct(String id) async {
    try {
      await remoteRepository.deleteProduct(id);
      getProducts();
    } catch (_) {
      changeAppState(AppState.failed);
      rethrow;
    }
  }

  //crud image
  Future<void> uploadProductImage() async {
    try {
      _urlProductImage = await remoteRepository.uploadImage(
          File(_image!.path), 'files/$_imageName');
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      await remoteRepository.deleteImage(url);
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

  Future<void> getUrlProductImage(String url) async {
    _urlProductImage = url;
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

  //index change
  Future<void> changeIndexProductCategory(int index) async {
    _indexProductCategory = index;
    notifyListeners();
  }

  //stock
  Future<void> updateStock(CheckoutModel checkout) async {
    List<ProductModel> products = [];

    for (var i in checkout.products) {
      products += _products
          .where((e) =>
              e.id == i.productId &&
              e.productCategory
                  .where((e) => e.categoryName == i.categoryProductName)
                  .isNotEmpty)
          .toList();
    }

    for (var i in checkout.products) {
      for (var j in products) {
        if (i.productId == j.id) {
          for (var k in j.productCategory) {
            if (k.categoryName == i.categoryProductName) {
              k.stock = (int.parse(k.stock) - i.quantityProduct).toString();
            }
          }
        }
      }
    }

    for (var i in products) {
      updateProduct(i.toJson(), i.id!);
    }

    notifyListeners();
  }

  //appstate
  void changeAppState(AppState appState) {
    _appState = appState;
    notifyListeners();
  }
}
