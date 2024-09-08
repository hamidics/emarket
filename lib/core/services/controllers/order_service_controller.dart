/*
  
 */

import 'dart:convert';

import 'package:eMarket/core/models/common_models/result_model.dart';
import 'package:eMarket/core/models/order_models/order_line_item_model.dart';
import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/models/order_models/order_search_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/services/controllers/global_service_controller.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/services/order_service.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/ui/pages/order/cart/cart_viewmodel.dart';
import 'package:http/http.dart' as http;

class OrderServiceController implements OrderService {
  @override
  GlobalService globalService = GlobalServiceController();

  @override
  CartViewModel cartViewModel;

  @override
  List<OrderLineItemModel> cart = List<OrderLineItemModel>();

  @override
  List<OrderProductItemModel> products = List<OrderProductItemModel>();

  @override
  List<ProductModel> easyAccessProducts = List<ProductModel>();

  @override
  void add({OrderLineItemModel lineItem, ProductModel product}) {
    var item = cart.firstWhere(
        (element) => element.productId == lineItem.productId,
        orElse: () => null);
    var orderItem = products.firstWhere(
        (element) => element.productId == lineItem.productId,
        orElse: () => null);
    if (item != null && orderItem != null) {
      item.quantity++;
      orderItem.quantity++;
    } else {
      cart.add(lineItem);
      products.add(
        OrderProductItemModel.create(
          name: product.name,
          productId: product.id,
          quantity: lineItem.quantity,
          salePrice: product.salePrice,
          regularPrice: product.regularPrice,
          images: product.images,
        ),
      );
      easyAccessProducts.add(product);
    }
  }

  @override
  void remove(int productId) {
    var item = cart.firstWhere((element) => element.productId == productId);
    var orderItem =
        products.firstWhere((element) => element.productId == productId);
    if (item.quantity == 1) {
      cart.remove(item);
      products.remove(orderItem);
    } else {
      item.quantity--;
      orderItem.quantity--;
    }
  }

  @override
  void addQuantity(int productId) {
    var item = cart.firstWhere((element) => element.productId == productId);
    var orderItem =
        products.firstWhere((element) => element.productId == productId);
    item.quantity++;
    orderItem.quantity++;
  }

  @override
  void removeItem(int productId) {
    var item = cart.firstWhere((element) => element.productId == productId);
    var orderItem =
        products.firstWhere((element) => element.productId == productId);
    cart.remove(item);
    products.remove(orderItem);
  }

  @override
  bool find(int productId) {
    var item = cart.firstWhere((element) => element.productId == productId,
        orElse: () => null);
    var orderItem = products.firstWhere(
        (element) => element.productId == productId,
        orElse: () => null);
    if (item != null && orderItem != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int getQuantity(int productId) {
    var item = products.firstWhere((element) => element.productId == productId);
    return item.quantity;
  }

  @override
  int getTotalQuantity() {
    var quantity = 0;
    for (var item in cart) {
      quantity += item.quantity;
    }
    return quantity;
  }

  @override
  String getTotalPrice() {
    int price = 0;
    for (var item in cart) {
      var itemPrice = item.quantity * int.parse(item.price);
      price += itemPrice;
    }
    return price.toString();
  }

  @override
  Future<ResultModel<OrderModel>> retrieve(int id) async {
    var result = ResultModel<OrderModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.result = OrderModel();

    var url = globalService.apiUrl + 'Orders/' + id.toString() + '?';

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

    result.result = OrderModel.fromJson(model);

    return result;
  }

  @override
  Future<ResultModel<OrderModel>> list(
      OrderSearchModel model, ActionType actionType) async {
    var result = ResultModel<OrderModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.results = List<OrderModel>();

    var url = globalService.apiUrl + 'Orders';

    if (actionType == ActionType.Latest) {
      url += model.customerQuery();
    } else if (actionType == ActionType.Search) {
      url += model.searchQuery();
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
      result.results.add(OrderModel.fromJson(i));
    }
    return result;
  }

  @override
  Future<ResultModel<OrderModel>> create(OrderModel model) async {
    var result = ResultModel<OrderModel>();
    result.isSuccess = true;
    result.message = 'Success';
    result.result = OrderModel();

    var url = globalService.apiUrl + 'Orders' + '?';

    url = globalService.addKeys(url);

    print(url);

    var response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode != 201) {
      result.isSuccess = false;
      result.message = response.body;
      return result;
    }

    print(response.body);

    var data = json.decode(response.body);

    print(data);

    result.result = OrderModel.fromJson(data);

    return result;
  }
}
