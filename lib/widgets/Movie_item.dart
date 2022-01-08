import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import '../../widgets/Movie_text_Input.dart';

class MovieItem extends StatelessWidget {
  final int idx;
  final String title;
  final String imageURL;
  final int roomsize;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;

  MovieItem(this.idx, this.title, this.date, this.start, this.end,
      this.imageURL, this.roomsize);

  void _addNewMovie(BuildContext ctx) {}

  void addInputDrawer(BuildContext ctx, bool edit, int index) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: MovieInput(_addNewMovie, edit, index),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Null,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageURL,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/icons/noimage.jpe',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: 250,
                      color: Colors.black54,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 26, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          start.format(context).toString() +
                              " - " +
                              end.format(context).toString(),
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_sharp),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(date).toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () =>
                              {addInputDrawer(context, true, idx)}),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
