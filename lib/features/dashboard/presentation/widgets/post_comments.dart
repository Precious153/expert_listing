import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../posts/presentation/widgets/comments_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
class PostComments extends StatelessWidget {
  const PostComments({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final commentsCountStr = post['commentsCount'] as String;
    final int commentsCount = int.tryParse(commentsCountStr) ?? 0;
    
    if (commentsCount == 0) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () {
          final int postId = post['id'] as int? ?? 0;
          final feedBloc = context.read<FeedBloc>();
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.background,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: feedBloc,
              child: CommentsBottomSheet(postId: postId),
            ),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: AppText(
          'View all $commentsCountStr comments',
          fontSize: 13,
          color: AppColors.text.withValues(alpha: 0.5),
        ),
      ),
    ),
      ],
    );
  }
}
