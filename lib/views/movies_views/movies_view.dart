import 'package:flutter/material.dart';
import 'package:movies_webapp/components/background_gradient_image.dart';
import 'package:movies_webapp/components/dark_borderless_button.dart';
import 'package:movies_webapp/components/movie_card.dart';
import 'package:movies_webapp/components/primary_rounder_button.dart';
import 'package:movies_webapp/components/red_rounded_action_button.dart';
import 'package:movies_webapp/const.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/appbar.dart';
import 'package:movies_webapp/widgets/shade_loading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../../dependencyInjection.dart';

// ignore: must_be_immutable
class MoviesView extends StatefulWidget {
  int index = 1;

  MoviesView({Key? key}) : super(key: key);
  @override
  _MoviesViewState createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  bool loading = true;
  getMoviesList() {
    if (movies.isEmpty) {
      provideMoviesList();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getMoviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return ShadeLoading();
    else {
      SeatsProvider seatsProvider =
          Provider.of<SeatsProvider>(context, listen: false);
      final String backgroundImage = movies[widget.index].posterUrl;
      final String available = (movies[widget.index].roomSize -
              movies[widget.index].screeningRoom.length)
          .toString();
      final String totalRoomSize = movies[widget.index].roomSize.toString();
      if (MediaQuery.of(context).size.width < 600) {
        return Container(
          height: MediaQuery.of(context).size.height - appBarSize.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              BackgroundGradientImage(
                image: Image.network(
                  backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/noimage.jpe',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Text(
                      movies[widget.index].title,
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0)),
                    DarkBorderlessTag(
                      text: movies[widget.index].date.day.toString() +
                          '/' +
                          movies[widget.index].date.month.toString() +
                          '/' +
                          movies[widget.index].date.year.toString() +
                          ' from ' +
                          movies[widget.index].startTime.hour.toString() +
                          ' to ' +
                          movies[widget.index].endTime.hour.toString(),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        DarkBorderlessTag(
                          text: 'Available Seats',
                        ),
                        PrimaryRoundedTag(
                          text: available,
                          text2: totalRoomSize,
                        ),
                      ],
                    ),
                    Divider(),
                    RedRoundedActionButton(
                        text: 'BUY TICKET',
                        callback: () {
                          setSelectedMovie(movies[widget.index]);
                          seatsProvider.emptySeats();
                          locator<NavigationService>()
                              .navigateTo(BuyTicketRoute);
                        }),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: MovieCard(
                                    title: movies[index].title,
                                    imageLink: movies[index].posterUrl,
                                    active:
                                        index == widget.index ? true : false,
                                    callBack: () {
                                      setState(() {
                                        widget.index = index;
                                      });
                                    }),
                              );
                            })),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        //laptop and tablet UI:
        return Container(
          height: MediaQuery.of(context).size.height - appBarSize.height,
          color: kBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: MovieCard(
                              title: movies[index].title,
                              imageLink: movies[index].posterUrl,
                              active: index == widget.index ? true : false,
                              factor: 2,
                              callBack: () {
                                setState(() {
                                  widget.index = index;
                                });
                              }),
                        );
                      }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    BackgroundGradientImage(
                      image: Image.network(
                        backgroundImage,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/icons/noimage.jpe',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          Text(
                            movies[widget.index].title,
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DarkBorderlessTag(
                                text: 'Available Seats',
                              ),
                              PrimaryRoundedTag(
                                text: available,
                                text2: totalRoomSize,
                              ),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          DarkBorderlessTag(
                            text: movies[widget.index].date.day.toString() +
                                '/' +
                                movies[widget.index].date.month.toString() +
                                '/' +
                                movies[widget.index].date.year.toString() +
                                ' from ' +
                                movies[widget.index].startTime.hour.toString() +
                                ' to ' +
                                movies[widget.index].endTime.hour.toString(),
                          ),
                          Divider(),
                          RedRoundedActionButton(
                              text: 'BUY TICKET',
                              callback: () {
                                print(movies[widget.index].title);
                                locator<NavigationService>()
                                    .navigateTo(BuyTicketRoute);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
