/*
  
 */

import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/models/order_models/order_line_item_model.dart';
import 'package:eMarket/core/models/product_models/product_attribute_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/models/product_models/product_tag_model.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/core/utilities/enums.dart';
import 'package:eMarket/ui/pages/order/cart/cart_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductDetailViewModel extends BaseLogicViewModel {
  ProductModel product = ProductModel.set(
    id: 0,
    name: '',
    slug: '',
    status: '',
    description: '',
    shortDescription: '',
    sku: '',
    price: '',
    salePrice: '',
    regularPrice: '',
    averageRating: '',
    categories: List<ProductTagModel>(),
    images: List<ImageModel>(),
    attributes: List<ProductAttributeModel>(),
    relatedIds: List<int>(),
  );

  List<ProductModel> relatedProducts = List<ProductModel>();

  bool isInCart = false;

  int quantity = 0;

  void initialize({ProductModel model}) async {
    checkSelected();
    product = model;
    await getRelatedProducts(model.relatedIds);
    notifyListeners();
  }

  Future<void> getProduct(int id) async {
    var result = await productService.retrieve(id);
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }
    product = result.result;
    setBusy(false);
    notifyListeners();
  }

  Future<void> getRelatedProducts(List<int> ids) async {
    setBusy(true);
    var result = await productService.list(
        ProductSearchModel.include(include: ids), ActionType.Include);
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }
    relatedProducts.addAll(result.results);
    setBusy(false);
    notifyListeners();
  }

  void checkSelected() {
    isInCart = orderService.find(product.id);
    if (isInCart) quantity = orderService.getQuantity(product.id);
    notifyListeners();
  }

  void addToCart() {
    orderService.add(
        lineItem: OrderLineItemModel.createItem(
          name: product.name,
          productId: product.id,
          price: product.price,
          quantity: 1,
        ),
        product: product);
    checkSelected();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void addQuantity() {
    orderService.addQuantity(product.id);
    checkSelected();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void substractQuantity() {
    orderService.remove(product.id);
    checkSelected();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }

  void goToCart(BuildContext context) async {
    await pushNewScreen(
      context,
      screen: CartView(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.scale,
    );
    checkSelected();
    globalService.homeViewModel.notifyListeners();
    notifyListeners();
  }
}
