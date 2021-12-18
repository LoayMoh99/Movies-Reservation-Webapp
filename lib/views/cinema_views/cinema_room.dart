import 'package:flutter/material.dart';
import 'package:movies_webapp/views/cinema_views/cinima_row.dart';

class CinemaRoom extends StatefulWidget {
  final numChairs;

  const CinemaRoom({
    Key? key,
    this.numChairs = 20,
  }) : super(key: key);

  @override
  _CinemaRoomState createState() => _CinemaRoomState();
}

class _CinemaRoomState extends State<CinemaRoom> {
  List<int> selectedChairs = [
    ...List.generate(30 ~/ 2, (index) => (index + 1) * 2),
  ];
  @override
  Widget build(BuildContext context) {
    int numChairs = (this.widget.numChairs ?? 20) == 30 ? 30 : 20;
    // create a grid of chairs
    return Container(
      child: Column(
        children: <Widget>[
          for (int k = 0; k < numChairs; k += 10)
            CinemaRow(
              index: k,
              selectedChairs: selectedChairs,
            ),
        ],
      ),
    );
  }
}
