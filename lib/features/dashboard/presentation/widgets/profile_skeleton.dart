import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/skeleton_widget.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildActionSkeleton(),
          SizedBox(height: 16.h),
          _buildActionSkeleton(),
          SizedBox(height: 16.h),
          _buildActionSkeleton(),
          SizedBox(height: 32.h),
          
          Divider(color: AppColors.border, height: 1.h, thickness: 1.h),
          SizedBox(height: 32.h),
          _buildActionSkeleton(),
        ],
      ),
    );
  }

  Widget _buildActionSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SkeletonWidget(width: 24.w, height: 24.h, shape: BoxShape.circle),
          SizedBox(width: 16.w),
          SkeletonWidget(width: 120.w, height: 16.h),
          const Spacer(),
          SkeletonWidget(width: 20.w, height: 20.h),
        ],
      ),
    );
  }
}
