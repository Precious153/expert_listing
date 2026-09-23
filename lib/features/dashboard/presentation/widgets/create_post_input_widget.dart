import 'package:expert_listing/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expert_listing/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../posts/presentation/widgets/post_category_bottom_sheet.dart';
import '../bloc/feed_bloc.dart';

class CreatePostInputWidget extends StatelessWidget {
  const CreatePostInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final type = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => const PostCategoryBottomSheet(),
        );
        if (type != null && context.mounted) {
          final result = await context.push<bool>('/create-post', extra: type);
          if (result == true && context.mounted) {
            context.read<FeedBloc>().refresh();
          }
        }
      },
      child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(888.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, color: AppColors.hint),
            ),
            SizedBox(width: 8.w,),
            Expanded(
              child: AppText('Share a property, request or say something...',
              maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
                color: AppColors.hint,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
