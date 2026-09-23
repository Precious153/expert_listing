class ApiEndpoints {
  static const String baseUrl = 'https://expertlisting-60hz.onrender.com';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String posts = '/posts';

  static const String currentUser = '/auth/me';
  static const String uploadImage = '/uploads/images';

  static String post(int postId) => '/posts/$postId';

  static String postComments(int postId) => '/posts/$postId/comments';

  static String addComment(int postId) => '/posts/$postId/comments';

  static String toggleLike(int postId) => '/posts/$postId/like';
}
