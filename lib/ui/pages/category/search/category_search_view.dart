/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/category/search/category_search_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategorySearchView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CategorySearchViewModel>.reactive(
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
              hintText: 'جستجو در لیست دسته بندی ها',
            ),
            onSubmitted: (value) => viewModel.loadCategories(_focusNode, value),
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
                  child: (viewModel.categories.length < 1)
                      ? Column(
                          children: [
                            Utils.createSizedBox(
                                height: screenSize.height * 0.4),
                            Center(
                              child: Text('عبارت جستجو مورد نظر را وارد کنید.'),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: screenSize.height * 0.8,
                              maxWidth: screenSize.width * 0.9,
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemBuilder: (context, index) {
                                var category = viewModel.categories[index];
                                return _CategoryItem(
                                  category: category,
                                  screenSize: screenSize,
                                );
                              },
                              itemCount: viewModel.categories.length,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CategorySearchViewModel(),
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
    return Container(
      width: screenSize.width * 0.25,
      height: screenSize.height * 0.40,
      child: Card(
        elevation: 0,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Utils.createCachedImage(imageUrl: category.image.src),
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
