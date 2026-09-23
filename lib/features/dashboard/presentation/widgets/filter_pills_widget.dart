import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../posts/domain/entities/post_filters.dart';
import '../bloc/feed_bloc.dart';
import 'filter_bottom_sheet.dart';

class FilterPillsWidget extends StatelessWidget {
  const FilterPillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        bool hasFilters = false;
        PostFilters currentFilters = const PostFilters();
        if (state is FeedLoaded) {
          hasFilters = state.activeFilters.isNotEmpty;
          currentFilters = state.activeFilters;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  FilterBottomSheet.show(context, currentFilters);
                },
                child: BuildPill(
                  icon: Icons.tune,
                  text: 'Filters',
                  clr: hasFilters ? Colors.white : null,
                  bgColor: hasFilters ? AppColors.primary : null,
                ),
              ),
              SizedBox(width: 12.w),
              BuildPill(icon: Icons.trending_up, text: 'Trending Searches', clr: AppColors.primary),
            ],
          ),
        );
      },
    );
  }
}

class BuildPill extends StatelessWidget {
  const BuildPill({
    super.key,
    required this.icon,
    required this.text,
    this.clr,
    this.bgColor,
  });

  final IconData icon;
  final String text;
  final Color? clr;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bgColor != null ? bgColor! : AppColors.black.withValues(alpha: .05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.spMin, color: clr ?? AppColors.text.withValues(alpha: 0.7)),
          SizedBox(width: 6.w),
          AppText(
            text,
            fontSize: 13,
            color: clr ?? AppColors.k434343,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
