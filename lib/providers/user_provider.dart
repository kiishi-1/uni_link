import 'package:flutter/cupertino.dart';
import 'package:uni_link/models/user.dart';
import 'package:uni_link/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  Future<void> clearUser() async {
     await _authMethods.signOut();
    _user = null;
    notifyListeners();
  }
}