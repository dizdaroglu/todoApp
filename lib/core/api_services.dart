import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:todoapp/core/model/product.dart';
import 'package:todoapp/api.dart';

class ApiService {
  String _baseURL;

  static ApiService _instance = ApiService._privateConstructor();

  ApiService._privateConstructor() {
    _baseURL = api;
  }

  static ApiService getInstance() {
    if (_instance == null) {
      return ApiService._privateConstructor();
    }
    return _instance;
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get("$_baseURL/products.json");

    final jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        final productList = ProductList.fromJsonList(jsonResponse);
        return productList.products;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    Logger().e(jsonResponse);
    return Future.error(jsonResponse);
  }

  Future<void> addProducts(Product product) async {
    final jsonBody = json.encode(product.toJson());

    final response = await http.post("$_baseURL/products.json", body: jsonBody);
    Logger().i(response);

    final jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return Future.value(true);
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    Logger().e(jsonResponse);
    return Future.error(jsonResponse);
  }

  Future<void> removeProducts(String key) async {
    final response = await http.delete("$_baseURL/products/$key.json");

    final jsonResponse = jsonDecode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return Future.value(true);
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    Logger().e(jsonResponse);
    return Future.error(jsonResponse);
  }
}
