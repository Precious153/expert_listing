import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h, bottom: MediaQuery.of(context).padding.bottom + 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1.h)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icons/Component 185.svg', 'Home'),
          _buildNavItem(1, 'assets/icons/Component 187.svg', 'Feed', badgeText: 'Beta'),
          _buildNavItem(2, 'assets/icons/favourite.svg', 'Wishlist'),
          _buildNavItem(3, 'assets/icons/BellSimple.svg', 'Notification'),
          _buildNavItem(4, 'assets/icons/User.svg', 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String icon, String label, {String? badgeText}) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: NavItem(
        icon: icon,
        label: label,
        isSelected: isSelected,
        badgeText: badgeText,
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badgeText,
  });

  final String icon;
  final String label;
  final bool isSelected;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon,
          height: 24.h,
          width: 24.w,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primary : AppColors.k434343,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            AppText(
              label,
              fontSize: 14,
              color: isSelected? AppColors.primary:  AppColors.k434343,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            if (badgeText != null)
              SizedBox(width: 8.w,),
            if (badgeText != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.kEAF7DA,
                  borderRadius: BorderRadius.circular(26.r),
                ),
                child: AppText(
                  badgeText??'',
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
