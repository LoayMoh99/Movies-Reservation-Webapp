// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/routing/router.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/views/layout_template.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'dependencyInjection.dart';

Future<void> main() async {
  //for dependency injection (navigation service)
  Injector injector = new Injector();
  injector.setupLocator();
  //for firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthenticationProvider(),
        ),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (ctx, auth, _) => GetMaterialApp(
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
          initialRoute: LoginRoute,
        ),
      ),
    );
  }
}
