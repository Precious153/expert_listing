import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/post_repository.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();
  @override
  List<Object?> get props => [];
}

class CommentsFetched extends CommentsEvent {
  final int postId;
  const CommentsFetched(this.postId);
  @override
  List<Object?> get props => [postId];
}

class CommentAdded extends CommentsEvent {
  final int postId;
  final String content;
  const CommentAdded(this.postId, this.content);
  @override
  List<Object?> get props => [postId, content];
}

abstract class CommentsState extends Equatable {
  const CommentsState();
  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;
  final bool isSubmitting;
  
  const CommentsLoaded(this.comments, {this.isSubmitting = false});
  
  CommentsLoaded copyWith({List<Comment>? comments, bool? isSubmitting}) {
    return CommentsLoaded(
      comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
  
  @override
  List<Object?> get props => [comments, isSubmitting];
}

class CommentsError extends CommentsState {
  final String message;
  const CommentsError(this.message);
  @override
  List<Object?> get props => [message];
}

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository repository;

  CommentsBloc({required this.repository}) : super(CommentsInitial()) {
    on<CommentsFetched>((event, emit) async {
      emit(CommentsLoading());
      try {
        final comments = await repository.getComments(event.postId);
        emit(CommentsLoaded(comments));
      } catch (e) {
        emit(CommentsError(e.toString()));
      }
    });

    on<CommentAdded>((event, emit) async {
      final currentState = state;
      if (currentState is CommentsLoaded) {
        if (currentState.isSubmitting) return; // Prevent duplicate submissions
        
        emit(currentState.copyWith(isSubmitting: true));
        try {
          final newComment = await repository.addComment(event.postId, event.content);
          final updatedComments = List<Comment>.from(currentState.comments)..add(newComment);
          emit(CommentsLoaded(updatedComments, isSubmitting: false));
        } catch (e) {
          emit(currentState.copyWith(isSubmitting: false));
          emit(CommentsError(e.toString()));
        }
      }
    });
  }
}
