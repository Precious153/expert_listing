import '../entities/create_post_request.dart';
import '../entities/post.dart';
import '../entities/comment.dart';

import 'dart:io';

abstract class PostRepository {
  Future<void> createPost(CreatePostRequest request);
  Future<List<Post>> getPosts({int page = 0, int size = 10});
  Future<List<Comment>> getComments(int postId);
  Future<Comment> addComment(int postId, String content);
  Future<void> toggleLike(int postId);
  Future<String> uploadImage(File image);
  Future<void> deletePost(int postId);
}
