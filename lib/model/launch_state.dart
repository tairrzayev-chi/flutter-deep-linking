import 'package:equatable/equatable.dart';

import 'app_route.dart';

abstract class LaunchState extends Equatable {
  const LaunchState();

  @override
  List<Object> get props => [];
}

class AuthenticatedState extends LaunchState {
  // The route to open when the user is authenticated
  final AppRoute route;

  const AuthenticatedState(this.route);

  @override
  List<Object> get props => [route];
}

class NotAuthenticatedState extends LaunchState {}

class IsLoadingState extends LaunchState {}
