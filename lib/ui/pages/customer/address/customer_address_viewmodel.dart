/*
  
 */

import 'package:eMarket/core/models/customer_models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAddressViewModel extends BaseLogicViewModel {
  final CustomerModel customerModel;
  CustomerAddressViewModel({
    this.customerModel,
  });

  final firstName = TextEditingController();
  final firstNameFormKey = GlobalKey<FormState>();

  final lastNameFocusNode = FocusNode();
  final lastName = TextEditingController();
  final lastNameFormKey = GlobalKey<FormState>();

  final addressFocusNode = FocusNode();
  final address = TextEditingController();
  final addressFormKey = GlobalKey<FormState>();

  final city = TextEditingController();
  var cities = List<String>();

  void initialize() {
    firstName.text = customerModel.billing.firstName;
    lastName.text = customerModel.billing.lastName;
    address.text = customerModel.billing.addressOne;
    city.text = customerModel.billing.city;
    cities = customerService.cities;
    if (city.text.length < 1) {
      city.text = 'کابل';
    }
    notifyListeners();
  }

  void submit() async {
    if (!firstNameFormKey.currentState.validate() ||
        !lastNameFormKey.currentState.validate() ||
        !addressFormKey.currentState.validate()) {
      return;
    }
    setBusy(true);

    customerModel.billing.firstName = firstName.text.trim();
    customerModel.billing.lastName = lastName.text.trim();
    customerModel.billing.addressOne = address.text.trim();
    customerModel.billing.city = city.text.trim();
    customerModel.billing.email = '${customerModel.userName}@emarket.af';
    customerModel.billing.postCode = '';
    customerModel.billing.phone = customerModel.userName;
    customerModel.shipping.firstName = firstName.text.trim();
    customerModel.shipping.lastName = lastName.text.trim();
    customerModel.shipping.addressOne = address.text.trim();
    customerModel.shipping.city = city.text.trim();
    customerModel.shipping.postCode = '';
    customerModel.shipping.email = '${customerModel.userName}@emarket.af';
    customerModel.shipping.phone = customerModel.userName;
    customerModel.email = '${customerModel.userName}@emarket.af';

    var result = await customerService.update(customerModel);
    if (result.isSuccess == false) {
      print(result.message);
      setBusy(false);
      notifyListeners();
      return;
    }

    await SharedPreferences.getInstance().then((value) {
      value.setBool('registration-complete', true);
    });

    setBusy(false);
    notifyListeners();
    navigationService.pop();
  }

  void setCity(String val) {
    customerModel.billing.city = val;
    customerModel.shipping.city = val;
    city.text = val;
    notifyListeners();
  }
}
