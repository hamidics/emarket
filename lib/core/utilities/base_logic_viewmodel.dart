import 'dart:io';

import 'package:eMarket/core/common/navigation_service.dart';
import 'package:eMarket/core/common/notification_service.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/services/customer_service.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/services/order_service.dart';
import 'package:eMarket/core/services/product_service.dart';
import 'package:eMarket/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'service_locator.dart';

class BaseLogicViewModel extends BaseViewModel {
  final ProductService productService = locator<ProductService>();
  final CategoryService categoryService = locator<CategoryService>();
  final OrderService orderService = locator<OrderService>();
  final GlobalService globalService = locator<GlobalService>();
  final UserService userService = locator<UserService>();
  final CustomerService customerService = locator<CustomerService>();
  final NavigationService navigationService = locator<NavigationService>();
  final NotificationService notificationService =
      locator<NotificationService>();

  String successMessage;
  String errorMessage;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool isConnected = false;

  void showError(String message) {
    var snackBar = SnackBar(
      content: Text(
        message,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'IRANSans',
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.red,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    notifyListeners();
  }
}
