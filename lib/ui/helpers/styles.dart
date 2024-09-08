/*
  
 */

import 'package:eMarket/ui/helpers/colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const OrangeText = TextStyle(
    color: ThemeColors.Orange,
  );
  static const SalePrice = TextStyle(
    color: ThemeColors.Orange,
    fontWeight: FontWeight.w700,
  );
  static const RegularPrice = TextStyle(
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
    decorationColor: ThemeColors.Grey700,
    decorationStyle: TextDecorationStyle.solid,
  );
  static const BottomNav = TextStyle(
    fontSize: 16,
  );
  static const ProductHomeTitle = TextStyle(
    fontSize: 16,
  );

  static const DetailSalePrice = TextStyle(
    color: ThemeColors.Orange,
    fontWeight: FontWeight.w700,
    fontSize: 19,
  );
  static const DetailPrice = TextStyle(
    color: ThemeColors.Grey700,
    fontWeight: FontWeight.w700,
    fontSize: 19,
  );
  static const DetailRegularPrice = TextStyle(
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
    decorationColor: ThemeColors.Grey700,
    decorationStyle: TextDecorationStyle.solid,
    fontSize: 19,
  );

  static const DetailBottomSalePrice = TextStyle(
    color: ThemeColors.Grey700,
    fontWeight: FontWeight.w700,
    fontSize: 19,
  );
  static const DetailBottomPrice = TextStyle(
    color: ThemeColors.Grey700,
    fontWeight: FontWeight.w700,
    fontSize: 19,
  );
  static const DetailBottomRegularPrice = TextStyle(
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
    decorationColor: ThemeColors.Grey700,
    decorationStyle: TextDecorationStyle.solid,
    fontSize: 19,
  );
}
