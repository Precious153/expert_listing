import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/create_post_request.dart';

class PostCategoryBottomSheet extends StatelessWidget {
  const PostCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AppText(
            'Select Category',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ...TransactionType.values.map((type) => _buildCategoryOption(context, type)),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(BuildContext context, TransactionType type) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          context.pop(type);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  _getCategoryLabel(type),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                Icon(Icons.arrow_forward_ios, size: 16.spMin, color: AppColors.text),
              ],
            ),
            SizedBox(height: 10.h,),
            Divider()
          ],
        ),
      ),
    );
  }

  String _getCategoryLabel(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return 'Property for Sale';
      case TransactionType.rent:
        return 'Property for Rent';
      case TransactionType.general:
        return 'General Discussion';
    }
  }
}
