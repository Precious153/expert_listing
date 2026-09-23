import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/network/connectivity_cubit.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/story_list_widget.dart';
import '../widgets/filter_pills_widget.dart';
import '../widgets/create_post_input_widget.dart';
import '../widgets/post_item_widget.dart';
import '../widgets/feed_skeleton.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  Widget _buildStatusBanner(BuildContext context, FeedState feedState, ConnectivityStatus connectivityStatus) {
    if (connectivityStatus == ConnectivityStatus.offline) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        color: AppColors.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 16.spMin, color: AppColors.text),
            SizedBox(width: 8.w),
            AppText('No internet connection', fontSize: 14, color: AppColors.text),
            if (feedState is FeedError || (feedState is FeedLoaded && feedState.posts.isEmpty)) ...[
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  context.read<FeedBloc>().refresh();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: AppText('Retry', fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      );
    }
    
    if (feedState is FeedLoading) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        color: AppColors.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: 8.r),
            SizedBox(width: 8.w),
            AppText('Loading...', fontSize: 14, color: AppColors.text),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

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
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  final state = context.read<FeedBloc>().state;
                  if (state is FeedLoaded && !state.hasReachedMax) {
                    context.read<FeedBloc>().add(FeedLoadMore());
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
                    builder: (context, connectivityStatus) {
                      return BlocBuilder<FeedBloc, FeedState>(
                        builder: (context, feedState) {
                          return _buildStatusBanner(context, feedState, connectivityStatus);
                        },
                      );
                    },
                  ),
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
                        return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
                          builder: (context, connectivityStatus) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.h),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      connectivityStatus == ConnectivityStatus.offline
                                          ? Icons.wifi_off
                                          : Icons.error_outline,
                                      size: 48.spMin,
                                      color: AppColors.hint,
                                    ),
                                    SizedBox(height: 16.h),
                                    AppText(
                                      connectivityStatus == ConnectivityStatus.offline
                                          ? 'No internet connection'
                                          : state.message,
                                      color: AppColors.text,
                                    ),
                                    SizedBox(height: 24.h),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<FeedBloc>().refresh();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                      ),
                                      child: AppText('Retry', color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                  BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedLoaded && !state.hasReachedMax && state.posts.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: CupertinoActivityIndicator(radius: 12.r),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
