/*
  
 */

import 'package:eMarket/core/utilities/static_methods.dart';

class ProductAttributeModel {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  ProductAttributeModel();

  ProductAttributeModel.set({
    this.id,
    this.name,
    this.position,
    this.visible,
    this.variation,
    this.options,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      ProductAttributeModel.set(
        id: SM.toInt(json['id']),
        name: SM.toStr(json['name']),
        position: SM.toInt(json['position']),
        visible: SM.toBool(json['visible']),
        variation: SM.toBool(json['variation']),
        options: List<String>.from(json['options'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "visible": visible,
        "variation": variation,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}
