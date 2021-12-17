import 'package:get_it/get_it.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:movies_webapp/services/navigation_service.dart';

GetIt locator = GetIt.instance;

//DI
class Injector {
  //the _singleton is only created once..
  //singleton is created once the app is built
  //while lazy one is created when the Injector is called
  static final Injector _singleton = new Injector._internal();

  //so we used the factory constructor for that purpose not to create
  //another instance when creating another instance of Injector
  //don't forget to finish writing all the {static} objects before the factory constructor..
  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }
}
