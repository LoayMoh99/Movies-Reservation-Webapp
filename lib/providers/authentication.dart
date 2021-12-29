// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_webapp/services/firebase_services.dart';

class AuthenticationProvider with ChangeNotifier {
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<bool> logIn(
      BuildContext context, String email, String password) async {
    bool loggedIn = await FireBaseServices().login(email, password, context);
    notifyListeners();
    return loggedIn;
  }

  bool get isAuth {
    bool temp = FirebaseAuth.instance.currentUser != null;
    print('Auth: $temp');
    return temp;
  }

  Future<String> getRole() async {
    return await FireBaseServices().getUserRole();
  }
}
