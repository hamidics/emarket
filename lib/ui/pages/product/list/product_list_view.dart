/*
  
 */

import 'dart:async';

import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/product/detail/product_detail_view.dart';
import 'package:eMarket/ui/pages/product/list/product_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class ProductListView extends StatelessWidget {
  ProductListView({
    Key key,
    this.mode,
    this.model,
  }) : super(key: key);

  final String mode;
  final ProductSearchModel model;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<ProductListViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: ThemeBorders.enabledBorder,
              focusedBorder: ThemeBorders.focusBorder,
              contentPadding: const EdgeInsets.all(10),
              hintText: 'جستجو در لیست محصولات',
            ),
            onTap: () => viewModel.goToSearchPage(context, _focusNode),
          ),
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: screenSize.height * .9),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: viewModel.products.length + 1,
                        itemBuilder: (context, index) {
                          return (index == viewModel.products.length)
                              ? Column(
                                  children: [
                                    Utils.createSizedBox(
                                        height: (viewModel.products.length == 0)
                                            ? screenSize.height * .35
                                            : screenSize.height * .1),
                                    _Loading(loading: viewModel.itemsLoaded),
                                    Utils.createSizedBox(
                                        height: (viewModel.products.length == 0)
                                            ? screenSize.height * .35
                                            : screenSize.height * .1),
                                  ],
                                )
                              : _ProductItem(
                                  product: viewModel.products[index],
                                  screenSize: screenSize,
                                  callBack: () => viewModel
                                      .addToCart(viewModel.products[index]),
                                );
                        },
                      ),
                    ),
                    Utils.createSizedBox(height: screenSize.height * .1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ProductListViewModel(
        mode: mode,
        model: model,
        scrollController: _scrollController,
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    Key key,
    @required this.product,
    @required this.screenSize,
    @required this.callBack,
  }) : super(key: key);

  final ProductModel product;
  final Size screenSize;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.sizeUp,
          screen: ProductDetailView(
            product: product,
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
                    product: product,
                  ),
                );
              },
              child: SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child:
                      Utils.createCachedImage(imageUrl: product.images[0].src),
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
                      child: Container(
                        width: 48,
                        height: 24,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 4, top: 4),
                        child: Text(
                          product.calculateDiscount().toString() + '%',
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: ThemeColors.Orange),
                      ),
                    ),
                    Utils.createSizedBox(height: 8),
                    (() {
                      if (product.salePrice != '') {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: screenSize.width * 0.02,
                              left: screenSize.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.regularPrice + ' افغانی',
                                style: TextStyles.RegularPrice,
                              ),
                              Text(
                                product.salePrice + ' افغانی',
                                style: TextStyles.SalePrice,
                              )
                            ],
                          ),
                        );
                      } else {
                        return Text(
                          product.regularPrice + ' افغانی',
                          style: TextStyles.SalePrice,
                        );
                      }
                    }()),
                    Utils.createSizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: ThemeColors.Orange,
                  ),
                  onPressed: () => callBack(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _RatingStars extends StatelessWidget {
  final int rating;

  _RatingStars(this.rating);

  @override
  Widget build(BuildContext context) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐  ';
    }
    stars.trim();
    return Text(
      stars,
      style: TextStyle(
        fontSize: 18.0,
      ),
    );
  }
}

class _Loading extends StatefulWidget {
  _Loading({Key key, this.loading}) : super(key: key);
  final bool loading;
  @override
  __LoadingState createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  Widget _widget = SpinKitRing(
    color: ThemeColors.Orange,
  );

  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  __LoadingState() {
    _timer = Timer(Duration(seconds: 20), () {
      if (widget.loading) {
        setState(() {
          _widget = Text('محصولی یافت نشد.');
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}
