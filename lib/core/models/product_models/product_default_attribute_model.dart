/*
  
 */

import 'package:eMarket/core/utilities/static_methods.dart';

class ProductDefaultAttributeModel {
  int id;
  String name;
  String option;

  ProductDefaultAttributeModel();

  ProductDefaultAttributeModel.set({
    this.id,
    this.name,
    this.option,
  });

  factory ProductDefaultAttributeModel.fromJson(Map<String, dynamic> json) =>
      ProductDefaultAttributeModel.set(
        id: SM.toInt(json['id']),
        name: SM.toStr(json['name']),
        option: SM.toStr(json['option']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'option': option,
      };
}
