import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String authorName;
  final String content;
  final String imageUrl;
  final String location;
  final String transactionType;
  final int commentCount;
  final int likeCount;
  final String createdAt;
  final int userId;
  final bool isLiked;

  const Post({
    required this.id,
    required this.authorName,
    required this.content,
    required this.imageUrl,
    required this.location,
    required this.transactionType,
    required this.commentCount,
    required this.likeCount,
    required this.createdAt,
    required this.userId,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      authorName: json['authorName'] as String? ?? 'User',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      location: json['location'] as String? ?? '',
      transactionType: json['transactionType'] as String? ?? 'General',
      commentCount: json['commentCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? 'Just Now',
      userId: json['userId'] as int? ?? 0,
      isLiked: false, // Default to false since backend doesn't explicitly return this
    );
  }

  Post copyWith({
    int? id,
    String? authorName,
    String? content,
    String? imageUrl,
    String? location,
    String? transactionType,
    int? commentCount,
    int? likeCount,
    String? createdAt,
    int? userId,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      transactionType: transactionType ?? this.transactionType,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    String formattedTransactionType = transactionType;
    if (transactionType == 'FOR_SALE') {
      formattedTransactionType = 'FOR SALE';
    } else if (transactionType == 'FOR_RENT') {
      formattedTransactionType = 'RENT';
    }

    return {
      'avatar': '',
      'name': authorName,
      'role': 'User',
      'category': formattedTransactionType,
      'time': createdAt,
      'location': location,
      'content': content,
      'image': imageUrl,
      'tag': formattedTransactionType,
      'likesCount': likeCount.toString(),
      'likes': likeCount.toString(),
      'commentsCount': commentCount.toString(),
      'views': '0',
      'comments': null,
      'id': id,
      'userId': userId,
      'isLiked': isLiked,
    };
  }

  @override
  List<Object?> get props => [
        id,
        authorName,
        content,
        imageUrl,
        location,
        transactionType,
        commentCount,
        likeCount,
        createdAt,
        userId,
        isLiked,
      ];
}
