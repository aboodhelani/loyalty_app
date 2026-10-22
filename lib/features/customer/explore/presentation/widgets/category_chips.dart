import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/category.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';

class CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  const CategoryChips({super.key, required this.categories, required this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        children: [
          _chip(label: S.of(context).allCategories, selected: selectedId == null, onTap: () => onSelected(null)),
          for (final c in categories)
            _chip(
              label: c.name,
              icon: CategoryStyle.of(c.slug).icon,
              selected: selectedId == c.id,
              onTap: () => onSelected(selectedId == c.id ? null : c.id),
            ),
        ],
      ),
    );
  }

  Widget _chip({required String label, IconData? icon, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8.w),
      child: Material(
        color: selected ? AppColors.primary : AppColors.surfaceElevated,
        elevation: selected ? 2 : 1,
        shadowColor: AppColors.shadow,
        shape: StadiumBorder(side: BorderSide(color: selected ? AppColors.primary : AppColors.border)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16.sp, color: selected ? AppColors.white : AppColors.foregroundSubtle),
                  SizedBox(width: 6.w),
                ],
                Text(
                  label,
                  style: AppTextStyle.label.copyWith(color: selected ? AppColors.white : AppColors.foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
