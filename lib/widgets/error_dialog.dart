import 'package:flutter/material.dart';

void showErrorDialog(String title, String message, BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(message),
      ),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
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
