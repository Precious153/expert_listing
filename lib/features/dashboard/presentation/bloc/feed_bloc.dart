import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/entities/post_filters.dart';
import '../../../posts/domain/repositories/post_repository.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
  @override
  List<Object?> get props => [];
}

class FeedFetched extends FeedEvent {}

class FeedRefreshed extends FeedEvent {}

class FeedLoadMore extends FeedEvent {}

class FeedFilterApplied extends FeedEvent {
  final PostFilters filters;
  const FeedFilterApplied(this.filters);
  @override
  List<Object?> get props => [filters];
}

class FeedFilterCleared extends FeedEvent {}

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
  final List<Post> allPosts;
  final List<Post> trendingPosts;
  final PostFilters activeFilters;
  final bool hasReachedMax;
  final int currentPage;

  const FeedLoaded({
    required this.posts,
    required this.allPosts,
    this.trendingPosts = const [],
    this.activeFilters = const PostFilters(),
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  FeedLoaded copyWith({
    List<Post>? posts,
    List<Post>? allPosts,
    List<Post>? trendingPosts,
    PostFilters? activeFilters,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      allPosts: allPosts ?? this.allPosts,
      trendingPosts: trendingPosts ?? this.trendingPosts,
      activeFilters: activeFilters ?? this.activeFilters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [posts, allPosts, trendingPosts, activeFilters, hasReachedMax, currentPage];
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
        final allPosts = await repository.getPosts(page: 0, size: 10);
        final trendingPosts = _calculateTrending(allPosts);
        emit(FeedLoaded(
          posts: allPosts,
          allPosts: allPosts,
          trendingPosts: trendingPosts,
          hasReachedMax: allPosts.length < 10,
          currentPage: 0,
        ));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<FeedRefreshed>((event, emit) async {
      final currentState = state;
      PostFilters currentFilters = const PostFilters();
      if (currentState is FeedLoaded) {
        currentFilters = currentState.activeFilters;
      }
      
      emit(FeedLoading());
      try {
        final allPosts = await repository.getPosts(page: 0, size: 10);
        final trendingPosts = _calculateTrending(allPosts);
        final filteredPosts = _applyFilters(allPosts, currentFilters);
        
        emit(FeedLoaded(
          posts: filteredPosts,
          allPosts: allPosts,
          trendingPosts: trendingPosts,
          activeFilters: currentFilters,
          hasReachedMax: allPosts.length < 10,
          currentPage: 0,
        ));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<FeedLoadMore>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded && !currentState.hasReachedMax) {
        try {
          final nextPage = currentState.currentPage + 1;
          final newPosts = await repository.getPosts(page: nextPage, size: 10);
          
          final allPosts = List<Post>.from(currentState.allPosts)..addAll(newPosts);
          final trendingPosts = _calculateTrending(allPosts);
          final filteredPosts = _applyFilters(allPosts, currentState.activeFilters);
          
          emit(currentState.copyWith(
            posts: filteredPosts,
            allPosts: allPosts,
            trendingPosts: trendingPosts,
            hasReachedMax: newPosts.isEmpty,
            currentPage: nextPage,
          ));
        } catch (e) {
          // Keep current state on error
        }
      }
    });

    on<FeedFilterApplied>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        // We reset pagination and fetch page 0 again to respect pagination instruction.
        emit(FeedLoading());
        try {
          final allPosts = await repository.getPosts(page: 0, size: 10);
          final trendingPosts = _calculateTrending(allPosts);
          final filteredPosts = _applyFilters(allPosts, event.filters);
          
          emit(FeedLoaded(
            posts: filteredPosts,
            allPosts: allPosts,
            trendingPosts: trendingPosts,
            activeFilters: event.filters,
            hasReachedMax: allPosts.length < 10,
            currentPage: 0,
          ));
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });

    on<FeedFilterCleared>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        emit(FeedLoading());
        try {
          final allPosts = await repository.getPosts(page: 0, size: 10);
          final trendingPosts = _calculateTrending(allPosts);
          
          emit(FeedLoaded(
            posts: allPosts,
            allPosts: allPosts,
            trendingPosts: trendingPosts,
            activeFilters: const PostFilters(),
            hasReachedMax: allPosts.length < 10,
            currentPage: 0,
          ));
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });

    on<FeedPostDeleted>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        try {
          await repository.deletePost(event.postId);
          final updatedAllPosts = currentState.allPosts.where((p) => p.id != event.postId).toList();
          final updatedFilteredPosts = currentState.posts.where((p) => p.id != event.postId).toList();
          emit(currentState.copyWith(
            allPosts: updatedAllPosts,
            posts: updatedFilteredPosts,
          ));
        } catch (e) {
          emit(FeedError(e.toString()));
        }
      }
    });

    on<FeedPostLiked>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        // Optimistic UI update
        final allPosts = List<Post>.from(currentState.allPosts);
        final filteredPosts = List<Post>.from(currentState.posts);
        
        final allIndex = allPosts.indexWhere((p) => p.id == event.postId);
        final filteredIndex = filteredPosts.indexWhere((p) => p.id == event.postId);
        
        if (allIndex != -1) {
          final post = allPosts[allIndex];
          final newIsLiked = !post.isLiked;
          final newLikeCount = newIsLiked ? post.likeCount + 1 : post.likeCount - 1;
          
          final updatedPost = post.copyWith(isLiked: newIsLiked, likeCount: newLikeCount);
          allPosts[allIndex] = updatedPost;
          
          if (filteredIndex != -1) {
            filteredPosts[filteredIndex] = updatedPost;
          }
          
          emit(currentState.copyWith(posts: filteredPosts, allPosts: allPosts));

          try {
            await repository.toggleLike(event.postId);
          } catch (e) {
            // Revert on failure
            allPosts[allIndex] = post;
            if (filteredIndex != -1) {
              filteredPosts[filteredIndex] = post;
            }
            emit(currentState.copyWith(posts: filteredPosts, allPosts: allPosts));
          }
        }
      }
    });

    on<FeedPostCommentAdded>((event, emit) async {
      final currentState = state;
      if (currentState is FeedLoaded) {
        final allPosts = List<Post>.from(currentState.allPosts);
        final filteredPosts = List<Post>.from(currentState.posts);
        
        final allIndex = allPosts.indexWhere((p) => p.id == event.postId);
        final filteredIndex = filteredPosts.indexWhere((p) => p.id == event.postId);
        
        if (allIndex != -1) {
          final post = allPosts[allIndex];
          final updatedPost = post.copyWith(commentCount: post.commentCount + 1);
          allPosts[allIndex] = updatedPost;
          
          if (filteredIndex != -1) {
            filteredPosts[filteredIndex] = updatedPost;
          }
          emit(currentState.copyWith(posts: filteredPosts, allPosts: allPosts));
        }
      }
    });
  }

  Future<void> refresh() async {
    add(FeedRefreshed());
  }
  
  List<Post> _calculateTrending(List<Post> posts) {
    // Simple client-side trending algorithm: sort by likeCount + commentCount
    final sorted = List<Post>.from(posts);
    sorted.sort((a, b) {
      final scoreA = a.likeCount + a.commentCount;
      final scoreB = b.likeCount + b.commentCount;
      return scoreB.compareTo(scoreA); // Descending
    });
    // Return top 5 trending posts
    return sorted.take(5).toList();
  }

  List<Post> _applyFilters(List<Post> posts, PostFilters filters) {
    if (filters.isEmpty) return posts;
    
    return posts.where((post) {
      bool matchesTransaction = true;
      if (filters.transactionType != null) {
        matchesTransaction = post.transactionType.toUpperCase() == filters.transactionType?.toUpperCase();
      }
      
      bool matchesLocation = true;
      if (filters.location != null && filters.location!.isNotEmpty) {
        matchesLocation = post.location.toLowerCase().contains(filters.location!.toLowerCase());
      }
      
      return matchesTransaction && matchesLocation;
    }).toList();
  }
}
