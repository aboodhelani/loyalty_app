import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';

/// Icon and accent per category — map pins, chips and placeholder covers.
/// Accepts the category slug (`car-wash`) or the API icon name (`car`).
class CategoryStyle {
  final IconData icon;
  final Color color;

  const CategoryStyle(this.icon, this.color);

  static CategoryStyle of(String? key) {
    switch (key) {
      case 'cafe':
      case 'coffee':
        return const CategoryStyle(AppIcons.cafe, AppColors.categoryCafe);
      case 'restaurant':
      case 'utensils':
        return const CategoryStyle(AppIcons.restaurant, AppColors.categoryRestaurant);
      case 'salon':
      case 'sparkles':
        return const CategoryStyle(AppIcons.salon, AppColors.categorySalon);
      case 'barber':
      case 'scissors':
        return const CategoryStyle(AppIcons.barber, AppColors.categoryBarber);
      case 'car-wash':
      case 'car':
        return const CategoryStyle(AppIcons.carWash, AppColors.categoryCarWash);
      case 'tailor':
      case 'shirt':
        return const CategoryStyle(AppIcons.tailor, AppColors.categoryTailor);
      case 'retail':
      case 'shopping-bag':
        return const CategoryStyle(AppIcons.retail, AppColors.categoryRetail);
      case 'beauty':
      case 'flower':
        return const CategoryStyle(AppIcons.beauty, AppColors.categoryBeauty);
      default:
        return CategoryStyle(AppIcons.storeFill, AppColors.primary);
    }
  }
}

/// Logo stand-in: the category icon on a tinted rounded square.
class CategoryAvatar extends StatelessWidget {
  final String? categoryKey;
  final double size;

  const CategoryAvatar({super.key, required this.categoryKey, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(categoryKey);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(style.icon, color: style.color, size: size * 0.5),
    );
  }
}

/// The business logo, falling back to [CategoryAvatar] while loading or when
/// there is none.
class BusinessLogo extends StatelessWidget {
  final String? logoUrl;
  final String? categoryKey;
  final double size;

  const BusinessLogo({super.key, required this.logoUrl, required this.categoryKey, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final fallback = CategoryAvatar(categoryKey: categoryKey, size: size);
    if (logoUrl == null || logoUrl!.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: CachedNetworkImage(
        imageUrl: logoUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => fallback,
        errorWidget: (_, __, ___) => fallback,
      ),
    );
  }
}
