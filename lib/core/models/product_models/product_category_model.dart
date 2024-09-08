/*
  
 */

import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';

class ProductCategoryModel {
  int id;
  String name;
  String slug;
  int parent;
  String description;
  String display;
  ImageModel image;
  int menuOrder;
  int count;

  ProductCategoryModel();

  ProductCategoryModel.set({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.description,
    this.display,
    this.image,
    this.menuOrder,
    this.count,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel.set(
        id: SM.toInt(json['id']),
        name: SM.toStr(json['name']),
        slug: SM.toStr(json['slug']),
        parent: SM.toInt(json['parent']),
        description: SM.toStr(json['description']),
        display: SM.toStr(json['display']),
        image: json['image'] != null
            ? ImageModel.fromJson(json['image'])
            : ImageModel.image(),
        menuOrder: SM.toInt(json['menu_order']),
        count: SM.toInt(json['count']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'parent': parent,
        'description': description,
        'display': display,
        'image': image.toJson(),
        'menu_order': menuOrder,
        'count': count,
      };

  ProductCategoryModel.createBase({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.image,
  });
}
