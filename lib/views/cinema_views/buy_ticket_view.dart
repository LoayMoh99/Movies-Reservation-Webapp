import 'package:flutter/material.dart';
import 'package:movies_webapp/components/calendar_day.dart';
import 'package:movies_webapp/components/cienma_seat.dart';
import 'package:movies_webapp/components/show_time.dart';
import 'package:movies_webapp/widgets/appbar.dart';

import '../../const.dart';

class BuyTicket extends StatefulWidget {
  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - appBarSize.height,
      color: kBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * .9,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const <Widget>[
                    CalendarDay(
                      dayNumber: '9',
                      dayAbbreviation: 'TH',
                    ),
                    CalendarDay(
                      dayNumber: '10',
                      dayAbbreviation: 'FR',
                    ),
                    CalendarDay(
                      dayNumber: '11',
                      dayAbbreviation: 'SA',
                    ),
                    CalendarDay(
                      dayNumber: '12',
                      dayAbbreviation: 'SU',
                      isActive: true,
                    ),
                    CalendarDay(
                      dayNumber: '13',
                      dayAbbreviation: 'MO',
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  ShowTime(
                    time: '11:00',
                    price: 5,
                    isActive: false,
                  ),
                  ShowTime(
                    time: '12:30',
                    price: 10,
                    isActive: true,
                  ),
                  ShowTime(
                    time: '12:30',
                    price: 10,
                    isActive: false,
                  ),
                  ShowTime(
                    time: '12:30',
                    price: 10,
                    isActive: false,
                  ),
                  ShowTime(
                    time: '12:30',
                    price: 10,
                    isActive: false,
                  ),
                ],
              ),
            ),
            Center(
              child: const Icon(
                Icons.tv,
                color: kPimaryColor,
                size: 25.0,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // First Seat Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20),
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20),
                      ),
                    ],
                  ),
                  // Second Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(
                        isReserved: true,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                    ],
                  ),
                  // Third  Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(),
                      CienmaSeat(
                        isReserved: true,
                      ),
                      CienmaSeat(
                        isReserved: true,
                      ),
                    ],
                  ),
                  // 4TH Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(
                        isReserved: true,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                    ],
                  ),
                  // 5TH Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                    ],
                  ),
                  // 6TH Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                    ],
                  ),
                  // final Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20),
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20) * 2,
                      ),
                      CienmaSeat(),
                      CienmaSeat(),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    '30\$',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  decoration: const BoxDecoration(
                      color: kActionColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25.0))),
                  child: const InkWell(
                      child: Text('Pay',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
