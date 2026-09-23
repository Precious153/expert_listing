import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_text.dart';

class PostMedia extends StatelessWidget {
  const PostMedia({
    super.key,
    required this.post,
  });

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final imageUrl = post['image'] as String;
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Builder(
          builder: (context) {
            if (imageUrl.startsWith('http')) {
              return Image.network(
                imageUrl,
                width: double.infinity,
                height: 300.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 300.h,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            }
            return Container(
              width: double.infinity,
              height: 300.h,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            );
          }
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.sell, size: 12.spMin, color: Colors.white),
                SizedBox(width: 6.w),
                AppText(
                  post['tag'] as String,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
