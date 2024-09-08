/*
  
 */

import 'package:eMarket/core/models/order_models/order_line_item_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/services/order_service.dart';
import 'package:eMarket/core/services/product_service.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/pages/product/search/product_search_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class ProductListViewModel extends FutureViewModel {
  final ProductSearchModel model;
  final String mode;
  final ScrollController scrollController;

  ProductListViewModel({this.mode, this.model, this.scrollController});

  final ProductService _productService = locator<ProductService>();
  final OrderService _orderService = locator<OrderService>();
  final GlobalService _globalService = locator<GlobalService>();

  List<ProductModel> products = List<ProductModel>();

  @override
  Future futureToRun() async {
    await initialize();
  }

  Future<void> initialize() async {
    if (mode == ProductSearchModel.Search) {
      await getProducts(ActionType.Search);
    } else if (mode == ProductSearchModel.Latest) {
      await getProducts(ActionType.Latest);
    } else if (mode == ProductSearchModel.Category) {
      await getProducts(ActionType.Category);
    }

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        setBusy(true);
        model.page++;
        if (mode == ProductSearchModel.Search) {
          await getProducts(ActionType.Search);
        } else if (mode == ProductSearchModel.Latest) {
          await getProducts(ActionType.Latest);
        } else if (mode == ProductSearchModel.Category) {
          await getProducts(ActionType.Category);
        }
        print(products.length);
        setBusy(false);
      }
    });
    print(products.length);
  }

  var itemsLoaded = false;

  setItemsLoaded(bool value) {
    itemsLoaded = value;
    notifyListeners();
  }

  Future<void> getProducts(ActionType actionType) async {
    setItemsLoaded(false);
    var result = await _productService.list(model, actionType);
    if (result.isSuccess == false) {
      print('error');
      return;
    }
    products.addAll(result.results);
    notifyListeners();
    setItemsLoaded(true);
  }

  goToSearchPage(BuildContext context, FocusNode node) {
    node.unfocus();
    pushNewScreen(
      context,
      screen: ProductSearchView(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  void addToCart(ProductModel product) {
    _orderService.add(
        lineItem: OrderLineItemModel.createItem(
          name: product.name,
          productId: product.id,
          price: product.price,
          quantity: 1,
        ),
        product: product);

    Fluttertoast.showToast(
      msg: product.name + ' به سبد خرید شما اضافه شد.',
      fontSize: 14,
      backgroundColor: ThemeColors.Green,
      gravity: ToastGravity.BOTTOM,
    );

    _globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }
}
