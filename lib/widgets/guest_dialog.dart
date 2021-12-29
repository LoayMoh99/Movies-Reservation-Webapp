import 'package:flutter/material.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/navigation_service.dart';

import '../dependencyInjection.dart';

void dialogGuest(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Text(
          'Login as Guest',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'You will be missing a lot of the Features that Authenticated users have 💔 ',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColorDark,
              ),
            ),
            child: Text(
              'Fine',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              locator<NavigationService>().navigateTo(HomeRoute);
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColorDark,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
