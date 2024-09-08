/*
  
 */

import 'dart:convert';
import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/models/product_models/product_category_search_model.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:http/http.dart' as http;

import 'global_service_controller.dart';

class CategoryServiceController implements CategoryService {
  @override
  GlobalService globalService = GlobalServiceController();

  @override
  List<ProductCategoryModel> baseCategories = [
    ProductCategoryModel.createBase(
      id: 690,
      name: 'جدیدترین ها',
      parent: 84,
      slug: 'new',
      image: ImageModel.image(src: 'asset/images/new.png'),
    ),
    ProductCategoryModel.createBase(
      id: 84,
      name: 'خوراکه و نوشیدنی',
      parent: 0,
      slug: 'meal-and-drinks',
      image: ImageModel.image(src: 'asset/images/food.png'),
    ),
    ProductCategoryModel.createBase(
      id: 38,
      name: 'لوازم دیجیتالی',
      parent: 0,
      slug: 'digital',
      image: ImageModel.image(src: 'asset/images/homeappliance.png'),
    ),
    ProductCategoryModel.createBase(
      id: 86,
      name: 'سلامت و زیبائی',
      parent: 0,
      slug: 'health-and-beauty',
      image: ImageModel.image(src: 'asset/images/health.png'),
    ),
    ProductCategoryModel.createBase(
      id: 87,
      name: 'لوازم خانگی و دفتر',
      parent: 0,
      slug: 'home-appliances',
      image: ImageModel.image(src: 'asset/images/homeappliance.png'),
    ),
    ProductCategoryModel.createBase(
      id: 88,
      name: 'مد و فیشن',
      parent: 0,
      slug: 'fashion',
      image: ImageModel.image(src: 'asset/images/fashion.png'),
    ),
    ProductCategoryModel.createBase(
      id: 223,
      name: 'دکور و تزئینات',
      parent: 0,
      slug: 'decorations',
      image: ImageModel.image(src: 'asset/images/decor.png'),
    ),
    ProductCategoryModel.createBase(
      id: 215,
      name: 'کتاب و لوازم تحریر',
      parent: 0,
      slug: 'books',
      image: ImageModel.image(src: 'asset/images/book.png'),
    ),
    ProductCategoryModel.createBase(
      id: 89,
      name: 'اطفال',
      parent: 0,
      slug: 'babies',
      image: ImageModel.image(src: 'asset/images/baby.png'),
    ),
    ProductCategoryModel.createBase(
      id: 280,
      name: 'ابزار و تجهیزات صنعتی',
      parent: 0,
      slug: '',
      image: ImageModel.image(src: 'asset/images/industry.png'),
    ),
    ProductCategoryModel.createBase(
      id: 166,
      name: 'لوازم ورزشی',
      parent: 0,
      slug: 'sporting-goods',
      image: ImageModel.image(src: 'asset/images/sport.png'),
    ),
    ProductCategoryModel.createBase(
      id: 15,
      name: 'کتگوری های دیگر',
      parent: 0,
      slug: 'uncategorized',
      image: ImageModel.image(src: 'asset/images/other.png'),
    ),
  ];

  @override
  Future<ResultModel<ProductCategoryModel>> allCategories(
      ProductCategorySearchModel model) async {
    var result = ResultModel<ProductCategoryModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductCategoryModel>();

    var url =
        globalService.apiUrl + 'Products/Categories' + model.allQuery() + '&';

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
      result.results.add(ProductCategoryModel.fromJson(i));
    }
    return result;
  }

  @override
  Future<ResultModel<ProductCategoryModel>> randomCategory(
      ProductCategorySearchModel model) async {
    var result = ResultModel<ProductCategoryModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductCategoryModel>();

    var randomQuery = '?order=desc&orderby=count';

    var url = globalService.apiUrl + 'Products/Categories' + randomQuery + '&';

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
      result.results.add(ProductCategoryModel.fromJson(i));
    }
    return result;
  }

  @override
  Future<ResultModel<ProductCategoryModel>> searchCategories(
      ProductCategorySearchModel model) async {
    var result = ResultModel<ProductCategoryModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductCategoryModel>();

    var url = globalService.apiUrl +
        'Products/Categories' +
        model.searchQuery() +
        '&';

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
      result.results.add(ProductCategoryModel.fromJson(i));
    }
    return result;
  }

  @override
  Future<ResultModel<ProductCategoryModel>> subCategories(
      ProductCategorySearchModel model) async {
    var result = ResultModel<ProductCategoryModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<ProductCategoryModel>();

    var url =
        globalService.apiUrl + 'Products/Categories' + model.childQuery() + '&';

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
      result.results.add(ProductCategoryModel.fromJson(i));
    }
    return result;
  }
}
