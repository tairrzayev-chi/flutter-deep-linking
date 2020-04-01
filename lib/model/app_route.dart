import 'package:equatable/equatable.dart';

abstract class AppRoute extends Equatable {}

// Opened if there is no deep link passed to the app.
class HomeRoute extends AppRoute {
  @override
  List<Object> get props => [];
}

class DetailsRoute extends AppRoute {
  final String itemId;

  DetailsRoute(this.itemId);

  @override
  List<Object> get props => [itemId];
}
