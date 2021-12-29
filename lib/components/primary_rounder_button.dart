import 'package:flutter/material.dart';

import '../const.dart';

class PrimaryRoundedTag extends StatelessWidget {
  final double margin;

  final String text;
  final String text2;

  const PrimaryRoundedTag(
      {Key? key, required this.text, required this.text2, this.margin = 10})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: kPimaryColor, borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: <Widget>[
            Text(text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('/$text2',
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ));
  }
}
