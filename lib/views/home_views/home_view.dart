import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: auth.getRole(),
        builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : authResultSnapshot.data == "admin"
                    ? Center(
                        child: Text('Admin'),
                      )
                    : authResultSnapshot.data == "customer"
                        ? Center(
                            child: Text('Customer'),
                          )
                        : authResultSnapshot.data == "manager"
                            ? Center(
                                child: Text('Manager'),
                              )
                            : Center(
                                child: Text('Guest'),
                              ),
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
