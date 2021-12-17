import 'dart:io';

import 'package:movies_webapp/services/Connection.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FireBaseServices {
  //example for login with email and password structure
  Future<bool> login(
      String email, String password, BuildContext context) async {
    bool connection = await Connection().checkInternetConnection();
    if (!connection) {
      //show dilaog for error
      return false;
    }

    //do the loginning functionality
    return true;
  }
}
