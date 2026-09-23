import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class PostLikes extends StatelessWidget {
  const PostLikes({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final likeCount = post['likesCount'] as String;
    if (likeCount == '0') {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13.spMin, color: AppColors.text, fontFamily: 'Poppins'),
                children: [
                  TextSpan(text: '$likeCount likes', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
