/*
  
 */

import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:eMarket/core/models/order_models/order_product_item_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/styles.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/order/review/cart_review_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CartReviewView extends StatelessWidget {
  const CartReviewView({Key key, this.customer}) : super(key: key);

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CartReviewViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('ثبت سفارش'),
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
                      Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    customer.billing.firstName +
                                        ' ' +
                                        customer.billing.lastName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'شهر : ${customer.billing.city}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Visibility(
                                  visible: customer.billing.city != 'هرات',
                                  child: ListTile(
                                    title: Text(
                                      'مبلغ صد افغانی برای حمل و نقل به ولایت شما افزوده میشود.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'آدرس : ${customer.billing.addressOne}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                ListTile(
                                  title: Container(
                                    width: double.infinity,
                                    child: FlatButton(
                                      child: Text('ویرایش اطلاعات'),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(16),
                                      onPressed: () =>
                                          viewModel.editAddress(context),
                                      color: ThemeColors.Orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.finalCart.length,
                        controller: viewModel.scrollController,
                        itemBuilder: (context, index) {
                          var product = viewModel.finalCart[index];
                          return _ProductItem(
                            product: product,
                            screenSize: screenSize,
                          );
                        },
                      ),
                      ListTile(
                        leading: Text('قیمت نهایی '),
                        title: Text(
                          viewModel.totalPrice + ' افغانی',
                          style: TextStyles.DetailSalePrice,
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: viewModel.customerNotes,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'توضیحات سفارش',
                          ),
                          maxLines: 3,
                          onSubmitted: (val) =>
                              FocusScope.of(context).requestFocus(FocusNode()),
                        ),
                      ),
                      ListTile(
                        title: Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text('ثبت سفارش'),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(16),
                            onPressed: () => viewModel.submit(context),
                            color: ThemeColors.Orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CartReviewViewModel(customerModel: customer),
      onModelReady: (viewModel) => viewModel.initialize(),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    Key key,
    @required this.product,
    @required this.screenSize,
  }) : super(key: key);

  final OrderProductItemModel product;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
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
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Visibility(
                      visible: product.salePrice != '',
                      child: Column(
                        children: [
                          Text(
                            product.regularPrice + ' افغانی',
                            style: TextStyles.RegularPrice,
                          ),
                          Utils.createSizedBox(width: 8),
                          Text(
                            product.salePrice + ' افغانی',
                            style: TextStyles.SalePrice,
                          ),
                          Utils.createSizedBox(width: 8),
                          Text(
                            product.calculateDiscount().toString() + '%',
                            style: TextStyles.DetailPrice,
                          ),
                          Utils.createSizedBox(width: 8),
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
                          Utils.createSizedBox(width: 8),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        product.quantity.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        product.calculateTotal().toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
