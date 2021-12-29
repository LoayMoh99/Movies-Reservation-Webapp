import 'package:flutter/material.dart';

import '../const.dart';

class DarkBorderlessTag extends StatelessWidget {
  const DarkBorderlessTag({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(15.0)),
      child: Text(text, style: kMainTextStyle),
    );
  }
}
