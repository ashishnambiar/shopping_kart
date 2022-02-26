import 'package:flutter/material.dart';
import 'package:shopping_kart/Models/products_model.dart';
import 'package:shopping_kart/constants.dart';
import 'package:http/http.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductsModel> _allProducts = [];
  String _response = '';
  String _selectedCategory = '';
  Map<String, int> quantity = {};
  String _item = '';

  set tappedItem(String str) {
    _item = str;
    return;
  }

  String get item => _item;
  String get selectedCategory => _selectedCategory;
  String get response => _response;
  List<ProductsModel> get allProducts => _allProducts;

  Future<void> getData() async {
    String url = productsUrl;
    Client client = Client();
    Response res = await client.get(Uri.parse(url));
    _response = res.body;
    _allProducts = getProductsFromJson(res.body);
    clearQuantity();
    notifyListeners();
  }

  clearQuantity() {
    for (var e in _allProducts) {
      quantity.addAll({e.pName: 0});
    }
  }

  add(String key) {
    quantity[key] = quantity[key]! + 1;
    notifyListeners();
  }

  remove(String key) {
    if (quantity[key]! > 0) quantity[key] = quantity[key]! - 1;
    notifyListeners();
  }

  getSelectedCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  clearSelectedCatagory() {
    _selectedCategory = '';
    notifyListeners();
  }
}
