import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final String authorName;
  final String content;
  final String createdAt;
  final int userId;

  const Comment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int? ?? 0,
      authorName: json['authorName'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, authorName, content, createdAt, userId];
}
