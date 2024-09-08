/*
  
 */

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/models/order_models/order_search_model.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/utilities/enums.dart';

abstract class CustomerService {
  GlobalService globalService;
  List<String> cities;
  Future<ResultModel<CustomerModel>> retrieve();
  Future<ResultModel<CustomerModel>> update(CustomerModel model);
  Future<ResultModel<OrderModel>> orders(
      OrderSearchModel model, ActionType actionType);
}
