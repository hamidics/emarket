/*
  
 */

import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/models/product_models/product_attribute_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';

class ProductVariationModel {
  int id;
  String permalink;
  String status;
  String description;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  bool onSale;
  bool purchasable;
  String weight;
  DimensionModel dimensions;
  List<ImageModel> images;
  List<ProductAttributeModel> attributes;
  int menuOrder;

  ProductVariationModel();

  ProductVariationModel.set({
    this.id,
    this.permalink,
    this.status,
    this.description,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale,
    this.purchasable,
    this.weight,
    this.dimensions,
    this.images,
    this.attributes,
    this.menuOrder,
  });

  factory ProductVariationModel.fromJson(Map<String, dynamic> json) =>
      ProductVariationModel.set(
        id: json["id"],
        permalink: json["permalink"],
        status: json["status"],
        description: json["description"],
        sku: json["sku"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        onSale: json["on_sale"],
        purchasable: json["purchasable"],
        weight: json["weight"],
        dimensions: DimensionModel.fromJson(json["dimensions"]),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        attributes: List<ProductAttributeModel>.from(
            json["attributes"].map((x) => ProductAttributeModel.fromJson(x))),
        menuOrder: json["menu_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "permalink": permalink,
        "status": status,
        "description": description,
        "sku": sku,
        "price": price,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "on_sale": onSale,
        "purchasable": purchasable,
        "weight": weight,
        "dimensions": dimensions.toJson(),
        "images": List<ImageModel>.from(images.map((x) => x.toJson())),
        "attributes":
            List<ProductAttributeModel>.from(attributes.map((x) => x.toJson())),
        "menu_order": menuOrder,
      };
}

class DimensionModel {
  String length;
  String width;
  String height;

  DimensionModel();

  DimensionModel.set({this.length, this.width, this.height});

  factory DimensionModel.fromJson(Map<String, dynamic> json) =>
      DimensionModel.set(
        length: SM.toStr(json['length']),
        width: SM.toStr(json['width']),
        height: SM.toStr(json['height']),
      );

  Map<String, dynamic> toJson() => {
        'length': length,
        'width': width,
        'height': height,
      };
}
