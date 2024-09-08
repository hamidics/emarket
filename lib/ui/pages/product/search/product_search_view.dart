/*
  
 */

import 'package:carousel_pro/carousel_pro.dart';
import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/product/search/product_search_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProductSearchView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ProductCategoryModel category;
  ProductSearchView({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            autofocus: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: ThemeBorders.enabledBorder,
              focusedBorder: ThemeBorders.focusBorder,
              contentPadding: const EdgeInsets.all(10),
              hintText: (category == null)
                  ? 'جستجو در محصولات'
                  : 'جستجو در لیست محصولات ' + category.name,
            ),
            onSubmitted: (value) => viewModel.loadProducts(_focusNode, value),
          ),
          actions: [
            IconButton(
              icon: (() {
                if (viewModel.orderService.cart.length == 0) {
                  return Icon(
                    Icons.shopping_cart,
                  );
                } else {
                  return Stack(
                    children: [
                      Icon(
                        Icons.shopping_cart,
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
        ),
        body: SafeArea(
          child: BusyOverlay(
            show: viewModel.isBusy,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: (viewModel.products.length < 1)
                      ? Column(
                          children: [
                            Utils.createSizedBox(
                                height: screenSize.height * 0.4),
                            Center(
                              child: Text('عبارت جستجو مورد نظر را وارد کنید.'),
                            )
                          ],
                        )
                      : ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: screenSize.height * .9),
                          child: ListView.builder(
                            itemCount: viewModel.products.length,
                            itemBuilder: (context, index) {
                              var product = viewModel.products[index];
                              return _ProductItem(
                                product: product,
                                screenSize: screenSize,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ProductSearchViewModel(category: category),
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
    return Container(
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
          SizedBox(
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: (() {
                if (product.images.length < 1) {
                  return Utils.createAssetImage(
                      imageUrl: ImageModel.image().src);
                } else {
                  return Carousel(
                    images:
                        Utils.convertListImageToListCachedImage(product.images),
                    autoplay: true,
                    showIndicator: false,
                  );
                }
              }()),
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
                  _RatingStars(product.ratingCount == 0
                      ? product.ratingCount + 1
                      : product.ratingCount),
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
        ],
      ),
    );
  }
}

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
