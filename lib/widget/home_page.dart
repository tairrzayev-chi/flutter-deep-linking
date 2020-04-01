import 'package:deeplinking/model/app_routes.dart';
import 'package:deeplinking/repository/auth_repository.dart';
import 'package:deeplinking/widget/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Home page"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _logout(context);
              },
            )
          ],
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) => GestureDetector(
                  child: Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Item #$index")),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailsPage(index.toString())));
                  },
                ),
            itemCount: 50),
      );

  _logout(BuildContext context) async {
    // Repositories should be invoked by BLoCs but that is not critical for
    // our demo app.
    await RepositoryProvider.of<AuthRepository>(context).logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.launcher, (Route<dynamic> route) => false);
  }
}
