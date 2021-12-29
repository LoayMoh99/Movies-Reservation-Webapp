import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const LogoWidget({Key? key, this.height = 100, this.width = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Center(
            child: Image.asset('assets/icons/logo.jpe'),
          ),
        ),
      ),
    );
  }
}
