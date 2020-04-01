import 'package:deeplinking/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  SignInEvent(this.username, this.password);

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

/// State
abstract class AuthState {
  const AuthState();
}

class NotSignedIn extends AuthState {}

class InProgress extends AuthState {}

class SignedIn extends AuthState {}

/// BloC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository);

  @override
  AuthState get initialState => NotSignedIn();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInEvent) {
      yield* _mapLoginEventToState(event);
    }
  }

  Stream<AuthState> _mapLoginEventToState(SignInEvent event) async* {
    yield InProgress();
    await _authRepository.login(event.username, event.password);
    yield SignedIn();
  }
}
