import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/widgets/appbar.dart';
import 'package:provider/provider.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;

  const LayoutTemplate({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, auth),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
