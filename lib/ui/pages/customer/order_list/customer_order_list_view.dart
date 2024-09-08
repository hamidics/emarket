/*
  
 */

import 'package:eMarket/core/models/order_models/order_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/customer/order_detail/customer_order_detail_view.dart';
import 'package:eMarket/ui/pages/customer/order_list/customer_order_list_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';
import 'package:persian_date/persian_date.dart';

class CustomerOrderListView extends StatelessWidget {
  const CustomerOrderListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CustomerOrderListViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('لیست سفارشات'),
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
                      ListView.builder(
                        itemCount: viewModel.orders.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var item = viewModel.orders[index];
                          return _OrderItem(
                              order: item, screenSize: screenSize);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CustomerOrderListViewModel(),
    );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
    Key key,
    @required this.order,
    @required this.screenSize,
  }) : super(key: key);

  final OrderModel order;
  final Size screenSize;

  String convertedDate(String date) {
    if (date.contains('فروردین')) {
      date = date.replaceAll('فروردین', 'حمل');
    } else if (date.contains('تیر')) {
      date = date.replaceAll('تیر', 'سرطان');
    } else if (date.contains('مهر')) {
      date = date.replaceAll('مهر', 'میزان');
    } else if (date.contains('دی')) {
      date = date.replaceAll('دی', 'جدی');
    } else if (date.contains('اردیبهشت')) {
      date = date.replaceAll('اردیبهشت', 'ثور');
    } else if (date.contains('مرداد')) {
      date = date.replaceAll('مرداد', 'اسد');
    } else if (date.contains('آبان')) {
      date = date.replaceAll('آبان', 'عقرب');
    } else if (date.contains('بهمن')) {
      date = date.replaceAll('بهمن', 'دلو');
    } else if (date.contains('خرداد')) {
      date = date.replaceAll('خرداد', 'جوزا');
    } else if (date.contains('شهریور')) {
      date = date.replaceAll('شهریور', 'سنبله');
    } else if (date.contains('آذر')) {
      date = date.replaceAll('آذر', 'قوس');
    } else if (date.contains('اسفند')) {
      date = date.replaceAll('اسفند', 'حوت');
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    PersianDate pDate = PersianDate();
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.sizeUp,
          screen: CustomerOrderDetailView(
            order: order,
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
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        'شماره سفارش : ' + order.id.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Utils.createSizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        'تاریخ : ' +
                            convertedDate(
                              pDate.gregorianToJalali(
                                  order.dateCreated.toIso8601String(),
                                  'yyyy-MM-d'),
                            ),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12.0),
                child: FittedBox(
                  child: Text(
                    'وضعیت : ' + order.getStatusTitle(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12.0),
                child: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
