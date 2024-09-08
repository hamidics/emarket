/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_category_search_model.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/pages/category/list/category_list_view.dart';
import 'package:eMarket/ui/pages/category/search/category_search_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class CategoriesHomeViewModel extends FutureViewModel {
  final CategoryService _categoryService = locator<CategoryService>();
  List<ProductCategoryModel> categories = List<ProductCategoryModel>();

  ProductCategorySearchModel model = ProductCategorySearchModel.all(
    perPage: 18,
    orderBy: ProductCategorySearchModel.OrderByCount,
  );

  @override
  Future futureToRun() async {
    await initialize();
  }

  Future<void> initialize() async {
    categories = _categoryService.baseCategories;
    // await loadCategories();
  }

  void scrollListener(ScrollController scrollController) {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        model.page++;
        setBusy(true);
        await loadCategories();
        setBusy(false);
      }
    });
  }

  Future<void> loadCategories() async {
    var result = await _categoryService.allCategories(model);
    if (result.isSuccess == false) {
      print('Error');
      return;
    }
    categories.addAll(result.results);

    notifyListeners();
  }

  void goToSearchPage(BuildContext context, FocusNode focusNode) {
    focusNode.unfocus();
    pushNewScreen(
      context,
      screen: CategorySearchView(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  void getSubCategories(BuildContext context, int id) {
    pushNewScreen(
      context,
      screen: CategoriesListView(
        categoryId: id,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }
}
