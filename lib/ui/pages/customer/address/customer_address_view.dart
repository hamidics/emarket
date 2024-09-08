/*
  
 */

import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/pages/customer/address/customer_address_viewmodel.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class CustomerAddressView extends StatelessWidget {
  const CustomerAddressView({Key key, this.customer}) : super(key: key);

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    var screenSize = SM.getSize(context);
    return ViewModelBuilder<CustomerAddressViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('تکمیل اطلاعات کاربری'),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BusyOverlay(
            show: viewModel.isBusy,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Visibility(
                        visible: customer.billing.addressOne == '',
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'برای تکمیل سفارشات خود اطلاعات زیر را تکمیل کنید.',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              leading: Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                            ),
                            Divider(),
                            Utils.createSizedBox(height: 4),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'آدرس',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        leading:
                            Icon(Icons.info_outline, color: ThemeColors.Orange),
                      ),
                      Divider(),
                      ListTile(
                        title: Form(
                          key: viewModel.firstNameFormKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'لطفا نام خود را وارد کنید';
                              }
                              return null;
                            },
                            controller: viewModel.firstName,
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام',
                            ),
                            onFieldSubmitted: (val) => FocusScope.of(context)
                                .requestFocus(viewModel.lastNameFocusNode),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Form(
                          key: viewModel.lastNameFormKey,
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'لطفا نام خانوادگی خود را وارد کنید';
                                }
                                return null;
                              },
                              controller: viewModel.lastName,
                              focusNode: viewModel.lastNameFocusNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نام خانوادگی',
                              ),
                              onFieldSubmitted: (val) => FocusScope.of(context)
                                  .requestFocus(FocusNode())),
                        ),
                      ),
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'شهر',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            value: viewModel.city.text.trim(),
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 20,
                            elevation: 0,
                            style: TextStyle(
                              color: ThemeColors.Fb,
                              fontFamily: 'IRANSans',
                              fontSize: 16,
                            ),
                            underline: Container(
                              height: 1,
                              color: ThemeColors.Orange,
                            ),
                            onChanged: (String newValue) {
                              viewModel.setCity(newValue);
                            },
                            items: viewModel.cities
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Form(
                          key: viewModel.addressFormKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'لطفا نام خانوادگی خود را وارد کنید';
                              }
                              return null;
                            },
                            controller: viewModel.address,
                            focusNode: viewModel.addressFocusNode,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'آدرس',
                              hintText: 'خیابان، پلاک، طبقه، زنگ',
                            ),
                            onFieldSubmitted: (val) => viewModel.submit(),
                          ),
                        ),
                      ),
                      Utils.createSizedBox(height: 20),
                      ListTile(
                        title: Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text('ثبت'),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(16),
                            onPressed: () => viewModel.submit(),
                            color: ThemeColors.Orange,
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
      viewModelBuilder: () => CustomerAddressViewModel(customerModel: customer),
      onModelReady: (viewModel) => viewModel.initialize(),
    );
  }
}
