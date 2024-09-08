/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_category_search_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/pages/product/list/product_list_view.dart';
import 'package:eMarket/ui/pages/product/search/product_search_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

import 'category_list_view.dart';

class CategoriesListViewModel extends FutureViewModel {
  final CategoryService _categoryService = locator<CategoryService>();
  List<ProductCategoryModel> categories = List<ProductCategoryModel>();
  List<ProductCategoryModel> baseCategories = List<ProductCategoryModel>();

  final int categoryId;
  CategoriesListViewModel({this.categoryId});

  ProductCategorySearchModel model = ProductCategorySearchModel.child();

  ProductCategoryModel currentCategory = ProductCategoryModel();

  String assetImage = '';

  @override
  Future futureToRun() async {
    model.parent = categoryId;
    assetImage = _categoryService.baseCategories
        .firstWhere((element) => element.id == categoryId)
        .image
        .src;
    await initialize();
  }

  Future<void> initialize() async {
    baseCategories.addAll(_categoryService.baseCategories);
    currentCategory =
        baseCategories.firstWhere((element) => element.id == categoryId);
    baseCategories.removeWhere((element) => element.id == categoryId);
    await loadCategories();
    notifyListeners();
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
    var result = await _categoryService.subCategories(model);
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
      screen: ProductSearchView(
        category: currentCategory,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  void getCategoryProducts(BuildContext context, int id) {
    pushNewScreen(
      context,
      screen: ProductListView(
        mode: ProductSearchModel.Category,
        model: ProductSearchModel.category(
          category: id.toString(),
        ),
      ),
      withNavBar: true,
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
