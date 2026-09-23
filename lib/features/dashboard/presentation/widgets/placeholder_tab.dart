import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class PlaceholderTab extends StatelessWidget {
  final String title;

  const PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64.spMin, color: AppColors.hint),
          SizedBox(height: 16.h),
          AppText(
            title,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          SizedBox(height: 8.h),
          AppText(
            'This feature is coming soon.',
            fontSize: 14,
            color: AppColors.hint,
          ),
        ],
      ),
    );
  }
}
