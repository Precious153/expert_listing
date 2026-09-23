import 'package:expert_listing/core/network/api_client.dart';
import 'package:expert_listing/core/network/api_endpoints.dart';
import 'package:expert_listing/core/storage/secure_storage.dart';
import 'package:expert_listing/core/di/injection_container.dart';
import 'package:expert_listing/core/network/api_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<User> login(String email, String password) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final data = apiResponse.data!;
    final token = data['token'] as String?;
    if (token != null) {
      await sl<SecureStorage>().saveToken(token);
    }

    return User.fromJson(data);
  }

  @override
  Future<User> register(String firstName, String lastName, String email, String password) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final data = apiResponse.data!;
    final token = data['token'] as String?;
    if (token != null) {
      await sl<SecureStorage>().saveToken(token);
    }

    return User.fromJson(data);
  }

  @override
  Future<User> getCurrentUser() async {
    final response = await apiClient.dio.get(ApiEndpoints.currentUser);
    final apiResponse = ApiResponse<User>.fromJson(
      response.data,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data!;
  }

  @override
  Future<void> logout() async {
    await sl<SecureStorage>().clearToken();
  }
}
