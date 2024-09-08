/*
  
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/models/product_models/product_model.dart';
import 'package:eMarket/core/models/product_models/product_search_model.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/product/detail/product_detail_view.dart';
import 'package:eMarket/ui/pages/product/list/product_list_view.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

import 'product_home_viewmodel.dart';

class ProductHomeView extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<ProductHomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
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
          child: BusyOverlay(
            show: viewModel.isBusy,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: [
                      _Slider(
                        screenSize: screenSize,
                        images: viewModel.sliderImages,
                      ),
                      Utils.createSizedBox(height: 8),
                      _Categories(
                        screenSize: screenSize,
                        categories: viewModel.categories,
                        callBack: () => viewModel.goToCategoriesPage(context),
                      ),
                      // Utils.createSizedBox(height: 8),
                      // _Products(
                      //   screenSize: screenSize,
                      //   products: viewModel.latestProducts,
                      //   title: 'اخرین محصولات',
                      //   pageStorageKey: 'latest',
                      //   callBack: () =>
                      //       viewModel.goToLatestProductPage(context),
                      // ),
                      Utils.createSizedBox(height: screenSize.height * .1),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => locator<ProductHomeViewModel>(),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    Key key,
    @required this.screenSize,
    @required this.images,
  }) : super(key: key);

  final Size screenSize;
  final List<CachedNetworkImage> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.9,
      height: screenSize.width * 0.4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: (images.length > 0)
            ? Carousel(
                images: images,
                autoplay: true,
                showIndicator: false,
                borderRadius: true,
                radius: Radius.circular(8.0),
              )
            : Container(),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    Key key,
    @required this.screenSize,
    @required this.categories,
    @required this.callBack,
  }) : super(key: key);

  final Size screenSize;
  final List<ProductCategoryModel> categories;
  final Function callBack;

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
                    'دسته بندی ها',
                    style: TextStyles.ProductHomeTitle,
                  ),
                ],
              ),
            ),
            Utils.createSizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenSize.height * 0.72),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return _CategoryItem(
                    category: category,
                    screenSize: screenSize,
                  );
                },
                itemCount: categories.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key key,
    @required this.category,
    @required this.screenSize,
  }) : super(key: key);

  final ProductCategoryModel category;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductListView(
            mode: ProductSearchModel.Category,
            model: ProductSearchModel.category(
              category: category.id.toString(),
            ),
          ),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Utils.createSizedBox(height: 8),
            SizedBox(
              height: 64,
              child: Image.asset(category.image.src),
            ),
            Utils.createSizedBox(height: 8),
            Text(
              category.name,
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _Products extends StatelessWidget {
  const _Products({
    Key key,
    @required this.screenSize,
    @required this.products,
    @required this.title,
    @required this.pageStorageKey,
    @required this.callBack,
  }) : super(key: key);

  final Size screenSize;
  final List<ProductModel> products;
  final String title;
  final String pageStorageKey;
  final Function callBack;

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
                  GestureDetector(
                    onTap: () => callBack(),
                    child: Row(
                      children: [
                        Text(
                          'همه',
                          style: TextStyles.OrangeText,
                        ),
                        Icon(
                          Icons.keyboard_arrow_left,
                          color: ThemeColors.Orange,
                        )
                      ],
                    ),
                  )
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
