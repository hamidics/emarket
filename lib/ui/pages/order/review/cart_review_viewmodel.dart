/*
  
 */

import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:eMarket/core/models/order_models/order_coupon_line_model.dart';
import 'package:eMarket/core/models/order_models/order_fee_line_model.dart';
import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/models/order_models/order_shipping_line_model.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/pages/customer/address/customer_address_view.dart';
import 'package:eMarket/ui/pages/order/finalize/cart_finalize_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartReviewViewModel extends BaseLogicViewModel {
  final CustomerModel customerModel;
  CartReviewViewModel({Key key, this.customerModel});

  List<OrderProductItemModel> finalCart = List<OrderProductItemModel>();

  ScrollController scrollController = ScrollController();
  TextEditingController customerNotes = TextEditingController();

  String totalPrice = '';

  void initialize() {
    finalCart = orderService.products;
    totalPrice = orderService.getTotalPrice();
    if (customerModel.billing.city != 'هرات') {
      var price = int.parse(totalPrice);
      price += 100;
      totalPrice = price.toString();
    }
  }

  void editAddress(BuildContext context) async {
    await pushNewScreen(
      context,
      screen: CustomerAddressView(
        customer: customerModel,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );

    totalPrice = orderService.getTotalPrice();
    if (customerModel.billing.city != 'هرات') {
      var price = int.parse(totalPrice);
      price += 100;
      totalPrice = price.toString();
    }
    notifyListeners();
  }

  void submit(BuildContext context) async {
    setBusy(true);

    int _userId;
    await SharedPreferences.getInstance()
        .then((value) => _userId = int.parse(value.getString('userId')));

    var _customerNotes = customerNotes.text.trim();

    var _shippingLines = List<OrderShippingLineModel>();
    if (customerModel.billing.city != 'هرات') {
      var _shippingLine = OrderShippingLineModel.create(
          methodId: 'flat_rate', methodTitle: 'نرخ ثابت', total: '100.00');
      _shippingLines.add(_shippingLine);
    }

    var model = OrderModel.create(
      customerNote: _customerNotes,
      customerId: _userId,
      billing: customerModel.billing,
      shipping: customerModel.shipping,
      lineItems: orderService.cart,
      shippingLines: _shippingLines,
      feeLines: List<OrderFeeLineModel>(),
      couponLines: List<OrderCouponLineModel>(),
    );

    var result = await orderService.create(model);
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }
    setBusy(false);
    pushNewScreen(
      context,
      screen: CartFinalizeView(
        order: result.result,
      ),
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
      withNavBar: false,
    );
  }
}
