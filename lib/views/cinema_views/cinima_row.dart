import 'package:flutter/material.dart';

class CinemaRow extends StatefulWidget {
  final index;
  final selectedChairs;

  const CinemaRow({Key? key, this.index, this.selectedChairs})
      : super(key: key);

  @override
  _CinemaRowState createState() => _CinemaRowState();
}

class _CinemaRowState extends State<CinemaRow> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        for (int i = widget.index; i < widget.index + 10; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (widget.selectedChairs.contains(i + 1)) {
                    widget.selectedChairs.remove(i + 1);
                  } else {
                    widget.selectedChairs.add(i + 1);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (widget.selectedChairs.contains(i + 1))
                      ? Colors.red
                      : Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                height: 50,
                width: 50,
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
