/*
  
 */

import 'package:eMarket/core/models/common_models/image_model.dart';

class OrderProductItemModel {
  String name;
  int productId;
  int quantity;
  String salePrice;
  String regularPrice;
  List<ImageModel> images;
  String total;

  OrderProductItemModel();

  OrderProductItemModel.create({
    this.name,
    this.productId,
    this.quantity,
    this.salePrice,
    this.regularPrice,
    this.images,
  });

  calculateDiscount() {
    var regPrice = double.parse(regularPrice);
    var sale = salePrice != '' ? double.parse(salePrice) : regPrice;
    var discount = regPrice - sale;
    var discountPercent = (discount / regPrice) * 100;
    return discountPercent.round();
  }

  calculateTotal() =>
      quantity *
      (salePrice != '' ? int.parse(salePrice) : int.parse(regularPrice));
}
