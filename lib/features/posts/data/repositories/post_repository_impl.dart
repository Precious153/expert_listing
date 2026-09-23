import 'package:expert_listing/core/network/api_client.dart';
import 'package:expert_listing/core/network/api_endpoints.dart';
import 'package:expert_listing/core/di/injection_container.dart';
import '../../domain/entities/create_post_request.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/post_repository.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expert_listing/core/network/api_response.dart';
import 'package:expert_listing/core/network/paginated_response.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<void> createPost(CreatePostRequest request) async {
    final client = sl<ApiClient>();
    await client.dio.post(
      ApiEndpoints.posts,
      data: request.toJson(),
    );
  }

  @override
  Future<List<Post>> getPosts({int page = 0, int size = 10}) async {
    final client = sl<ApiClient>();
    final response = await client.dio.get(
      ApiEndpoints.posts,
      queryParameters: {'page': page, 'size': size},
    );
    final apiResponse = ApiResponse<PaginatedResponse<Post>>.fromJson(
      response.data,
      (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        (item) => Post.fromJson(item as Map<String, dynamic>),
      ),
    );
    return apiResponse.data?.content ?? [];
  }

  @override
  Future<List<Comment>> getComments(int postId) async {
    final client = sl<ApiClient>();
    final response = await client.dio.get(ApiEndpoints.postComments(postId));
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data,
      (json) => json as List<dynamic>,
    );
    final data = apiResponse.data ?? [];
    return data.map((e) => Comment.fromJson(e)).toList();
  }

  @override
  Future<Comment> addComment(int postId, String content) async {
    final client = sl<ApiClient>();
    final response = await client.dio.post(
      ApiEndpoints.addComment(postId),
      data: {'content': content},
    );
    final apiResponse = ApiResponse<Comment>.fromJson(
      response.data,
      (json) => Comment.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data!;
  }

  @override
  Future<void> toggleLike(int postId) async {
    final client = sl<ApiClient>();
    await client.dio.post(ApiEndpoints.toggleLike(postId));
  }

  @override
  Future<String> uploadImage(File image) async {
    final client = sl<ApiClient>();
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final response = await client.dio.post(
      ApiEndpoints.uploadImage,
      data: formData,
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse.data?['imageUrl'] as String? ?? '';
  }

  @override
  Future<void> deletePost(int postId) async {
    final client = sl<ApiClient>();
    await client.dio.delete(ApiEndpoints.post(postId));
  }
}
