import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class StoryListWidget extends StatelessWidget {
  const StoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'name': 'Your Story', 'isAdd': true, 'image': 'assets/images/expert_logo.png'},

    ];

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final story = stories[index];
          final isAdd = story['isAdd'] as bool;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 64.h,
                    height: 64.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isAdd ? Colors.black.withOpacity(.5) : AppColors.primary,
                        width: 2.w,
                      ),
                      image: DecorationImage(
                        image: AssetImage(story['image'] as String,),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isAdd)
                    Container(
                      width: 20.h,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2.w),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 12.spMin),
                    ),
                ],
              ),
              SizedBox(height: 6.h),
              AppText(
                story['name'] as String,
                fontSize: 14,
                color: AppColors.k434343,
              ),
            ],
          );
        },
      ),
    );
  }
}
