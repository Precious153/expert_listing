import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/skeleton_widget.dart';
import '../../../../core/theme/app_colors.dart';

class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => Divider(
        color: AppColors.border,
        height: 32.h,
        thickness: 1.h,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    SkeletonWidget(
                      width: 40.r,
                      height: 40.r,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(width: 120.w, height: 14.h),
                          SizedBox(height: 6.h),
                          SkeletonWidget(width: 80.w, height: 12.h),
                        ],
                      ),
                    ),
                    SkeletonWidget(width: 24.w, height: 24.h),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              
              // Content Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonWidget(width: double.infinity, height: 14.h),
                    SizedBox(height: 6.h),
                    SkeletonWidget(width: 200.w, height: 14.h),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              
              // Media Placeholder
              SkeletonWidget(
                width: double.infinity,
                height: 250.h,
                borderRadius: 0,
              ),
              SizedBox(height: 16.h),
              
              // Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    SkeletonWidget(width: 24.w, height: 24.h),
                    SizedBox(width: 16.w),
                    SkeletonWidget(width: 24.w, height: 24.h),
                    SizedBox(width: 16.w),
                    SkeletonWidget(width: 24.w, height: 24.h),
                    const Spacer(),
                    SkeletonWidget(width: 24.w, height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
