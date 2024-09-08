/*
  
 */

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/order_models/order_line_item_model.dart';
import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/models/order_models/order_search_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/ui/pages/order/cart/cart_viewmodel.dart';

abstract class OrderService {
  GlobalService globalService;
  CartViewModel cartViewModel;
  List<OrderLineItemModel> cart;
  List<OrderProductItemModel> products;
  List<ProductModel> easyAccessProducts;
  void add({OrderLineItemModel lineItem, ProductModel product});
  void remove(int productId);
  void addQuantity(int productId);
  void removeItem(int productId);
  bool find(int productId);
  int getQuantity(int productId);
  int getTotalQuantity();
  String getTotalPrice();
  Future<ResultModel<OrderModel>> retrieve(int id);
  Future<ResultModel<OrderModel>> list(
      OrderSearchModel model, ActionType actionType);
  Future<ResultModel<OrderModel>> create(OrderModel model);
}
