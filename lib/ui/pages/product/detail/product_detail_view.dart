/*
  
 */

import 'package:dotted_border/dotted_border.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/product/detail/product_detail_viewmodel.dart';
import 'package:eMarket/ui/widgets/full_busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key key, this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<ProductDetailViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: (() {
          if (viewModel.product.name.length > 1) {
            return AppBar(
              title: FittedBox(
                child: Text(viewModel.product.name),
              ),
              actions: [
                IconButton(
                  icon: (() {
                    if (viewModel.orderService.cart.length == 0) {
                      return Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      );
                    } else {
                      return Stack(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          Positioned(
                            child: Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    size: 10, color: Colors.white),
                                Positioned(
                                  top: 0.0,
                                  right: 4.0,
                                  child: Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }()),
                  onPressed: () => viewModel.goToCart(context),
                  color: ThemeColors.Grey700,
                ),
              ],
            );
          }
        }()),
        body: FullBusyOverlay(
          show: viewModel.isBusy,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Utils.createSizedBox(height: 4),
                      Stack(
                        children: [
                          Utils.createImageBox(
                            context: context,
                            height: screenSize.height * 0.4,
                            width: screenSize.width,
                            images: viewModel.product.images,
                          ),
                          Visibility(
                            visible: product.salePrice != '',
                            child: Positioned(
                              bottom: 0,
                              right: 4,
                              child: Container(
                                width: 48,
                                height: 24,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 4, top: 4),
                                child: Text(
                                  product.calculateDiscount().toString() + '%',
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: ThemeColors.Orange),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Utils.createSizedBox(height: 16),
                      ListTile(
                        title: (() {
                          if (viewModel.product.salePrice != '') {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  child: Text(
                                    'قیمت ',
                                    style: TextStyles.DetailPrice,
                                  ),
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        viewModel.product.regularPrice +
                                            ' افغانی',
                                        style: TextStyles.DetailRegularPrice,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        viewModel.product.salePrice + ' افغانی',
                                        style: TextStyles.DetailSalePrice,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  child: Text(
                                    'قیمت ',
                                    style: TextStyles.DetailPrice,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    viewModel.product.regularPrice + ' افغانی',
                                    style: TextStyles.DetailSalePrice,
                                  ),
                                ),
                              ],
                            );
                          }
                        }()),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'شناسه محصول ',
                              style: TextStyles.DetailPrice,
                            ),
                            Text(
                              viewModel.product.sku,
                              style: TextStyles.DetailSalePrice,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        child: Html(data: viewModel.product.shortDescription),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: viewModel.product.attributes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var attribute = viewModel.product.attributes[index];
                          return ListTile(
                            dense: true,
                            onTap: () {},
                            leading: Text(
                              attribute.name + ' : ',
                              style: TextStyles.DetailPrice,
                            ),
                            title: Text(
                              attribute.options[0],
                              style: TextStyles.DetailSalePrice,
                            ),
                          );
                        },
                      ),
                      Utils.createSizedBox(height: 8),
                      _Products(
                        screenSize: screenSize,
                        products: viewModel.relatedProducts,
                        title: 'محصولات مرتبط',
                        pageStorageKey: 'related',
                      ),
                      Utils.createSizedBox(height: screenSize.height * .1),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenSize.height * .1,
                    color: ThemeColors.Orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        viewModel.isInCart
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                      onTap: () =>
                                          viewModel.substractQuantity(),
                                    ),
                                    Utils.createSizedBox(width: 8),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 12, left: 12),
                                      child: Text(
                                        viewModel.quantity.toString(),
                                      ),
                                    ),
                                    Utils.createSizedBox(width: 8),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Colors.grey.shade700,
                                      ),
                                      onTap: () => viewModel.addQuantity(),
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () => viewModel.addToCart(),
                                  child: Row(
                                    children: [
                                      Text('افزودن به سبد خرید'),
                                      Icon(Icons.add_shopping_cart),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (() {
                            if (viewModel.product.salePrice != '') {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          viewModel.product.regularPrice +
                                              ' افغانی',
                                          style: TextStyles
                                              .DetailBottomRegularPrice,
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          viewModel.product.salePrice +
                                              ' افغانی',
                                          style:
                                              TextStyles.DetailBottomSalePrice,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      viewModel.product.regularPrice +
                                          ' افغانی',
                                      style: TextStyles.DetailBottomSalePrice,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }()),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ProductDetailViewModel(),
      onModelReady: (viewModel) => viewModel.initialize(model: product),
    );
  }
}

class _Products extends StatelessWidget {
  const _Products({
    Key key,
    @required this.screenSize,
    @required this.products,
    @required this.title,
    @required this.pageStorageKey,
  }) : super(key: key);

  final Size screenSize;
  final List<ProductModel> products;
  final String title;
  final String pageStorageKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width * 0.05,
                  right: screenSize.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.ProductHomeTitle,
                  ),
                ],
              ),
            ),
            Utils.createSizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenSize.height * 0.25),
              child: ListView.builder(
                key: PageStorageKey(pageStorageKey),
                itemBuilder: (context, index) {
                  var product = products[index];
                  return _ProductItem(
                    product: product,
                    screenSize: screenSize,
                  );
                },
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    Key key,
    @required this.product,
    @required this.screenSize,
  }) : super(key: key);

  final ProductModel product;
  final Size screenSize;

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DottedBorder(
          color: ThemeColors.Orange,
          radius: Radius.circular(15),
          strokeWidth: 1,
          borderType: BorderType.RRect,
          child: Container(
            width: screenSize.width * 0.4,
            child: Column(
              children: [
                Stack(
                  children: [
                    Utils.createImageBox(
                      context: context,
                      width: screenSize.width * 0.4,
                      height: screenSize.width * 0.25,
                      images: product.images,
                      radius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    Visibility(
                      visible: product.salePrice != '',
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 48,
                          height: 24,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            product.calculateDiscount().toString() + '%',
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: ThemeColors.Orange),
                        ),
                      ),
                    ),
                  ],
                ),
                Utils.createSizedBox(height: 4),
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Utils.createSizedBox(height: 2),
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
                }())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
