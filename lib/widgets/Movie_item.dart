import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MovieItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;
  final int duration;

  // void goToselectMeal(BuildContext ctx) {
  //   Navigator.of(ctx).pushNamed(MealDetailsScreen.routeName, arguments: id);
  // }

  MovieItem(this.id, this.title, this.duration, this.imageURL);

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
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                        width: 1,
                      ),
                      Text(
                        '$duration hrs',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        width: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(
                        width: 1,
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
