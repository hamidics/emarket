/*
  
 */

import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/services/order_service.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/order/cart/cart_viewmodel.dart';
import 'package:eMarket/ui/pages/product/detail/product_detail_view.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class CartView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CartViewModel>.reactive(
      disposeViewModel: true,
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('سبد خرید'),
        ),
        body: SafeArea(
          child: BusyOverlay(
            show: viewModel.isBusy,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: [
                      viewModel.products.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Utils.createSizedBox(
                                    height: screenSize.height * 0.35),
                                FittedBox(
                                    child: Icon(
                                  Icons.remove_shopping_cart,
                                  size: 30,
                                )),
                                FittedBox(
                                    child: Text(
                                  'سبد خرید شما خالی است.',
                                  style: TextStyle(fontSize: 19),
                                )),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: viewModel.products.length,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                var product = viewModel.products[index];
                                return _ProductItem(
                                  product: product,
                                  screenSize: screenSize,
                                  addFunction: () => viewModel.add(product),
                                  removeFunction: () =>
                                      viewModel.remove(product),
                                  removeItemFunction: () =>
                                      viewModel.removeItem(product),
                                );
                              },
                            ),
                      Utils.createSizedBox(height: screenSize.height * .17)
                    ],
                  ),
                ),
                Visibility(
                  visible: viewModel.orderService.cart.length > 0,
                  child: Positioned(
                    bottom: screenSize.height * .05,
                    child: Container(
                      height: screenSize.height * 0.1,
                      width: screenSize.width,
                      color: ThemeColors.Orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () =>
                                    viewModel.goToCheckOut(context),
                                child: Row(
                                  children: [
                                    Text('تکمیل سفارش'),
                                    Icon(Icons.playlist_add_check),
                                  ],
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CartViewModel(),
      onModelReady: (viewModel) => viewModel.initialize(),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    Key key,
    @required this.product,
    @required this.screenSize,
    @required this.addFunction,
    @required this.removeFunction,
    @required this.removeItemFunction,
  }) : super(key: key);

  final OrderProductItemModel product;
  final Size screenSize;
  final Function addFunction;
  final Function removeFunction;
  final Function removeItemFunction;

  @override
  Widget build(BuildContext context) {
    var orderService = locator<OrderService>();
    var productItem = orderService.easyAccessProducts
        .firstWhere((element) => element.id == product.productId);
    return Stack(children: [
      GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.sizeUp,
            screen: ProductDetailView(
              product: productItem,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              width: 1.0,
              color: Colors.grey[200],
            ),
          ),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.sizeUp,
                    screen: ProductDetailView(
                      product: productItem,
                    ),
                  );
                },
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Utils.createCachedImage(
                        imageUrl: product.images[0].src),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Utils.createSizedBox(height: 8),
                      Visibility(
                        visible: product.salePrice != '',
                        child: Column(
                          children: [
                            Text(
                              product.regularPrice + ' افغانی',
                              style: TextStyles.RegularPrice,
                            ),
                            Utils.createSizedBox(height: 8),
                            Text(
                              product.salePrice + ' افغانی',
                              style: TextStyles.SalePrice,
                            ),
                            Utils.createSizedBox(height: 8),
                            Text(
                              product.calculateDiscount().toString() + '%',
                              style: TextStyles.DetailPrice,
                            ),
                            Utils.createSizedBox(height: 8),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: product.salePrice == '',
                        child: Column(
                          children: [
                            Text(
                              product.regularPrice + ' افغانی',
                              style: TextStyles.SalePrice,
                            ),
                            Utils.createSizedBox(height: 8),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  child: Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  onTap: () => removeFunction(),
                                ),
                                Utils.createSizedBox(width: 8),
                                Container(
                                  color: Colors.grey.shade200,
                                  padding: const EdgeInsets.only(
                                      bottom: 2, right: 12, left: 12),
                                  child: Text(
                                    product.quantity.toString(),
                                  ),
                                ),
                                Utils.createSizedBox(width: 8),
                                GestureDetector(
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  onTap: () => addFunction(),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => removeItemFunction(),
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, top: 8),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: ThemeColors.Orange),
            ),
          ),
        ),
      )
    ]);
  }
}
