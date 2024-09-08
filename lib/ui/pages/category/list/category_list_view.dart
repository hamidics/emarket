/*
  
 */

import 'package:dotted_border/dotted_border.dart';
import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/category/list/category_list_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesListView extends StatelessWidget {
  final int categoryId;

  CategoriesListView({
    Key key,
    this.categoryId,
  }) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CategoriesListViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: ThemeBorders.enabledBorder,
              focusedBorder: ThemeBorders.focusBorder,
              contentPadding: const EdgeInsets.all(10),
              hintText: 'جستجو در ' + viewModel.currentCategory.name,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: screenSize.height * 0.075),
                          child: ListView.builder(
                            itemCount: viewModel.baseCategories.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var category = viewModel.baseCategories[index];
                              return _BaseCategoryItem(
                                category: category,
                                screenSize: screenSize,
                                callBack: () => viewModel.getSubCategories(
                                    context, category.id),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var category = viewModel.categories[index];
                            return _CategoryItem(
                              category: category,
                              screenSize: screenSize,
                              parentImage: viewModel.assetImage,
                              callBack: () => viewModel.getCategoryProducts(
                                  context, category.id),
                            );
                          },
                          itemCount: viewModel.categories.length,
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
      ),
      viewModelBuilder: () => CategoriesListViewModel(categoryId: categoryId),
      onModelReady: (viewModel) => viewModel.scrollListener(_scrollController),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key key,
    @required this.category,
    @required this.parentImage,
    @required this.screenSize,
    @required this.callBack,
  }) : super(key: key);

  final ProductCategoryModel category;
  final Size screenSize;
  final Function callBack;
  final String parentImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callBack(),
      child: Container(
        height: screenSize.height * 0.13,
        child: Card(
          elevation: 0,
          color: Colors.grey.shade200,
          child: Row(
            children: [
              Utils.createSizedBox(width: 8),
              Utils.createSingleAssetImageBox(
                  height: screenSize.height * 0.1,
                  width: screenSize.height * 0.1,
                  image: parentImage,
                  radius: BorderRadius.zero),
              Utils.createSizedBox(width: 8),
              FittedBox(
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BaseCategoryItem extends StatelessWidget {
  const _BaseCategoryItem({
    Key key,
    @required this.category,
    @required this.screenSize,
    @required this.callBack,
  }) : super(key: key);

  final ProductCategoryModel category;
  final Size screenSize;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callBack(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DottedBorder(
          color: ThemeColors.Orange,
          radius: Radius.circular(15),
          strokeWidth: 1,
          borderType: BorderType.RRect,
          child: Container(
            height: screenSize.height * 0.1,
            width: screenSize.width * 0.25,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
