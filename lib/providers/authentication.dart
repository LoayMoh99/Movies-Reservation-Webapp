// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_webapp/datamodels/user.dart' as usr;
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

  Future<String> getRole() async {
    return await FireBaseServices().getUserRole();
  }

//get all Users
  List<usr.User> users = [];
  void getAllUsers() async {
    String? currUserId = FirebaseAuth.instance.currentUser.uid ?? null;
    if (currUserId != null) {
      FirebaseFirestore.instance
          .collection('/users')
          .snapshots()
          .listen((data) {
        data.docs.forEach((element) {
          if (element.id != null &&
              checkIfUserExisted(element.id) &&
              element.id != currUserId)
            users.add(usr.User.fromMap(element.id, element.data()));
        });
        notifyListeners();
      });
    }
  }

  bool checkIfUserExisted(String userId) {
    for (usr.User user in users) {
      if (user.id == userId) return false;
    }
    return true;
  }
}

bool get isAuth {
  bool temp = FirebaseAuth.instance.currentUser != null;
  return temp;
}
