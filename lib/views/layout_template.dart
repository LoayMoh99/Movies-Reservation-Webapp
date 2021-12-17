import 'package:flutter/material.dart';

import 'headers/header.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;

  const LayoutTemplate({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Header(),
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
