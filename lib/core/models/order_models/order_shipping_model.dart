/*
  
 */

import 'package:eMarket/core/utilities/static_methods.dart';

class OrderShippingModel {
  String firstName;
  String lastName;
  String company;
  String addressOne;
  String addressTwo;
  String city;
  String state;
  String postCode;
  String country;
  String email;
  String phone;

  OrderShippingModel();

  OrderShippingModel.set({
    this.firstName,
    this.lastName,
    this.company,
    this.addressOne,
    this.addressTwo,
    this.city,
    this.state,
    this.postCode,
    this.country,
  });

  factory OrderShippingModel.fromJson(Map<String, dynamic> json) =>
      OrderShippingModel.set(
        firstName: SM.toStr(json['firstName']),
        lastName: SM.toStr(json['lastName']),
        company: SM.toStr(json['company']),
        addressOne: SM.toStr(json['address_1']),
        addressTwo: SM.toStr(json['address_2']),
        city: SM.toStr(json['city']),
        state: SM.toStr(json['state']),
        postCode: SM.toStr(json['postcode']),
        country: SM.toStr(json['country']),
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'company': company,
        'address_1': addressOne,
        'address_2': addressTwo,
        'city': city,
        'state': state,
        'postcode': postCode,
        'country': country,
      };
}
