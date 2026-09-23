import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/presentation/bloc/profile_bloc.dart';
import '../bloc/feed_bloc.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.surface,
            backgroundImage: (post['avatar'] as String).startsWith('http')
                ? NetworkImage(post['avatar'] as String) as ImageProvider
                : null,
            child: (post['avatar'] as String).startsWith('http')
                ? null
                : Icon(Icons.person, color: AppColors.hint),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      post['name'] as String,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    // SizedBox(width: 6.w),
                    // Container(
                    //   width: 4.w,
                    //   height: 4.w,
                    //   decoration: const BoxDecoration(
                    //     color: Colors.grey,
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    // SizedBox(width: 6.w),
                    // AppText(
                    //   post['role'] as String,
                    //   fontSize: 12,
                    //   color: AppColors.text.withValues(alpha: 0.6),
                    // ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    AppText(
                      post['tag'] as String,
                      fontSize: 12,
                      color: AppColors.text.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    AppText(
                      DateFormatter.formatPostDate(post['time'] as String?),
                      fontSize: 12,
                      color: AppColors.text.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/MapPin.svg', width: 12.spMin, height: 12.spMin),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AppText(
                        post['location'] as String,
                        fontSize: 12,
                        color: AppColors.text.withValues(alpha: 0.6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String currentUserId = '';
              if (state is ProfileLoaded) {
                currentUserId = state.user.id;
              }
              
              final int postUserId = post['userId'] as int? ?? 0;
              final bool isOwner = currentUserId == postUserId.toString() && currentUserId.isNotEmpty;
              
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: AppColors.text.withValues(alpha: 0.6)),
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(context, post['id'] as int? ?? 0);
                  } else if (value == 'report') {
                    _showReportDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  if (isOwner)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    )
                  else
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }


  void _showDeleteDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: AppText('Delete Post', fontSize: 18, fontWeight: FontWeight.w600),
        content: AppText('Are you sure you want to delete this post? This action cannot be undone.'),
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: AppText('Cancel', color: AppColors.hint),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<FeedBloc>().add(FeedPostDeleted(postId));
            },
            child: AppText('Delete', color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText('Report Post', fontSize: 20, fontWeight: FontWeight.bold),
              SizedBox(height: 16.h),
              AppText(
                'This feature requires a backend endpoint for submitting reports. It is currently in development.',
                color: AppColors.hint,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: AppText('Got it', color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
