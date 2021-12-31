import 'package:flutter/material.dart';
import 'package:movies_webapp/components/cienma_seat.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/appbar.dart';
import 'package:movies_webapp/widgets/error_dialog.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import '../../const.dart';

class CancelTicket extends StatefulWidget {
  @override
  _CancelTicketState createState() => _CancelTicketState();
}

class _CancelTicketState extends State<CancelTicket> {
  getTheSeats({int roomSize = 20, required SeatsProvider seatsProvider}) {
    List<Widget> seats = [];
    for (int i = 0; i < roomSize; i += 5) {
      List<Widget> rowSeats = [];
      for (int j = 0; j < 5; j++) {
        rowSeats.add(CinemaSeat(
          seatNum: i + j + 1,
          isSelected: seatsProvider.currentSelactedSeats.contains(i + j + 1),
          isReserved: !seatsProvider.currentSelactedSeats.contains(i + j + 1) &&
              selectedMovie.screeningRoom.contains(i + j + 1),
          cancelCase: !seatsProvider.currentSelactedSeats.contains(i + j + 1),
        ));
      }
      seats.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowSeats,
      ));
    }
    return seats;
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    SeatsProvider seatsProvider = Provider.of<SeatsProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height - appBarSize.height,
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: loading
                    ? Center(
                        child: LinearProgressIndicator(
                        color: Colors.white,
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: const Icon(
                                Icons.tv,
                                color: kPimaryColor,
                                size: 35.0,
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: getTheSeats(
                                        seatsProvider: seatsProvider,
                                        roomSize: selectedMovie.roomSize))),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  '${(seatsProvider.currentSelactedSeats.length * 10).toString()}\$',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (seatsProvider.currentSelactedSeats.isEmpty) {
                    showErrorDialog(
                      'Error in canceling!',
                      'No selected seats (tickets) to cancel it',
                      context,
                    );
                  } else if (selectedMovie.date.day ==
                          DateTime.now()
                              .day && // TODO: compare the day more accuratly
                      selectedMovie.startTime.hour < DateTime.now().hour + 3) {
                    showErrorDialog(
                      'Error in canceling!',
                      'Time to cancel tickets is over!',
                      context,
                    );
                  } else {
                    print('canceling!!!!!!!!');
                    print(seatsProvider.currentSelactedSeats);
                    setState(() {
                      loading = true;
                    });

                    bool isCanceled = await FireBaseServices().cancelTickets(
                      selectedMovie.id,
                      seatsProvider.currentSelactedSeats,
                      context,
                    );

                    setState(() {
                      loading = false;
                    });
                    if (isCanceled) {
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tickets cancelled successfully!!'),
                        ),
                      );
                      locator<NavigationService>().navigateTo(HomeRoute);
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  decoration: const BoxDecoration(
                      color: kActionColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0))),
                  child: Text('Cancel Tickets',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
