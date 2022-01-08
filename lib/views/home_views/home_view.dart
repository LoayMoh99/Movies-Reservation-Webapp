import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/views/home_views/admin_view.dart';
import 'package:movies_webapp/views/home_views/home_manager_view.dart';
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
                            ? ManagerMain()
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
