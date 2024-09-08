/*
  
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/services/product_service.dart';
import 'package:eMarket/core/services/user_service.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/category/home/category_home_view.dart';
import 'package:eMarket/ui/pages/product/list/product_list_view.dart';
import 'package:eMarket/ui/pages/product/search/product_search_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class ProductHomeViewModel extends FutureViewModel {
  final ProductService _productService = locator<ProductService>();
  final CategoryService _categoryService = locator<CategoryService>();
  final UserService _userService = locator<UserService>();

  List<ProductModel> latestProducts = List<ProductModel>();
  List<ProductCategoryModel> categories = List<ProductCategoryModel>();

  var sliderImages = List<CachedNetworkImage>();

  @override
  Future<void> futureToRun() async {
    await initialize();
  }

  Future<void> initialize() async {
    await loadSliderImages();
    loadCategories();
    // await loadLatestProducts();
    notifyListeners();
  }

  Future<void> loadSliderImages() async {
    setBusy(true);
    var result = await _userService.loadSliders();
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }

    var img1 = Utils.createCachedImage(imageUrl: result.result[0]);
    sliderImages.add(img1);
    var img2 = Utils.createCachedImage(imageUrl: result.result[1]);
    sliderImages.add(img2);
    var img3 = Utils.createCachedImage(imageUrl: result.result[2]);
    sliderImages.add(img3);

    setBusy(false);
    notifyListeners();
  }

  Future<void> loadLatestProducts() async {
    var result = await _productService.list(
        ProductSearchModel.latest(), ActionType.Latest);
    if (result.isSuccess == false) {
      print('Error');
      return;
    }
    latestProducts.addAll(result.results);
    notifyListeners();
  }

  loadCategories() {
    categories.addAll(_categoryService.baseCategories);
    notifyListeners();
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

  goToCategoriesPage(BuildContext context) {
    pushNewScreen(
      context,
      screen: CategoriesHomeView(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  goToLatestProductPage(BuildContext context) {
    pushNewScreen(
      context,
      screen: ProductListView(
        mode: ProductSearchModel.Latest,
        model: ProductSearchModel.latest(),
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }
}
