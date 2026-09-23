import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/story_list_widget.dart';
import '../widgets/filter_pills_widget.dart';
import '../widgets/create_post_input_widget.dart';
import '../widgets/post_item_widget.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/feed_skeleton.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().refresh();
              await Future.delayed(const Duration(milliseconds: 800));
            },
            color: AppColors.primary,
            backgroundColor: AppColors.background,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  const StoryListWidget(),
                  SizedBox(height: 16.h),
                  const FilterPillsWidget(),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.border, height: 1.h, thickness: 1.h),
                  SizedBox(height: 16.h),
                  const CreatePostInputWidget(),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.border, height: 1.h, thickness: 1.h),
                  
                  BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedLoading) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: const FeedSkeleton(),
                        );
                      } else if (state is FeedError) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Center(
                            child: AppText(state.message, color: Colors.red),
                          ),
                        );
                      } else if (state is FeedLoaded) {
                        final posts = state.posts;
                        if (posts.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            child: const Center(child: AppText('No posts yet')),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.border,
                            height: 32.h,
                            thickness: 1.h,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: PostItemWidget(post: posts[index].toMap()),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        }
    );
  }
}
