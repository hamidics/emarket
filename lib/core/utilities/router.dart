/*
  
 */
import 'package:eMarket/ui/pages/category/list/category_list_view.dart';
import 'package:eMarket/ui/pages/main/authentication/authentication_view.dart';
import 'package:eMarket/ui/pages/main/home/home_view.dart';
import 'package:eMarket/ui/pages/product/home/product_home_view.dart';
import 'package:eMarket/ui/pages/product/search/product_search_view.dart';
import 'package:eMarket/ui/pages/main/splash/splash_view.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
        return modifiedRoute(SplashView());
      case 'login':
        return modifiedRoute(AuthenticationView());
      case 'home':
        return modifiedRoute(HomeView());
      case 'product':
        return modifiedRoute(ProductHomeView());
      case 'product-search':
        return modifiedRoute(ProductSearchView());
      case 'categories':
        return modifiedRoute(CategoriesListView());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text(
                      'No Route for ${settings.name}',
                    ),
                  ),
                ));
    }
  }

  static Route modifiedRoute(Object object) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => object,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
