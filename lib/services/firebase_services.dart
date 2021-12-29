// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import 'package:path/path.dart' as Path;
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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

  /// ************ ///
  /// Movies Part  ///
  /// ************ ///

  // Add movies
  Future<bool> addMovie(
    String title,
    DateTime date, //stored only date
    DateTime startTime, //stored only time
    DateTime endTime, //stored only time
    int roomSize, //20 or 30
    List<int> screeningRoom, //contains chairs reserved
    File? photo,
    String? photoUrl,
    BuildContext context,
  ) async {
    try {
      bool connection = await Connection().checkInternetConnection();
      if (!connection) {
        showErrorDialog(
          "Network Error",
          "Check Internet Connection",
          context,
        );
        return false;
      }

      final CollectionReference moviesRef =
          FirebaseFirestore.instance.collection('/movies');
      if (photo != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(photo.path)}');

        await ref.putFile(photo).whenComplete(() async {
          await ref.getDownloadURL().then((photoUrl) async {
            await moviesRef.add({
              'title': title,
              'date': date.toString(),
              'startTime': startTime.toString(),
              'endTime': endTime.toString(),
              'roomSize': roomSize,
              'screeningRoom': screeningRoom,
              'posterUrl': photoUrl
            }).then((value) {
              showErrorDialog(
                "Success",
                "Movie has been added successfully.",
                context,
              );
              return true;
            }).catchError((error) {
              print(error);
              showErrorDialog(
                "Error",
                "Movie has not been added. Try again later!",
                context,
              );
              return false;
            });
          });
        });
      } else {
        await moviesRef.add({
          'title': title,
          'date': date.toString(),
          'startTime': startTime.toString(),
          'endTime': endTime.toString(),
          'roomSize': roomSize,
          'screeningRoom': screeningRoom,
          'posterUrl': photoUrl != null
              ? photoUrl
              : 'https://i.picsum.photos/id/111/4400/2656.jpg?hmac=leq8lj40D6cqFq5M_NLXkMYtV-30TtOOnzklhjPaAAQ'
        }).then((value) {
          showErrorDialog(
            "Success",
            "Movie has been added successfully.",
            context,
          );
          return true;
        }).catchError((error) {
          print(error);
          showErrorDialog(
            "Error",
            "Movie has not been added. Try again later!",
            context,
          );
          return false;
        });
      }
      return true;
    } catch (error) {
      print(error);
      showErrorDialog(
        "Error",
        "An error occurs , try again later!",
        context,
      );
      return false;
    }
  }

  //get movies
  static Future<List<Movie>> getMovies() async {
    print('Got called');
    List<Movie> movies = [];
    // await FirebaseFirestore.instance
    //     .collection('/movies')
    //     .doc('GShfiU99DzZzHy73VJaw')
    //     .get()
    //     .then((data) {
    //   movies.add(Movie.fromMap(data.data()));
    //   print(movies);
    //   print('hereeeeeee');
    // });
    FirebaseFirestore.instance.collection('/movies').snapshots().listen((data) {
      data.docs.forEach((element) {
        print('add movie');
        movies.add(Movie.fromMap(element.data()));
      });
    });
    // await FirebaseFirestore.instance.collection('/movies').get().then((data) {
    //   data.docs.forEach((element) {
    //     movies.add(Movie.fromMap(element.data()));
    //   });
    // });
    // final listToStore =
    //     (await FirebaseFirestore.instance.collection('/movies').get()).docs;
    // print('list ');
    // print(listToStore);
    // listToStore.forEach((element) {
    //   movies.add(Movie.fromMap(element.data()));
    // });
    // Movie dummy = Movie(
    //     'title',
    //     DateTime.now(),
    //     DateTime.now(),
    //     DateTime.now().add(Duration(hours: 2)),
    //     20,
    //     [1, 5, 9],
    //     'https://i.picsum.photos/id/111/4400/2656.jpg?hmac=leq8lj40D6cqFq5M_NLXkMYtV-30TtOOnzklhjPaAAQ');
    // movies.add(dummy);
    // print(movies[0].title);
    return movies;
  }
}
