/*
  
 */

import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:persian_date/persian_date.dart';
import 'package:stacked/stacked.dart';

import 'customer_order_detail_viewmodel.dart';

class CustomerOrderDetailView extends StatelessWidget {
  const CustomerOrderDetailView({Key key, this.order}) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    var _controller = ScrollController();
    var pDate = PersianDate();
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CustomerOrderDetailViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text('جزئیات سفارش ${order.id.toString()}'),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: ListBody(
                        children: [
                          ListTile(
                            leading: Text('شماره سفارش : '),
                            title: Text(
                              order.id.toString(),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('ایمیل : '),
                            title: Text(
                              order.billing.email,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('قیمت نهایی : '),
                            title: Text(
                              order.total + ' افغانی',
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('تاریخ : '),
                            title: Text(
                              viewModel.convertedDate(
                                pDate.gregorianToJalali(
                                    order.dateCreated.toIso8601String(),
                                    'yyyy-MM-d'),
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('روش پرداخت : '),
                            title: Text(
                              order.paymentMethodTitle,
                            ),
                          ),
                          Divider(),
                          ListView.builder(
                            itemCount: order.lineItems.length,
                            controller: _controller,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var item = order.lineItems[index];
                              return ListTile(
                                title: Text(
                                  item.name +
                                      ' ' +
                                      ' تعداد ' +
                                      item.quantity.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('به نام : '),
                            title: Text(
                              order.billing.firstName +
                                  ' ' +
                                  order.billing.lastName,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('به آدرس : '),
                            title: Text(
                              order.shipping.city +
                                  ' - ' +
                                  order.shipping.addressOne,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Text('شماره موبایل : '),
                            title: Text(
                              order.billing.phone,
                            ),
                          ),
                          Divider(),
                          Utils.createSizedBox(height: screenSize.height * .1),
                        ],
                      ),
                    ),
                  ],
                  fit: StackFit.expand,
                ),
              ),
            ),
        viewModelBuilder: () => CustomerOrderDetailViewModel());
  }
}
