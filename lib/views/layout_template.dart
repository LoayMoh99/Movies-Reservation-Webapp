import 'package:flutter/material.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/navigation_service.dart';

import '../dependencyInjection.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;

  const LayoutTemplate({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Movies Reservations App')),
        actions: [
          // about button
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              locator<NavigationService>().navigateTo(AboutRoute);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
