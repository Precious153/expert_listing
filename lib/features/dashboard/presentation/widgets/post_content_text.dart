import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_text.dart';

class PostContentText extends StatelessWidget {
  const PostContentText({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppText(
        post['content'] as String,
        fontSize: 14,
      ),
    );
  }
}
