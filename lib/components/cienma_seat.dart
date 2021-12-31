import 'package:flutter/material.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../const.dart';

// ignore: must_be_immutable
class CinemaSeat extends StatefulWidget {
  int seatNum;
  bool isReserved;

  bool isSelected;
  bool cancelCase;

  CinemaSeat(
      {Key? key,
      required this.seatNum,
      this.isSelected = false,
      this.cancelCase = false,
      this.isReserved = false})
      : super(key: key);

  @override
  _CinemaSeatState createState() => _CinemaSeatState();
}

class _CinemaSeatState extends State<CinemaSeat> {
  @override
  Widget build(BuildContext context) {
    SeatsProvider seatsProvider =
        Provider.of<SeatsProvider>(context, listen: false);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.cancelCase
          ? null
          : () {
              // ignore: unnecessary_statements
              if (!widget.isReserved) widget.isSelected = !widget.isSelected;

              if (!widget.isReserved && widget.isSelected) {
                if (!seatsProvider.addToCurrentSelectedSeats(widget.seatNum)) {
                  widget.isSelected = !widget.isSelected;
                }
              }
              if (!widget.isReserved && !widget.isSelected) {
                seatsProvider.removeFromCurrentSelectedSeats(widget.seatNum);
              }
              print("isReserved - " + widget.isReserved.toString());
              print("isSelected - " + widget.isSelected.toString());
              print((seatsProvider.currentSelactedSeats).toString());
            },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          width: MediaQuery.of(context).size.width / 15,
          height: MediaQuery.of(context).size.width / 15,
          decoration: BoxDecoration(
              color: widget.isSelected
                  ? kPimaryColor
                  : widget.isReserved
                      ? Colors.white
                      : null,
              border: !widget.isSelected && !widget.isReserved
                  ? Border.all(color: Colors.white, width: 1.0)
                  : null,
              borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
