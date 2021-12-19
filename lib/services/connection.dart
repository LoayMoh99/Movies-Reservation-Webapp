// ignore: import_of_legacy_library_into_null_safe
import 'package:connectivity/connectivity.dart';

class Connection {
  Future<bool> checkInternetConnection() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }
}
