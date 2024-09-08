/*
  
 */

import 'package:eMarket/core/models/common_models/image_model.dart';
import 'package:eMarket/core/models/product_models/product_attribute_model.dart';
import 'package:eMarket/core/models/product_models/product_default_attribute_model.dart';
import 'package:eMarket/core/models/product_models/product_tag_model.dart';
import 'package:eMarket/core/utilities/static_methods.dart';

class ProductModel {
  int id;
  String name;
  String slug;
  String permalink;
  String status;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  bool onSale;
  bool purchasable;
  String weight;
  DimensionModel dimensions;
  String averageRating;
  int ratingCount;
  List<int> relatedIds;
  List<int> upsellIds;
  List<int> crossSellIds;
  int parentId;
  List<ProductTagModel> categories;
  List<ProductTagModel> tags;
  List<ImageModel> images;
  List<ProductAttributeModel> attributes;
  List<ProductDefaultAttributeModel> defaultAttributes;
  List<int> variations;
  List<int> groupedProducts;
  int menuOrder;

  ProductModel();

  ProductModel.set({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.status,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale,
    this.purchasable,
    this.weight,
    this.dimensions,
    this.averageRating,
    this.ratingCount,
    this.relatedIds,
    this.upsellIds,
    this.crossSellIds,
    this.parentId,
    this.categories,
    this.tags,
    this.images,
    this.attributes,
    this.defaultAttributes,
    this.variations,
    this.groupedProducts,
    this.menuOrder,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel.set(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        permalink: json["permalink"],
        status: json["status"],
        description: json["description"],
        shortDescription: json["short_description"],
        sku: json["sku"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        onSale: json["on_sale"],
        purchasable: json["purchasable"],
        weight: json["weight"],
        dimensions: DimensionModel.fromJson(json["dimensions"]),
        averageRating: json["average_rating"],
        ratingCount: json["rating_count"],
        relatedIds: List<int>.from(json["related_ids"].map((x) => x)),
        upsellIds: List<int>.from(json["upsell_ids"].map((x) => x)),
        crossSellIds: List<int>.from(json["cross_sell_ids"].map((x) => x)),
        parentId: json["parent_id"],
        categories: List<ProductTagModel>.from(
            json["categories"].map((x) => ProductTagModel.fromJson(x))),
        tags: List<ProductTagModel>.from(
            json["tags"].map((x) => ProductTagModel.fromJson(x))),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        attributes: List<ProductAttributeModel>.from(
            json["attributes"].map((x) => ProductAttributeModel.fromJson(x))),
        defaultAttributes: List<ProductDefaultAttributeModel>.from(
            json["default_attributes"]
                .map((x) => ProductDefaultAttributeModel.fromJson(x))),
        variations: List<int>.from(json["variations"].map((x) => x)),
        groupedProducts: List<int>.from(json["grouped_products"].map((x) => x)),
        menuOrder: json["menu_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "permalink": permalink,
        "status": status,
        "description": description,
        "short_description": shortDescription,
        "sku": sku,
        "price": price,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "on_sale": onSale,
        "purchasable": purchasable,
        "weight": weight,
        "dimensions": dimensions.toJson(),
        "average_rating": averageRating,
        "rating_count": ratingCount,
        "related_ids": List<int>.from(relatedIds.map((x) => x)),
        "upsell_ids": List<int>.from(upsellIds.map((x) => x)),
        "cross_sell_ids": List<int>.from(crossSellIds.map((x) => x)),
        "parent_id": parentId,
        "categories":
            List<ProductTagModel>.from(categories.map((x) => x.toJson())),
        "tags": List<ProductTagModel>.from(tags.map((x) => x.toJson())),
        "images": List<ImageModel>.from(images.map((x) => x.toJson())),
        "attributes":
            List<ProductAttributeModel>.from(attributes.map((x) => x.toJson())),
        "default_attributes": List<ProductDefaultAttributeModel>.from(
            defaultAttributes.map((x) => x)),
        "variations": List<int>.from(variations.map((x) => x)),
        "grouped_products": List<int>.from(groupedProducts.map((x) => x)),
        "menu_order": menuOrder,
      };

  calculateDiscount() {
    var regPrice = double.parse(regularPrice);
    var sale = salePrice != '' ? double.parse(salePrice) : regPrice;
    var discount = regPrice - sale;
    var discountPercent = (discount / regPrice) * 100;
    return discountPercent.round();
  }
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
