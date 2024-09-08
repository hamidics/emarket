/*
  
 */

import 'package:eMarket/core/models/order_models/order_line_item_model.dart';
import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/pages/customer/address/customer_address_view.dart';
import 'package:eMarket/ui/pages/order/review/cart_review_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartViewModel extends BaseLogicViewModel {
  List<OrderLineItemModel> lineItems = List<OrderLineItemModel>();
  List<OrderProductItemModel> products = List<OrderProductItemModel>();

  var totalPrice = '';

  void initialize() {
    lineItems = orderService.cart;
    products = orderService.products;
    calculateTotalPrice();
    notifyListeners();
  }

  void add(OrderProductItemModel product) {
    orderService.addQuantity(product.productId);
    calculateTotalPrice();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void remove(OrderProductItemModel product) {
    orderService.remove(product.productId);
    calculateTotalPrice();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void removeItem(OrderProductItemModel product) {
    orderService.removeItem(product.productId);
    calculateTotalPrice();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void calculateTotalPrice() {
    totalPrice = orderService.getTotalPrice();
    notifyListeners();
  }

  void goToCheckOut(BuildContext context) async {
    setBusy(true);

    var result = await customerService.retrieve();
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }

    await SharedPreferences.getInstance().then((value) async {
      if (value.getBool('registration-complete') != null) {
        pushNewScreen(
          context,
          screen: CartReviewView(
            customer: result.result,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      } else {
        await pushNewScreen(
          context,
          screen: CustomerAddressView(
            customer: result.result,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
        pushNewScreen(
          context,
          screen: CartReviewView(
            customer: result.result,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      }
    });

    setBusy(false);
    notifyListeners();
  }
}
