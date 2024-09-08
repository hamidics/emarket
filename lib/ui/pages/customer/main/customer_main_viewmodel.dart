/*
  
 */

import 'package:eMarket/core/common/navigation_service.dart';
import 'package:eMarket/core/models/customer_models/customer_billing_model.dart';
import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:eMarket/core/models/customer_models/customer_shipping_model.dart';
import 'package:eMarket/core/services/customer_service.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/pages/customer/address/customer_address_view.dart';
import 'package:eMarket/ui/pages/customer/order_list/customer_order_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class CustomerMainViewModel extends FutureViewModel {
  final CustomerService _customerService = locator<CustomerService>();
  final NavigationService _navigationService = locator<NavigationService>();

  CustomerModel user = CustomerModel.create(
    avatarUrl: '',
    billing: CustomerBillingModel(),
    email: '',
    firstName: '',
    id: 0,
    isPayingCustomer: false,
    lastName: '',
    role: '',
    userName: '',
    shipping: CustomerShippingModel(),
  );

  bool inCompleteRegistration = false;

  @override
  Future futureToRun() async {
    await initialize();
  }

  Future initialize() async {
    await getUser();
    notifyListeners();
  }

  Future getUser() async {
    setBusy(true);
    var result = await _customerService.retrieve();
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }
    user = result.result;
    userValidation();
    setBusy(false);
    notifyListeners();
  }

  void userValidation() {
    if (user.billing.addressOne == '' || user.shipping.addressOne == '') {
      inCompleteRegistration = true;
    } else {
      inCompleteRegistration = false;
    }
    notifyListeners();
  }

  void goToOrders(BuildContext context) {
    pushNewScreen(
      context,
      screen: CustomerOrderListView(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  void goToUpdateProfile(BuildContext context) async {
    await pushNewScreen(context,
        screen: CustomerAddressView(
          customer: user,
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade);
    userValidation();
    notifyListeners();
  }

  void logOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('ایا میخواهید از حساب کاربری خود خارج شوید ؟'),
              actions: [
                FlatButton(
                  child: Text('خیر'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('بله'),
                  onPressed: () => logOut(),
                  color: Colors.red,
                ),
              ],
            ));
  }

  void logOut() async {
    setBusy(true);
    await SharedPreferences.getInstance().then((value) {
      value.clear();
      _navigationService.pushNamedAndRemoveUntil('login');
    });
    setBusy(false);
    notifyListeners();
  }
}
