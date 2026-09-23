import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class FilterPillsWidget extends StatelessWidget {
  const FilterPillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          BuildPill(icon: Icons.tune, text: 'Filters'),
          SizedBox(width: 12.w),
          BuildPill(icon: Icons.trending_up, text: 'Trending Searches',clr: AppColors.primary,),
        ],
      ),
    );
  }
}

class BuildPill extends StatelessWidget {
  const BuildPill({
    super.key,
    required this.icon,
    required this.text, this.clr,
  });

  final IconData icon;
  final String text;
  final Color? clr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.black.withValues(alpha: .05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.spMin, color:clr?? AppColors.text.withValues(alpha: 0.7)),
          SizedBox(width: 6.w),
          AppText(
            text,
            fontSize: 13,
            color: AppColors.k434343,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
