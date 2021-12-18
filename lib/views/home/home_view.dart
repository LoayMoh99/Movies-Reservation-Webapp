import 'package:flutter/material.dart';
import 'package:movies_webapp/views/cinema_views/cinema_room.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CinemaRoom(
            numChairs: 30,
          )
        ],
      ),
    );
  }
}
