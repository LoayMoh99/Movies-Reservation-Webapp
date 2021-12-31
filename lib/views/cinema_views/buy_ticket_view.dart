import 'package:flutter/material.dart';
import 'package:movies_webapp/components/cienma_seat.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/appbar.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  TextEditingController creditController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
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

                          //two textfields for name and phone number
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: creditController,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Credit Card Number',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    controller: pinController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Pin Number',
                                      suffixText: 'XXXX',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                onTap: loading || seatsProvider.currentSelactedSeats.isEmpty
                    ? null
                    : () async {
                        //check for credit and pin numbers:
                        if (creditController.text.isEmpty ||
                            pinController.text.isEmpty) {
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all the fields'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        } else if (validateNumbers()) {
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please fill all the fields with Only Numbers'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        } else if (pinController.text.length != 4) {
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pin must be 4 Digits'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

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
                        if (isAdded) {
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tickets picked successfully!!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          locator<NavigationService>().navigateTo(HomeRoute);
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: loading
                          ? Theme.of(context).primaryColorDark
                          : kActionColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0))),
                  child: Text(loading ? 'Buying...' : 'Pay',
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

  bool validateNumbers() {
    RegExp regExp = new RegExp(r'^[0-9]+$');
    return !regExp.hasMatch(creditController.text) ||
        !regExp.hasMatch(pinController.text);
  }
}
