import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String imageLink;

  final String title;

  final Function callBack;

  final bool active;

  final double factor;

  const MovieCard(
      {Key? key,
      required this.title,
      required this.imageLink,
      required this.callBack,
      this.factor = 1.0,
      required this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: InkWell(
            onTap: callBack as void Function()?,
            child: SizedBox(
              height: active
                  ? MediaQuery.of(context).size.height / 3 * factor
                  : MediaQuery.of(context).size.height / 4 * factor,
              width: active
                  ? MediaQuery.of(context).size.width / (3 * factor)
                  : MediaQuery.of(context).size.width / (4 * factor),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  imageLink,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/noimage.jpe',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Text(active ? title : '',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ],
    );
  }
}
