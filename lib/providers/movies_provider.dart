// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_webapp/datamodels/movies.dart';

late List<Movie> movies = [];
provideMoviesList() {
  movies = [];
  FirebaseFirestore.instance.collection('/movies').snapshots().listen((data) {
    data.docs.forEach((element) {
      if (checkIfExisted(element.id))
        movies.add(Movie.fromMap(element.id, element.data()));
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
}