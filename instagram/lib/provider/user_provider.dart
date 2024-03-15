import 'package:flutter/Material.dart';
import 'package:instagram/resources/Auth_Method.dart';

import '../Models/user_model.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods = AuthMethods();
//   User get getUser => _user!;
//   Future<void> refreshUser() async {
//     User? user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User? user = await _authMethods.getUserDetails();
    if (user != null) {
      _user = user;
      notifyListeners();
    } else {
      // Handle the case where user data is null
      print('User data is null');
    }
  }
}
