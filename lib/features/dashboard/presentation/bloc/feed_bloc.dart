import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/repositories/post_repository.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
  @override
  List<Object?> get props => [];
}

class FeedFetched extends FeedEvent {}

class FeedRefreshed extends FeedEvent {}

class FeedPostDeleted extends FeedEvent {
  final int postId;
  const FeedPostDeleted(this.postId);
  @override
  List<Object?> get props => [postId];
}

class FeedPostLiked extends FeedEvent {
  final int postId;
  const FeedPostLiked(this.postId);
  @override
  List<Object?> get props => [postId];
}

class FeedPostCommentAdded extends FeedEvent {
  final int postId;
  const FeedPostCommentAdded(this.postId);
  @override
  List<Object?> get props => [postId];
}

abstract class FeedState extends Equatable {
  const FeedState();
  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  const FeedLoaded(this.posts);
  @override
  List<Object?> get props => [posts];
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);
  @override
  List<Object?> get props => [message];
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository repository;

  FeedBloc({required this.repository}) : super(FeedInitial()) {
    on<FeedFetched>((event, emit) async {
      emit(FeedLoading());
      try {
        final posts = await repository.getPosts(page: 0, size: 10);
        emit(FeedLoaded(posts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<FeedRefreshed>((event, emit) async {
      emit(FeedLoading());
      try {
        final posts = await repository.getPosts(page: 0, size: 10);
        emit(FeedLoaded(posts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<FeedPostDeleted>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        try {
          await repository.deletePost(event.postId);
          final updatedPosts = currentState.posts.where((p) => p.id != event.postId).toList();
          emit(FeedLoaded(updatedPosts));
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });

    on<FeedPostLiked>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        // Optimistic UI update
        final posts = List<Post>.from(currentState.posts);
        final index = posts.indexWhere((p) => p.id == event.postId);
        if (index != -1) {
          final post = posts[index];
          final newIsLiked = !post.isLiked;
          final newLikeCount = newIsLiked ? post.likeCount + 1 : post.likeCount - 1;
          
          posts[index] = post.copyWith(isLiked: newIsLiked, likeCount: newLikeCount);
          emit(FeedLoaded(posts));

          try {
            await repository.toggleLike(event.postId);
          } catch (e) {
            // Revert on failure
            posts[index] = post;
            emit(FeedLoaded(posts));
          }
        }
      }
    });

    on<FeedPostCommentAdded>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        final posts = List<Post>.from(currentState.posts);
        final index = posts.indexWhere((p) => p.id == event.postId);
        if (index != -1) {
          final post = posts[index];
          posts[index] = post.copyWith(commentCount: post.commentCount + 1);
          emit(FeedLoaded(posts));
        }
      }
    });
  }

  Future<void> refresh() async {
    add(FeedRefreshed());
  }
}
