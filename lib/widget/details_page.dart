import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage(this.id);

  final String id;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Details page"),
        ),
        body: Center(
          child: Text("This is details page for item $id"),
        ),
      );
}
