/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_category_search_model.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/pages/order/cart/cart_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CategorySearchViewModel extends BaseLogicViewModel {
  List<ProductCategoryModel> categories = List<ProductCategoryModel>();

  Future<void> loadCategories(FocusNode node, String value) async {
    setBusy(true);
    node.unfocus();
    var result = await categoryService
        .searchCategories(ProductCategorySearchModel.search(
      page: 1,
      perPage: 12,
      search: value,
    ));
    if (result.isSuccess == false) {
      setBusy(false);
      notifyListeners();
      return;
    }
    categories.addAll(result.results);
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
