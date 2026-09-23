import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/api_exceptions.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class ProfileFetched extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final User user;
  const ProfileLoaded(this.user);
  @override
  List<Object?> get props => [user];
}
class ProfileUnauthenticated extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc({required this.authRepository}) : super(ProfileInitial()) {
    on<ProfileFetched>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await authRepository.getCurrentUser();
        emit(ProfileLoaded(user));
      } on UnauthorizedException {
        emit(ProfileUnauthenticated());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
