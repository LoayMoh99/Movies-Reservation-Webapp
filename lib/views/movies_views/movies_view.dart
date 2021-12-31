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
  final bool notGuest;
  MoviesView({Key? key, this.notGuest = true}) : super(key: key);
  @override
  _MoviesViewState createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  bool loading = true;
  getMoviesList() {
    if (movies.isEmpty) {
      provideMoviesList();
      print('movies: ' + movies.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getMoviesList();
    if (widget.notGuest) setCurrUserMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return ShadeLoading();
    else if (movies.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(
            'No Movies Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.notGuest &&
                            currUserMoviesIDs
                                .containsKey(movies[widget.index].id))
                          RedRoundedActionButton(
                              text: 'Cancel TICKET',
                              callback: () {
                                print('cancel reservation!!');
                                setSelectedMovie(movies[widget.index]);
                                seatsProvider.emptySeats();
                                seatsProvider.getReservedSeatsForCancelation();
                                locator<NavigationService>()
                                    .navigateTo(CancelTicketRoute);
                              }),
                        RedRoundedActionButton(
                            text: 'Buy TICKET',
                            callback: !widget.notGuest
                                ? () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          'You are not logged in!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(
                                            'Please Register or Login to be able to buy a ticket!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              locator<NavigationService>()
                                                  .navigateTo(LoginRoute);
                                            },
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Theme.of(context).primaryColor,
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                : () {
                                    print('buy new reservation!!');
                                    setSelectedMovie(movies[widget.index]);
                                    seatsProvider.emptySeats();
                                    locator<NavigationService>()
                                        .navigateTo(BuyTicketRoute);
                                  }),
                      ],
                    ),
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
                              factor: 1.5,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (widget.notGuest &&
                                  currUserMoviesIDs
                                      .containsKey(movies[widget.index].id))
                                RedRoundedActionButton(
                                    text: 'Cancel TICKET',
                                    callback: () {
                                      print('cancel reservation!!');
                                      setSelectedMovie(movies[widget.index]);
                                      seatsProvider.emptySeats();
                                      seatsProvider
                                          .getReservedSeatsForCancelation();
                                      locator<NavigationService>()
                                          .navigateTo(CancelTicketRoute);
                                    }),
                              RedRoundedActionButton(
                                  text: 'Buy TICKET',
                                  callback: !widget.notGuest
                                      ? () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text(
                                                'You are not logged in!',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(
                                                  'Please Register or Login to be able to buy a ticket!',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    locator<NavigationService>()
                                                        .navigateTo(
                                                            RegisterRoute);
                                                  },
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      : () {
                                          print('buy new reservation!!');
                                          setSelectedMovie(
                                              movies[widget.index]);
                                          seatsProvider.emptySeats();
                                          locator<NavigationService>()
                                              .navigateTo(BuyTicketRoute);
                                        }),
                            ],
                          ),
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
