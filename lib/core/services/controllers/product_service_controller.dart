/*
  
 */

import 'dart:convert';
import 'dart:math';

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/services/product_service.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:http/http.dart' as http;

import 'global_service_controller.dart';

class ProductServiceController implements ProductService {
  @override
  GlobalService globalService = GlobalServiceController();

  @override
  Future<ResultModel<ProductModel>> randomProducts() async {
    var result = ResultModel<ProductModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductModel>();

    var random = Random();

    var randomPage = random.nextInt(10) + 1;

    var randomQuery = '?page=$randomPage&per_page=7';

    var url = globalService.apiUrl + 'Products' + randomQuery + '&';

    url = globalService.addKeys(url);

    print(url);

    var response = await http.get(
      url,
    );

    if (response.statusCode != 200) {
      result.isSuccess = false;
      result.message = response.body;
      return result;
    }

    List data = json.decode(response.body);

    for (var i in data) {
      result.results.add(ProductModel.fromJson(i));
    }
    return result;
  }

  @override
  Future<ResultModel<ProductModel>> retrieve(int id) async {
    var result = ResultModel<ProductModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.result = ProductModel();

    var url = globalService.apiUrl + 'Products/' + id.toString() + '?';

    url = globalService.addKeys(url);

    print(url);

    var response = await http.get(
      url,
    );

    if (response.statusCode != 200) {
      result.isSuccess = false;
      result.message = response.body;
      return result;
    }

    var model = json.decode(response.body);

    result.result = ProductModel.fromJson(model);

    return result;
  }

  @override
  Future<ResultModel<ProductModel>> list(
      ProductSearchModel model, ActionType actionType) async {
    var result = ResultModel<ProductModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductModel>();

    var url = globalService.apiUrl + 'Products';

    if (actionType == ActionType.Latest) {
      url += model.latestQuery();
    } else if (actionType == ActionType.Category) {
      url += model.categoryQuery();
    } else if (actionType == ActionType.Search) {
      url += model.searchQuery();
    } else if (actionType == ActionType.SearchAndCategory) {
      url += model.searchAndCategoryQuery();
    } else if (actionType == ActionType.Include) {
      url += model.includeQuery();
    }

    url += '&';

    url = globalService.addKeys(url);

    print(url);

    var response = await http.get(
      url,
    );

    if (response.statusCode != 200) {
      result.isSuccess = false;
      result.message = response.body;
      return result;
    }

    List data = json.decode(response.body);

    for (var i in data) {
      result.results.add(ProductModel.fromJson(i));
    }
    return result;
  }
}
