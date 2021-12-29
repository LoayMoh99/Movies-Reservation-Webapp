import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import 'package:movies_webapp/services/firebase_services.dart';

class MoviesList extends StatefulWidget {
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  late List<Movie> movies = [];
  bool loading = true;
  getMoviesList() {
    FirebaseFirestore.instance.collection('/movies').snapshots().listen((data) {
      data.docs.forEach((element) {
        print(element.data());

        movies.add(Movie.fromMap(element.data()));
        print(movies.length);
      });
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getMoviesList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: movies.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text('Title: ' + entry.value.title),
                        Text('Roomsize: ' + entry.value.roomSize.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
              /*ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text(movies[index].title),
                    //leading: Image.network(movies[index].posterUrl),
                  );
                },
              ),*/
            ),
    );
    /*FutureBuilder(
      future:
          // FirebaseFirestore.instance
          //     .collection('/movies')
          //     .doc('GShfiU99DzZzHy73VJaw')
          //     .get(), //
          FireBaseServices.getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          //List result = snapshot.data as List;

          //Movie movie = Movie.fromMap(snapshot.data.data());

          return Text('There is a movie!! ');
        } else {
          print(snapshot.hasData);
          return Text('No Movies!');
        }
      },
    );*/
    /*StreamBuilder(
      stream: FirebaseFirestore.instance.collection('/movies').snapshots(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          //List result = snapshot.data as List;

          //Movie movie = Movie.fromMap(snapshot.data.data());

          return Text(
              'There is a movie!! with size ${snapshot.data.documents.length}');
        } else {
          print(snapshot.hasData);
          return Text('No Movies!');
        }
      },
    );*/
  }
}
