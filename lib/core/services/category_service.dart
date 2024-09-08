/*
  
 */

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_category_search_model.dart';
import 'package:eMarket/core/services/global_service.dart';

abstract class CategoryService {
  GlobalService globalService;

  List<ProductCategoryModel> baseCategories;

  Future<ResultModel<ProductCategoryModel>> allCategories(
      ProductCategorySearchModel model);

  Future<ResultModel<ProductCategoryModel>> randomCategory(
      ProductCategorySearchModel model);

  Future<ResultModel<ProductCategoryModel>> searchCategories(
      ProductCategorySearchModel model);

  Future<ResultModel<ProductCategoryModel>> subCategories(
      ProductCategorySearchModel model);
}
