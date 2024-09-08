/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/pages/order/cart/cart_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductSearchViewModel extends BaseLogicViewModel {
  List<ProductModel> products = List<ProductModel>();

  final ProductCategoryModel category;

  ProductSearchViewModel({Key key, this.category});

  Future<void> loadProducts(FocusNode node, String value) async {
    setBusy(true);
    node.unfocus();

    var searchModel;
    if (category != null) {
      searchModel = ProductSearchModel.searchAndCategory(
          search: value, category: category.id.toString());
    } else {
      searchModel = ProductSearchModel.search(
        page: 1,
        perPage: 12,
        search: value,
      );
    }

    var result = await productService.list(searchModel,
        (category != null) ? ActionType.SearchAndCategory : ActionType.Search);
    if (result.isSuccess == false) {
      setBusy(false);
      notifyListeners();
      return;
    }
    products.addAll(result.results);
    setBusy(false);
    notifyListeners();
  }

  void goToCart(BuildContext context) async {
    await pushNewScreen(
      context,
      screen: CartView(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.scale,
    );
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }
}
