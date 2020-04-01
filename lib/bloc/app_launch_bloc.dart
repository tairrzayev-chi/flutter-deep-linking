import 'package:deeplinking/model/app_route.dart';
import 'package:deeplinking/model/launch_state.dart';
import 'package:deeplinking/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';

/// Events
abstract class AppLaunchEvent extends Equatable {
  const AppLaunchEvent();
}

class CheckLoginStatus extends AppLaunchEvent {
  final Uri deepLink;

  const CheckLoginStatus(this.deepLink);

  @override
  List<Object> get props => [deepLink];
}

class RefreshLoginStatus extends AppLaunchEvent {
  @override
  List<Object> get props => [];
}

/// State
class AppLaunchState extends Equatable {
  // The deep link is kept around until it can be used (user is authenticated).
  final Optional<Uri> deepLink;
  final LaunchState launchState;

  AppLaunchState(this.deepLink, this.launchState);

  AppLaunchState copyWith({Optional<Uri> deepLink, LaunchState state}) =>
      AppLaunchState(
        deepLink ?? this.deepLink,
        state ?? this.launchState,
      );

  @override
  List<Object> get props => [deepLink, launchState];
}

/// BloC
class AppLaunchBloc extends Bloc<AppLaunchEvent, AppLaunchState> {
  final AuthRepository authRepository;

  AppLaunchBloc(this.authRepository);

  @override
  AppLaunchState get initialState =>
      AppLaunchState(Optional.absent(), IsLoadingState());

  @override
  Stream<AppLaunchState> mapEventToState(AppLaunchEvent event) async* {
    if (event is CheckLoginStatus) {
      yield* _mapCheckLoginStatusToState(event);
    } else if (event is RefreshLoginStatus) {
      yield* _mapRefreshLoginStatusToState(event);
    }
  }

  Stream<AppLaunchState> _mapCheckLoginStatusToState(
      CheckLoginStatus event) async* {
    // Save the deep link into state and keep it around until we can use it.
    yield state.copyWith(
        deepLink: Optional.fromNullable(event.deepLink),
        state: IsLoadingState());
    // Refresh the launch state, which will emit the appropriate AppLaunchState.
    yield* _refreshLaunchState();
  }

  Stream<AppLaunchState> _mapRefreshLoginStatusToState(
      RefreshLoginStatus event) async* {
    yield state.copyWith(state: IsLoadingState());
    yield* _refreshLaunchState();
  }

  Stream<AppLaunchState> _refreshLaunchState() async* {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      // User is logged in - parse the deep link & emit the appropriate state.
      final route = _getRoute(state.deepLink);
      yield state.copyWith(
          deepLink: Optional.absent(), state: AuthenticatedState(route));
    } else {
      // User is not logged in - do not clear the deep link from the state (we
      // will use it after user is logged in) and emit the NotAuthenticatedState.
      yield state.copyWith(state: NotAuthenticatedState());
    }
  }

  /// Parse the deep link into the corresponding [AppRoute] object.
  AppRoute _getRoute(Optional<Uri> deepLink) {
    if (deepLink.isEmpty) {
      return HomeRoute();
    }

    final uri = deepLink.first;
    if (uri.path == "/details") {
      final id = uri.queryParameters["id"];
      // Make sure the ID is in place to be more robust against invalid deep links.
      if (id != null) {
        return DetailsRoute(id);
      }
    }

    // Default to the home route.
    return HomeRoute();
  }
}
