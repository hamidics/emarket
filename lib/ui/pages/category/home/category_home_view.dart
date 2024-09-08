/*
  
 */

import 'package:eMarket/core/models/product_models/product_category_model.dart';
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/borders.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/category/home/category_home_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesHomeView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CategoriesHomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
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
              hintText: 'جستجو در لیست دسته بندی ها',
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
                            maxHeight: screenSize.height * 0.7,
                            maxWidth: screenSize.width * 0.9,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              var category = viewModel.categories[index];
                              return _CategoryItem(
                                category: category,
                                screenSize: screenSize,
                                callBack: () => viewModel.getSubCategories(
                                    context, category.id),
                              );
                            },
                            itemCount: viewModel.categories.length,
                          ),
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
      viewModelBuilder: () => locator<CategoriesHomeViewModel>(),
      onModelReady: (viewModel) => viewModel.scrollListener(_scrollController),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
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
      child: Container(
        width: screenSize.width * 0.25,
        height: screenSize.height * 0.40,
        child: Card(
          elevation: 0,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Utils.createSizedBox(height: 4),
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
      ),
    );
  }
}
