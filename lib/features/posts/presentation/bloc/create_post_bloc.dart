import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/create_post_request.dart';
import '../../domain/repositories/post_repository.dart';

// Events
abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object?> get props => [];
}

class CreatePostSubmitted extends CreatePostEvent {
  final CreatePostRequest request;
  final File? image;
  const CreatePostSubmitted(this.request, {this.image});

  @override
  List<Object?> get props => [request, image];
}

// States
abstract class CreatePostState extends Equatable {
  const CreatePostState();
  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}
class CreatePostSubmitting extends CreatePostState {}
class CreatePostSuccess extends CreatePostState {}
class CreatePostFailure extends CreatePostState {
  final String error;
  const CreatePostFailure(this.error);
  
  @override
  List<Object?> get props => [error];
}

// Bloc
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository repository;

  CreatePostBloc({required this.repository}) : super(CreatePostInitial()) {
    on<CreatePostSubmitted>((event, emit) async {
      emit(CreatePostSubmitting());
      try {
        String finalImageUrl = event.request.imageUrl;
        if (event.image != null) {
          finalImageUrl = await repository.uploadImage(event.image!);
        }

        final finalRequest = CreatePostRequest(
          content: event.request.content,
          location: event.request.location,
          transactionType: event.request.transactionType,
          imageUrl: finalImageUrl,
        );

        await repository.createPost(finalRequest);
        emit(CreatePostSuccess());
      } catch (e) {
        emit(CreatePostFailure(e.toString()));
      }
    });
  }
}
