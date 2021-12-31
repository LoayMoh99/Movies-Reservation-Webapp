import 'package:flutter/material.dart';

void showErrorDialog(String title, String message, BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            ),
          ),
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
