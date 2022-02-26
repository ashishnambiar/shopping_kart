import 'dart:convert';

class ProductsModel {
  ProductsModel(
    this.pName,
    this.pId,
    this.pCost,
    this.pAvail,
    this.pDetails,
    this.pCategory,
  );

  String pName;
  int pId;
  int pCost;
  int pAvail;
  String? pDetails;
  String? pCategory;

  factory ProductsModel.fromJson(Map json) {
    return ProductsModel(
      json['p_name'],
      json['p_id'],
      json['p_cost'],
      json['p_availability'],
      json['p_details'],
      json['p_category'],
    );
  }
}

List<ProductsModel> getProductsFromJson(String str) {
  List json = jsonDecode(str);
  return json.map((e) => ProductsModel.fromJson(e)).toList();
}
