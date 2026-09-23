import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../dashboard/presentation/bloc/feed_bloc.dart';
import '../bloc/comments_bloc.dart';

class CommentsBottomSheet extends StatelessWidget {
  final int postId;

  const CommentsBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentsBloc>()..add(CommentsFetched(postId)),
      child: _CommentsBottomSheetView(postId: postId),
    );
  }
}

class _CommentsBottomSheetView extends StatefulWidget {
  final int postId;

  const _CommentsBottomSheetView({required this.postId});

  @override
  State<_CommentsBottomSheetView> createState() => _CommentsBottomSheetViewState();
}

class _CommentsBottomSheetViewState extends State<_CommentsBottomSheetView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitComment(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Dispatch comment
    context.read<CommentsBloc>().add(CommentAdded(widget.postId, text));
    // Optimistically tell feed bloc to increase count
    context.read<FeedBloc>().add(FeedPostCommentAdded(widget.postId));
    
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75 + keyboardHeight,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (state is CommentsError) {
                  return Center(
                    child: AppText(state.message, color: Colors.red),
                  );
                } else if (state is CommentsLoaded) {
                  final comments = state.comments;
                  if (comments.isEmpty) {
                    return Center(
                      child: AppText('No comments yet.', color: AppColors.hint),
                    );
                  }
                  
                  return ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor: AppColors.surface,
                            child: Icon(Icons.person, color: AppColors.hint, size: 20.spMin),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppText(
                                      comment.authorName.isNotEmpty ? comment.authorName : 'User',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    SizedBox(width: 8.w),
                                    AppText(
                                      DateFormatter.formatCommentDate(comment.createdAt),
                                      fontSize: 12,
                                      color: AppColors.text.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                AppText(
                                  comment.content,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const Divider(height: 1),
          _buildInput(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppText('Comments', fontSize: 16, fontWeight: FontWeight.bold),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: 12.h + MediaQuery.of(context).padding.bottom,
      ),
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, color: AppColors.hint, size: 20.spMin),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(fontSize: 14.spMin, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(fontSize: 14.spMin, color: AppColors.hint),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitComment(context),
              ),
            ),
            SizedBox(width: 8.w),
            BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                final isSubmitting = state is CommentsLoaded && state.isSubmitting;
                
                return GestureDetector(
                  onTap: isSubmitting ? null : () => _submitComment(context),
                  child: isSubmitting
                      ? const CupertinoActivityIndicator()
                      : Icon(Icons.send, color: AppColors.primary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
