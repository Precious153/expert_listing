import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'post_header.dart';
import 'post_content_text.dart';
import 'post_media.dart';
import 'post_likes.dart';
import 'post_actions.dart';
import 'post_comments.dart';

class PostItemWidget extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostHeader(post: post),
        SizedBox(height: 12.h),
        PostContentText(post: post),
        SizedBox(height: 12.h),
        if ((post['image'] as String).isNotEmpty) ...[
          PostMedia(post: post),
          SizedBox(height: 12.h),
        ],
        PostLikes(post: post),
        SizedBox(height: 12.h),
        PostActions(post: post),
        PostComments(post: post),
      ],
    );
  }
}

