import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/profile_bloc.dart';
import '../../features/posts/domain/repositories/post_repository.dart';
import '../../features/posts/data/repositories/post_repository_impl.dart';
import '../../features/posts/presentation/bloc/create_post_bloc.dart';
import '../../features/dashboard/presentation/bloc/feed_bloc.dart';
import '../../features/posts/presentation/bloc/comments_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: 'https://expertlisting-60hz.onrender.com'));
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(apiClient: sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());

  // BLoCs
  sl.registerFactory(() => AuthBloc(repository: sl()));
  sl.registerFactory(() => ProfileBloc(authRepository: sl()));
  sl.registerFactory(() => CreatePostBloc(repository: sl()));
  sl.registerFactory(() => FeedBloc(repository: sl()));
  sl.registerFactory(() => CommentsBloc(repository: sl()));
}
