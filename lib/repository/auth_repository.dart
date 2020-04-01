import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}

class FakeAuthRepository extends AuthRepository {
  static const _isLoggedInKey = "isLoggedInKey";

  login(String username, String password) async {
    // Simulate network latency
    await Future.delayed(Duration(milliseconds: 500), null);
    (await preferences()).setBool(_isLoggedInKey, true);
  }

  Future<bool> isLoggedIn() async {
    return (await preferences()).getBool(_isLoggedInKey) ?? false;
  }

  logout() async {
    (await preferences()).remove(_isLoggedInKey);
  }

  Future<SharedPreferences> preferences() => SharedPreferences.getInstance();
}
