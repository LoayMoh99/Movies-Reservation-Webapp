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
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        content: Text(
            'You will be missing a lot of the Features that Authenticated users have 💔 '),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
            child: Text('Fine'),
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
                  Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ),
        ],
      );
    },
  );
}
