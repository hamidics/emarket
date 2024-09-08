/*
  
 */

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/utilities/enums.dart';

abstract class ProductService {
  GlobalService globalService;

  Future<ResultModel<ProductModel>> randomProducts();

  Future<ResultModel<ProductModel>> retrieve(int id);

  Future<ResultModel<ProductModel>> list(
      ProductSearchModel model, ActionType actionType);
}
