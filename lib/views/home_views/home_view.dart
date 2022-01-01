import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/views/home_views/admin_view.dart';
import 'package:movies_webapp/views/movies_views/movies_view.dart';
import 'package:movies_webapp/widgets/shade_loading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    provideMoviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (isAuth) auth.getAllUsers();
    return SingleChildScrollView(
      child: FutureBuilder(
        future: auth.getRole(),
        builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState == ConnectionState.waiting
                ? ShadeLoading()
                : authResultSnapshot.data == "admin"
                    ? AdminView()
                    : authResultSnapshot.data == "customer"
                        ? MoviesView(
                            notGuest: true,
                          )
                        : authResultSnapshot.data == "manager"
                            ? Center(
                                child: Column(
                                  children: [
                                    Text('Manager'),
                                    TextButton(
                                        onPressed: () async {
                                          bool movieAdded =
                                              await FireBaseServices().addMovie(
                                                  'Avengers: Endgame',
                                                  DateTime.now()
                                                      .add(Duration(days: 1)),
                                                  DateTime.now()
                                                      .add(Duration(hours: 6)),
                                                  DateTime.now()
                                                      .add(Duration(hours: 9)),
                                                  20,
                                                  [1, 3, 5, 9, 15, 18],
                                                  null,
                                                  'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
                                                  context);
                                          if (movieAdded) {
                                            // ignore: deprecated_member_use
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Movie added successfully')));
                                          } else {
                                            // ignore: deprecated_member_use
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Movie could not be added')));
                                          }
                                        },
                                        child: Text('Add movie')),
                                  ],
                                ),
                              )
                            : MoviesView(
                                notGuest: false,
                              ), //Guest
      ),
      /*Column(
          children: [
            CinemaRoom(
              numChairs: 20,
            )
          ],
        ),*/
    );
  }
}
