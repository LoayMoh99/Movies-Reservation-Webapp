// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import 'package:movies_webapp/services/firebase_services.dart';

late List<Movie> movies = [];
provideMoviesList() {
  print('provideMoviesList');
  FirebaseFirestore.instance.collection('/movies').snapshots().listen((data) {
    movies = [];
    data.docs.forEach((element) {
      // if (checkIfExisted(element.id)) {
      Movie toAdd = Movie.fromMap(element.id, element.data());
      print(DateTime.now().isBefore(toAdd.startTime));
      if (DateTime.now().isBefore(toAdd.startTime)) movies.add(toAdd);
      //}
    });
  });
}

bool checkIfExisted(String movieId) {
  for (Movie movie in movies) {
    if (movie.id == movieId) return false;
  }
  return true;
}

late Movie selectedMovie;
setSelectedMovie(Movie movie) {
  selectedMovie = movie;
}

Map<String, List<int>> currUserMoviesIDs = {};
setCurrUserMovies() async {
  await FireBaseServices().getUserMovies().then((value) {
    currUserMoviesIDs = value;
  });
}

class SeatsProvider with ChangeNotifier {
  List<int> currentSelactedSeats = [];
  bool addToCurrentSelectedSeats(int seat) {
    if (currentSelactedSeats.contains(seat)) return false;
    currentSelactedSeats.add(seat);
    notifyListeners();
    return true;
  }

  removeFromCurrentSelectedSeats(int seat) {
    currentSelactedSeats.remove(seat);
    notifyListeners();
  }

  emptySeats() {
    currentSelactedSeats = [];
    notifyListeners();
  }

  getReservedSeatsForCancelation() async {
    currentSelactedSeats = currUserMoviesIDs[selectedMovie.id] ?? [];
    print('curr selected movies: ' + currUserMoviesIDs.toString());
    print('curr selected seats: ' + currentSelactedSeats.toString());
    notifyListeners();
    await setCurrUserMovies();
  }
}
