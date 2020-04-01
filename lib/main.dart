import 'package:deeplinking/repository/auth_repository.dart';
import 'package:deeplinking/widget/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(RepositoryProvider<AuthRepository>(
    create: (context) => FakeAuthRepository(),
    child: AppLauncher.withBloc(),
  ));
}
