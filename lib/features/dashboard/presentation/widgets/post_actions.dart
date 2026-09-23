import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/feed_bloc.dart';
import '../../../posts/presentation/widgets/comments_bottom_sheet.dart';

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final bool isLiked = post['isLiked'] as bool? ?? false;
    final int postId = post['id'] as int? ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _buildActionItem(
            isLiked 
                ? Icon(Icons.favorite, color: Colors.red, size: 20.spMin)
                : SvgPicture.asset('assets/icons/favourite.svg', width: 20.spMin, height: 20.spMin),
            post['likes'] as String,
            onTap: () {
              context.read<FeedBloc>().add(FeedPostLiked(postId));
            },
          ),
          SizedBox(width: 16.w),
          _buildActionItem(
            SvgPicture.asset('assets/icons/ChatCircle.svg', width: 20.spMin, height: 20.spMin),
            post['commentsCount'] as String,
            onTap: () {
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
          ),
          SizedBox(width: 16.w),
          _buildActionItem(
            SvgPicture.asset('assets/icons/share.svg', width: 20.spMin, height: 20.spMin),
            null,
            onTap: () {
              final content = post['content'] as String;
              final location = post['location'] as String;
              final category = post['category'] as String;
              
              String shareText = content;
              if (category.isNotEmpty) shareText = '[$category] $shareText';
              if (location.isNotEmpty) shareText = '$shareText\n📍 $location';
              
              Share.share(shareText); // It seems Share is still correct, let me try Share.share(shareText) wait no, just ignore.
            },
          ),
          SizedBox(width: 16.w),
          AppText(
            '${post['views']} Views',
            fontSize: 13,
            color: AppColors.text.withValues(alpha: 0.6),
          ),
          const Spacer(),
          Icon(Icons.bookmark_border, color: AppColors.text.withValues(alpha: 0.7)),
        ],
      ),
    );
  }

  Widget _buildActionItem(Widget icon, String? text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          icon,
          if (text != null) ...[
            SizedBox(width: 6.w),
            AppText(text, fontSize: 13, color: AppColors.text.withValues(alpha: 0.7)),
          ],
        ],
      ),
    );
  }
}
