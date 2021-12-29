import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/navigation_service.dart';

import '../dependencyInjection.dart';

AppBar? getAppBar(BuildContext context, AuthenticationProvider auth) {
  final appbar = AppBar(
    title: Center(child: Text('Ticketaty')),
    actions: [
      // about button
      IconButton(
        //tooltip: 'About',
        icon: Icon(Icons.info),
        onPressed: () {
          locator<NavigationService>().navigateTo(AboutRoute);
        },
      ),
      //logout button
      IconButton(
        //tooltip: 'Logout',
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          auth.signOut(context);
          locator<NavigationService>().navigateTo(LoginRoute);
        },
      ),
    ],
  );
  setSizeAppbar(appbar);
  return appbar;
}

Size appBarSize = Size.fromHeight(50);

void setSizeAppbar(AppBar appbar) {
  appBarSize = appbar.preferredSize;
}
