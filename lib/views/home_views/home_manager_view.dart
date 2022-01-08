import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import 'package:movies_webapp/providers/movies_provider.dart';

import '../../widgets/Movie_item.dart';
import '../../widgets/Movie_text_Input.dart';

class ManagerMain extends StatefulWidget {
  const ManagerMain({Key? key}) : super(key: key);

  @override
  _ManagerMainState createState() => _ManagerMainState();
}

void _addNewMovie(BuildContext ctx) {}

void _addInputDrawer(BuildContext ctx, bool edit, int index) {
  showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: MovieInput(_addNewMovie, edit, index),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      });
}

class _ManagerMainState extends State<ManagerMain> {
  /// replace later with provider
  bool loading = true;
  getMoviesList() {
    if (movies.isEmpty) {
      provideMoviesList();
      print('movies: ' + movies.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getMoviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Manager'),
          TextButton(
              onPressed: () {
                //setselectedmovie(movies[index])
                _addInputDrawer(context, false, 0);
              },
              child: Text('Add movie')),
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: movies.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return MovieItem(
                    index,
                    movies[index].title,
                    movies[index].date,
                    TimeOfDay(
                        hour: movies[index].startTime.hour,
                        minute: movies[index].startTime.minute),
                    TimeOfDay(
                        hour: movies[index].endTime.hour,
                        minute: movies[index].endTime.minute),
                    movies[index].posterUrl,
                    movies[index].roomSize);
              },
            ),
          ),
        ],
      ),
    );
  }
}
