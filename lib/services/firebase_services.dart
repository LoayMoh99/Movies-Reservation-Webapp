import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:universal_html/prefer_universal/html.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase/firebase.dart' as fb;
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

  //get User's role
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

  /// get User's ID
  String getUserID() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  /// get User's movies
  Future<Map<String, List<int>>> getUserMovies() async {
    Map<String, List<int>> moviesIDs = {};
    String id = getUserID();
    print(id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((data) {
      // data['moviesIDs'].forEach((String k, List<int> v) {
      //   moviesIDs[k] = v;
      // });
      print('MoviesIDs ::');
      print(data['moviesIDs'].keys);
      print(data['moviesIDs'].values);
      // List keys = [];
      for (String key in data['moviesIDs'].keys) {
        moviesIDs[key] = [];
        for (int i in data['moviesIDs'][key]) {
          moviesIDs[key]?.add(i);
        }
      }
      // int index = 0;
      // for (var value in data['moviesIDs'].values) {
      //   for (int seat in value) moviesIDs[keys[index++]]?.add(seat);
      // }
      //moviesIDs = {}; //data['moviesIDs'] as Map<String, List<int>>;

      print(moviesIDs);
    });
    return moviesIDs;
  }

  /// ************ ///
  /// Movies Part  ///
  /// ************ ///

  Future<String> uploadImageFile(File image, String imageName) async {
    fb.StorageReference storageRef = fb.storage().ref('images/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri.toString();
  }

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
        await uploadImageFile(photo, "${title + startTime.toString()}")
            .then((photoUrl) async {
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

  /// ************ ///
  /// Tickets Part ///
  /// ************ ///

  // Add tickets
  Future<bool> addTickets(
    String movieID,
    List<int> selectedSeats,
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
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('/users');
      await moviesRef.doc(movieID).get().then((value) async {
        Movie currMovie = Movie.fromMap(movieID, value.data());
        List<int> newScreeningRoom = currMovie.screeningRoom;
        //check if other user picked any of these seats before at the same time:
        for (int seat in selectedSeats) {
          if (newScreeningRoom.contains(seat)) {
            showErrorDialog(
              "Error",
              "Other have already picked this seat before at the same time.",
              context,
            );
            return false;
          }
        }
        newScreeningRoom += selectedSeats;
        await moviesRef.doc(movieID).update({
          'screeningRoom': newScreeningRoom,
        }).then((value) async {
          await getUserMovies().then((moviesIDs) async {
            print('movies :' + moviesIDs.toString());
            Map<String, List<int>> newMoviesIDs = moviesIDs;
            if (moviesIDs.isEmpty) return false;
            //loop on all movies:
            if (moviesIDs.containsKey(movieID)) {
              List<int> newSeats = moviesIDs[movieID] ?? [];
              newSeats += selectedSeats;
              newMoviesIDs[movieID] = newSeats;
            } else {
              newMoviesIDs[movieID] = selectedSeats;
            }
            print('new movies :' + newMoviesIDs.toString());

            await usersRef.doc(getUserID()).update({
              'moviesIDs': newMoviesIDs,
            }).then((value) {
              return true;
            }).catchError((error) {
              print(error);
              showErrorDialog(
                "Error",
                "Ticket has not been picked!! Try again later!",
                context,
              );
              return false;
            });
          }).catchError((error) {
            print(error);
          });
        }).catchError((error) {
          print(error);
          showErrorDialog(
            "Error",
            "Ticket has not been picked!! Try again later!",
            context,
          );
        });
        return false;
      });

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

  // Cancel tickets reservations
  Future<bool> cancelTickets(
    String movieID,
    List<int> selectedSeats,
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
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('/users');
      await moviesRef.doc(movieID).get().then((value) async {
        Movie currMovie = Movie.fromMap(movieID, value.data());
        List<int> newScreeningRoom = currMovie.screeningRoom;
        print('IN Cancel - before:: newScreeningRoom :' +
            newScreeningRoom.toString());
        for (int seat in selectedSeats) {
          newScreeningRoom.remove(seat);
        }
        print('IN Cancel - after:: newScreeningRoom :' +
            newScreeningRoom.toString());
        await moviesRef.doc(movieID).update({
          'screeningRoom': newScreeningRoom,
        }).then((value) async {
          await getUserMovies().then((moviesIDs) async {
            print('IN Cancel: movies :' + moviesIDs.toString());
            Map<String, List<int>> newMoviesIDs = moviesIDs;
            if (moviesIDs.isEmpty) return false;
            //loop on all movies:
            if (moviesIDs.containsKey(movieID)) {
              List<int> newSeats = moviesIDs[movieID] ?? [];
              for (int seat in selectedSeats) {
                newSeats.remove(seat);
              }
              if (newSeats.isEmpty) {
                newMoviesIDs.remove(movieID);
              } else {
                newMoviesIDs[movieID] = newSeats;
              }
            }
            print('IN Cancel: new movies :' + newMoviesIDs.toString());

            await usersRef.doc(getUserID()).update({
              'moviesIDs': newMoviesIDs,
            }).then((value) {
              return true;
            }).catchError((error) {
              print(error);
              showErrorDialog(
                "Error",
                "Ticket has not been picked!! Try again later!",
                context,
              );
              return false;
            });
          }).catchError((error) {
            print(error);
          });
        }).catchError((error) {
          print(error);
          showErrorDialog(
            "Error",
            "Ticket has not been picked!! Try again later!",
            context,
          );
        });
        return false;
      });

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
}
