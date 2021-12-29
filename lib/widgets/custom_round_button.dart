import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final Size size;
  final Function()? onPress;
  final String text;
  final bool colorDefault;

  const CustomRoundButton(
      {required this.size,
      this.onPress,
      required this.text,
      this.colorDefault = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: onPress ?? () {},
        color: colorDefault ? Theme.of(context).primaryColor : Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color:
                  colorDefault ? Colors.white : Theme.of(context).primaryColor,
              fontSize: size.width > 600 ? 36 : 24,
            ),
          ),
        ),
      ),
    );
  }
}
