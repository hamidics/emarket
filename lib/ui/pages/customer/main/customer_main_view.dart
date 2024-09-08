/*
  
 */
import 'package:eMarket/core/utilities/service_locator.dart';
import 'package:eMarket/ui/pages/customer/main/customer_main_viewmodel.dart';
import 'package:eMarket/ui/widgets/full_busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomerMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomerMainViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('پنل کاربری'),
        ),
        body: FullBusyOverlay(
          show: viewModel.isBusy,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Image.asset(
                        'asset/images/logo-mini.png',
                        scale: 1.5,
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(
                          'حساب : ${viewModel.user.userName}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Visibility(
                        visible: viewModel.inCompleteRegistration,
                        child: ListTile(
                          title: Text(
                            'تکمیل اطلاعات کاربری',
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Icon(
                            Icons.brightness_1,
                            color: Colors.red,
                          ),
                          leading: Icon(Icons.edit),
                          onTap: () => viewModel.goToUpdateProfile(context),
                        ),
                      ),
                      Visibility(
                        visible: !viewModel.inCompleteRegistration,
                        child: ListTile(
                          title: Text('ویرایش اطلاعات کاربری'),
                          leading: Icon(Icons.edit),
                          onTap: () => viewModel.goToUpdateProfile(context),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'لیست سفارشات',
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: Icon(Icons.shopping_cart),
                        onTap: () => viewModel.goToOrders(context),
                      ),
                      ListTile(
                        title: Text(
                          'خروج از حساب',
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: Icon(Icons.exit_to_app),
                        onTap: () => viewModel.logOutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => locator<CustomerMainViewModel>(),
    );
  }
}
