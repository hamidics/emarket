/*
  
 */

import 'package:eMarket/core/utilities/static_methods.dart';

class ProductTagModel {
  int id;
  String name;
  String slug;

  ProductTagModel();

  ProductTagModel.set({this.id, this.name, this.slug});

  factory ProductTagModel.fromJson(Map<String, dynamic> json) =>
      ProductTagModel.set(
        id: SM.toInt(json['id']),
        name: SM.toStr(json['name']),
        slug: SM.toStr(json['slug']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
      };
}
