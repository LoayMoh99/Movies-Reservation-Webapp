import 'package:flutter/material.dart';
import 'package:movies_webapp/components/cienma_seat.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/appbar.dart';
import 'package:movies_webapp/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../const.dart';

class BuyTicket extends StatefulWidget {
  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  getTheSeats({int roomSize = 20, required SeatsProvider seatsProvider}) {
    List<Widget> seats = [];
    for (int i = 0; i < roomSize; i += 5) {
      List<Widget> rowSeats = [];
      for (int j = 0; j < 5; j++) {
        rowSeats.add(CinemaSeat(
          seatNum: i + j + 1,
          isSelected: seatsProvider.currentSelactedSeats.contains(i + j + 1),
          isReserved: selectedMovie.screeningRoom.contains(i + j + 1),
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
                  setState(() {
                    loading = true;
                  });
                  bool isAdded = await FireBaseServices().addTickets(
                    selectedMovie.id,
                    seatsProvider.currentSelactedSeats,
                    context,
                  );

                  setState(() {
                    loading = false;
                  });
                  print(isAdded);
                  if (isAdded) {
                    // ignore: deprecated_member_use
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Tickets picked successfully!!')));
                    locator<NavigationService>().navigateTo(HomeRoute);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  decoration: const BoxDecoration(
                      color: kActionColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0))),
                  child: Text('Pay',
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
