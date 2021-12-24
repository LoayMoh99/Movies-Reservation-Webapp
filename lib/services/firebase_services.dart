// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_webapp/services/Connection.dart';
import 'package:movies_webapp/widgets/error_dialog.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseServices {
  //login with email and password:
  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      bool connection = await Connection().checkInternetConnection();
      if (!connection) {
        showErrorDialog(
          'Error',
          "Connection Error ; Please check your internet connection!",
          context,
        );
        return false;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(
          "Error in Login",
          "User with this email doesn't exist.",
          context,
        );
      } else if (e.code == 'wrong-password') {
        showErrorDialog(
          "Error in Login",
          "Wrong password.",
          context,
        );
      } else if (e.code == "user-disabled") {
        showErrorDialog(
          "Error in Login",
          "User with this email has been disabled.",
          context,
        );
      }
      return false;
    }
  }

  //register with email and password:
  Future<bool> register(
    String userName,
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
    BuildContext context,
  ) async {
    FirebaseApp secondaryApp;
    try {
      bool connection = await Connection().checkInternetConnection();
      if (!connection) {
        showErrorDialog(
          'Error',
          "Connection Error ; Please check your internet connection!",
          context,
        );
        return false;
      }
      if (Firebase.apps.any((element) {
        if (element.name == "temporaryregister") {
          return true;
        }
        return false;
      })) {
        secondaryApp = Firebase.app('temporaryregister');
      } else {
        secondaryApp = await Firebase.initializeApp(
            name: 'temporaryregister', options: Firebase.app().options);
      }
      print(email);
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: secondaryApp)
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseAuth.instanceFor(app: secondaryApp).signOut();

      if (userCredential.user == null) {
        return false;
      }

      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('/users');

      await usersRef.doc(userCredential.user.uid).set({
        'role': role,
        'email': email,
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
      });
      showErrorDialog(
        "Success",
        "User has been registered successfully.",
        context,
      );
      return true;
    } catch (error) {
      print(error);
      showErrorDialog(
        "Error in Register",
        "User with this email already exists.",
        context,
      );
      return false;
    }
  }

  //get role
  Future<String> getUserRole() async {
    String id = FirebaseAuth.instance.currentUser.uid;
    String role = "";
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((data) => role = data['role'])
        .catchError((error) => role = "guest");
    return role;
  }
}
