import 'package:flutter/material.dart';

class ForgetView extends StatefulWidget {
  @override
  _ForgetViewState createState() => _ForgetViewState();
}

class _ForgetViewState extends State<ForgetView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Text('Forget Password Page'),
        ),
      ),
    );
  }
}
