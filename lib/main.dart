import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/routing/router.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/views/layout_template.dart';
import 'dependencyInjection.dart';

void main() {
  Injector injector = new Injector();
  injector.setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies Reservvation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => LayoutTemplate(
        child: child!,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: HomeRoute,
    );
  }
}
