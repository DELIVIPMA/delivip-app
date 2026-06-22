import 'package:flutter/material.dart';

class ProductOption {
  final String id;
  final String name;
  final String? emoji;
  final double price;
  final bool isDefault;

  ProductOption({
    required this.id,
    required this.name,
    this.emoji,
    this.price = 0,
    this.isDefault = false,
  });
}

class ProductOptionGroup {
  final String id;
  final String title;
  final String? subtitle;
  final bool isRequired;
  final int? maxSelections;
  final OptionType type;
  final List<ProductOption> options;

  ProductOptionGroup({
    required this.id,
    required this.title,
    this.subtitle,
    this.isRequired = false,
    this.maxSelections,
    this.type = OptionType.radio,
    required this.options,
  });
}

enum OptionType { radio, checkbox, stepper }

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final double basePrice;
  final int calories;
  final Color bgColor;
  final List<ProductOptionGroup> optionGroups;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.basePrice,
    this.calories = 0,
    this.bgColor = const Color(0xFFFFF3E0),
    required this.optionGroups,
  });

  double get totalPrice {
    // Base calculation, actual price with options is computed in the sheet
    return basePrice;
  }
}
