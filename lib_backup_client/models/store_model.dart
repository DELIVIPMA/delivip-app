import 'package:flutter/material.dart';

class StoreModel {
  final String id;
  final String name;
  final String emoji;
  final String category;
  final List<String> tags;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final bool isOpen;
  final String? promoBadge;
  final Color bgColor;
  final String? imageUrl;

  StoreModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.tags,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isOpen = true,
    this.promoBadge,
    this.bgColor = const Color(0xFFF0F0F0),
    this.imageUrl,
  });
}
