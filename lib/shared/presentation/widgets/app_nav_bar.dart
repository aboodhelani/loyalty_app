import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';

class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavItem(this.icon, this.activeIcon, this.label);
}

/// Floating bottom navigation shared by the three shells. The selected tab is
/// a solid brand pill with its label; the others are icons only.
class AppNavBar extends StatelessWidget {
  final List<AppNavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  const AppNavBar({super.key, required this.items, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Transparent around the pill, so content (the map) shows behind it.
    return ColoredBox(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 8.h),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 6.h, 16.w, 4.h),
          child: Container(
            height: 66.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(33.h),
              boxShadow: [
                BoxShadow(
                    color: AppColors.foreground.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    flex: i == index ? 2 : 1,
                    child: _NavItem(item: items[i], selected: i == index, onTap: () => onChanged(i)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 46.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: selected ? 14.w : 0),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(23.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 22.sp,
                  color: selected ? AppColors.white : AppColors.foregroundSubtle,
                ),
                if (selected) ...[
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: AppTextStyle.small.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
