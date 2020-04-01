import 'package:deeplinking/bloc/app_launch_bloc.dart';
import 'package:deeplinking/model/app_route.dart';
import 'package:deeplinking/model/app_routes.dart';
import 'package:deeplinking/model/launch_state.dart';
import 'package:deeplinking/widget/auth_page.dart';
import 'package:deeplinking/widget/details_page.dart';
import 'package:deeplinking/widget/home_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLauncher extends StatefulWidget {
  @override
  State createState() => AppLauncherState();

  static Widget withBloc() => BlocProvider(
        create: (context) => AppLaunchBloc(context.repository()),
        child: AppLauncher(),
      );
}

class AppLauncherState extends State<AppLauncher> {
  final _navKey = GlobalKey<NavigatorState>();
  AppLaunchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.bloc();
    _initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<AppLaunchBloc, AppLaunchState>(
        listener: (context, state) {
          // We cannot use Navigator.of(context) because the MaterialApp is a child
          // of this BlocListener, hence is below it in the widget hierarchy.
          // _navKey to the rescue!
          final navigatorState = _navKey.currentState;

          final launchState = state.launchState;
          if (launchState is AuthenticatedState) {
            final route = launchState.route;
            if (route is HomeRoute) {
              navigatorState.pushReplacementNamed(AppRoutes.home);
            } else if (route is DetailsRoute) {
              // Replace the current route with HomePage and push the DetailsPage
              // on top of that.
              navigatorState.pushReplacementNamed(AppRoutes.home);
              navigatorState.push(MaterialPageRoute(
                  builder: (context) => DetailsPage(route.itemId)));
            }
          } else if (launchState is NotAuthenticatedState) {
            navigatorState.pushReplacementNamed(AppRoutes.login);
          }
        },
        child: _buildApp(context),
      );

  Widget _buildApp(BuildContext context) => MaterialApp(
        navigatorKey: _navKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: <String, WidgetBuilder>{
          // Launched for the first time, on a cold app launch.
          AppRoutes.root: (context) => Container(),
          // Launched by the app (e.g. after the deep link was clicked) or to
          // re-route to the deep link after the user had logged in.
          AppRoutes.launcher: (context) {
            _bloc.add(RefreshLoginStatus());
            return Container();
          },
          AppRoutes.home: (context) => HomePage(),
          AppRoutes.login: (context) => AuthPage.withBloc(),
        },
      );

  void _initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    // Link was opened while the app was not open.
    _bloc.add(CheckLoginStatus(deepLink));

    // Listen for deep links, opened while the app is running.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        // Link was opened while the app was open.
        _bloc.add(CheckLoginStatus(deepLink));
      }
    }, onError: (OnLinkErrorException e) async {
      debugPrint("Dynamic link error $e");
    });
  }
}
