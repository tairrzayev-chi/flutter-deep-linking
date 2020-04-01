import 'package:deeplinking/bloc/auth_bloc.dart';
import 'package:deeplinking/model/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  static Widget withBloc() => BlocProvider(
        create: (context) => AuthBloc(context.repository()),
        child: AuthPage(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SignedIn) {
                // Open the app launcher page, which will re-check the current
                // app state and launch the most appropriate widget.
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.launcher, (Route<dynamic> route) => false);
              }
            },
            builder: (context, state) => Center(
                  child: (state is InProgress || state is SignedIn)
                      ? CircularProgressIndicator()
                      : FlatButton(
                          child: Text("Log me in!"),
                          color: Colors.lightBlue,
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(SignInEvent("myUserName", "myPassword"));
                          },
                        ),
                )),
      );
}
