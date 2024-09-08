

import 'dart:async';

import 'package:eMarket/core/common/connection_service.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/pages/category/home/category_home_view.dart';
import 'package:eMarket/ui/pages/customer/main/customer_main_view.dart';
import 'package:eMarket/ui/pages/info/info_view.dart';
import 'package:eMarket/ui/pages/order/cart/cart_view.dart';
import 'package:eMarket/ui/pages/product/home/product_home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeViewModel extends BaseLogicViewModel {
  PersistentTabController controller;
  // ignore: cancel_subscriptions
  StreamSubscription connectionChangeStream;
  bool _hasNetworkConnection = false;
  bool _fallbackViewOn = false;

  void initialize() {
    controller = PersistentTabController(initialIndex: 0);
    globalService.homeViewModel = this;
    connectionChangeStream = ConnectionService.getInstance()
        .connectionChange
        .listen(connectionChange);
    notifyListeners();
  }

  void connectionChange(dynamic hasConnection) {
    if (!_hasNetworkConnection) {
      if (!_fallbackViewOn) {
        _fallbackViewOn = true;
        _hasNetworkConnection = !hasConnection;
        showError('لطفا از ارتباط دستگاه به اینترنت مطمئن شوید.');
      }
    } else {
      if (_fallbackViewOn) {
        _fallbackViewOn = false;
        _hasNetworkConnection = !hasConnection;
      }
    }
    notifyListeners();
  }

  List<Widget> buildScreens() {
    return [
      ProductHomeView(),
      CategoriesHomeView(),
      CartView(),
      CustomerMainView(),
      InfoView(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
        ),
        activeColor: Colors.white,
        inactiveColor: ThemeColors.Grey700,
        title: 'خانه',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.dashboard,
        ),
        activeColor: Colors.white,
        inactiveColor: ThemeColors.Grey700,
        title: 'دسته بندی ها',
      ),
      PersistentBottomNavBarItem(
        icon: (() {
          if (orderService.cart.length == 0) {
            return Icon(
              Icons.shopping_cart,
            );
          } else {
            return Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                ),
                Positioned(
                  child: Stack(
                    children: <Widget>[
                      Icon(Icons.brightness_1, size: 10, color: Colors.white),
                      Positioned(
                        top: 0.0,
                        right: 4.0,
                        child: Center(
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }()),
        activeColor: Colors.white,
        inactiveColor: ThemeColors.Grey700,
        title: 'سبد خرید',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person,
        ),
        activeColor: Colors.white,
        inactiveColor: ThemeColors.Grey700,
        title: 'پنل کاربری',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.phone_android,
        ),
        activeColor: Colors.white,
        inactiveColor: ThemeColors.Grey700,
        title: 'ارتباط با ما',
      ),
    ];
  }
}
