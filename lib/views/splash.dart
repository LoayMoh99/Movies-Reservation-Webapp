import 'package:flutter/material.dart';
import 'package:movies_webapp/widgets/logo_widget.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          LogoWidget(
            height: 200,
            width: 200,
          ),
        ],
      ),
    );
  }
}
