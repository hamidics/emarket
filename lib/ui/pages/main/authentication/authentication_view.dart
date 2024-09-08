

import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/helpers/utils.dart';
import 'package:eMarket/ui/widgets/busy_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'authentication_viewmodel.dart';

class AuthenticationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthenticationViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              key: viewModel.scaffoldKey,
              appBar: AppBar(
                title: Text('ورود به ایی مارکت'),
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
                            Image.asset(
                              'asset/images/logo-mini.png',
                              scale: 1.5,
                            ),
                            ListTile(
                              title: Form(
                                autovalidateMode: AutovalidateMode.always,
                                child: TextFormField(
                                  validator: (value) =>
                                      viewModel.validateNumber(value),
                                  controller: viewModel.phoneController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'شماره موبایل',
                                    suffixIcon: Icon(Icons.phone),
                                  ),
                                  onFieldSubmitted: (val) =>
                                      viewModel.sendOtp(context),
                                ),
                              ),
                            ),
                            Utils.createSizedBox(height: 8),
                            ListTile(
                              title: Container(
                                width: double.infinity,
                                child: FlatButton(
                                  child: Text('ورود'),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(16),
                                  onPressed: () => viewModel.sendOtp(context),
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
        viewModelBuilder: () => AuthenticationViewModel());
  }
}
