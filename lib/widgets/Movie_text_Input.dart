import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:movies_webapp/datamodels/movies.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/movies_provider.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class MovieInput extends StatefulWidget {
  final Function addmovie;
  final bool edit;
  final int index;
  MovieInput(this.addmovie, this.edit, this.index);

  @override
  _MovieInputState createState() => _MovieInputState();
}

class _MovieInputState extends State<MovieInput> {
  final titleinputController = new TextEditingController();
  html.File? fromPicker;
  int _roomsize = 20;
  bool exist = false;
  //old values
  String title = '';
  int oldRoomSize = -1;
  int dateDay = -1;
  int dateMonth = -1;
  int dateYear = -1;
  int startHour = -1;
  int startMin = -1;
  int endHour = -1;
  int endMin = -1;

  DateTime _pickedDate = DateTime.now();

  TimeOfDay _timestart = TimeOfDay.now();
  TimeOfDay _timeEnd = TimeOfDay.now();

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
    loading = false;
    if (widget.edit) {
      titleinputController.text = movies[widget.index].title;
      title = movies[widget.index].title;
      _roomsize = movies[widget.index].roomSize;
      oldRoomSize = _roomsize;
      _pickedDate = movies[widget.index].date;
      dateDay = _pickedDate.day;
      dateMonth = _pickedDate.month;
      dateYear = _pickedDate.year;
      _timestart = TimeOfDay(
          hour: movies[widget.index].startTime.hour,
          minute: movies[widget.index].startTime.minute);
      startHour = _timestart.hour;
      startMin = _timestart.minute;
      _timeEnd = TimeOfDay(
          hour: movies[widget.index].endTime.hour,
          minute: movies[widget.index].endTime.minute);
      endHour = _timeEnd.hour;
      endMin = _timeEnd.minute;
    }
    super.initState();
  }

  void _selectTimeStart() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timestart,
    );
    if (newTime != null) {
      setState(() {
        _timestart = newTime;
      });
    }
  }

  void _selectTimeEnd() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeEnd,
    );
    if (newTime != null) {
      setState(() {
        _timeEnd = newTime;
      });
    }
  }

  void _openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023))
        .then((value) {
      if (value == null) return;
      setState(() {
        _pickedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white54,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleinputController,
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "title",
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("20 seats"),
                      leading: Radio(
                        value: 20,
                        groupValue: _roomsize,
                        onChanged: (_) {
                          setState(() {
                            _roomsize = 20;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: Text("30 seats"),
                      leading: Radio(
                        value: 30,
                        groupValue: _roomsize,
                        onChanged: (_) {
                          setState(() {
                            _roomsize = 30;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          _pickedDate == null
                              ? "You didnt choose a date !"
                              : DateFormat.yMEd().format(_pickedDate),
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Quicksand',
                            color: Colors.white,
                          )),
                    ),
                    ElevatedButton(
                      onPressed: _openDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _selectTimeStart,
                child: Text('SELECT STARTING TIME'),
              ),
              SizedBox(height: 8),
              Text(
                'Selected starting time: ${_timestart.format(context)}',
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _selectTimeEnd,
                child: Text('SELECT ENDING TIME'),
              ),
              SizedBox(height: 8),
              Text(
                'Selected ending time: ${_timeEnd.format(context)}',
              ),
              if (!widget.edit)
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: FlatButton(
                    onPressed: () async {
                      fromPicker =
                          (await ImagePickerWeb.getImageAsFile()) as html.File?;
                    },
                    child: Text("Select Image"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.blue,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: FlatButton(
                  onPressed: loading
                      ? null
                      : () async {
                          // for (Movie movie in movies) {
                          //   if (movie.title == titleinputController.text &&
                          //       movie.date == _pickedDate &&
                          //       movie.startTime ==
                          //           DateTime(
                          //               _pickedDate.year,
                          //               _pickedDate.month,
                          //               _pickedDate.day,
                          //               _timestart.hour,
                          //               _timestart.minute) &&
                          //       movie.endTime ==
                          //           DateTime(
                          //               _pickedDate.year,
                          //               _pickedDate.month,
                          //               _pickedDate.day,
                          //               _timeEnd.hour,
                          //               _timeEnd.minute) &&
                          //       movie.roomSize == _roomsize &&
                          //       movie.screeningRoom == []) {
                          //     print(movie.title);
                          //     print(movie.date);
                          //     print(movie.startTime);
                          //     print(movie.endTime);
                          //     print(movie.roomSize);
                          //     print(movie.screeningRoom);
                          //     exist = true;
                          //   }
                          // }
                          DateTime start = DateTime(
                              _pickedDate.year,
                              _pickedDate.month,
                              _pickedDate.day,
                              _timestart.hour,
                              _timestart.minute);
                          DateTime end = DateTime(
                              _pickedDate.year,
                              _pickedDate.month,
                              _pickedDate.day,
                              _timeEnd.hour,
                              _timeEnd.minute);
                          //some validations:
                          if (!widget.edit) {
                            if (titleinputController.text.isEmpty) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text('Can\'t leave title empty!! ')));
                              return;
                            }
                            //the movie must be at least one hour long:
                            if (!(end.hour - start.hour >= 1)) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'End-time must be at least 1 hour greater than start-time')));
                              return;
                            }
                            if (end.isBefore(start)) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'End-time must be after start-time')));
                              return;
                            }
                            if (_pickedDate.day == (DateTime.now().day) &&
                                start.hour == (DateTime.now().hour)) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'The picked date/times can\'t be just now or in the past')));
                              return;
                            }
                            //check if this movie date and start and end times is already reserved for the same room
                            for (Movie movie in movies) {
                              if (_pickedDate.day == movie.date.day &&
                                  _pickedDate.month == movie.date.month &&
                                  _pickedDate.year == movie.date.year) {
                                if ((start.hour >= movie.startTime.hour &&
                                        start.hour <= movie.endTime.hour) ||
                                    (end.hour >= movie.startTime.hour &&
                                        end.hour <= movie.endTime.hour)) {
                                  if (_roomsize == movie.roomSize)
                                    // ignore: deprecated_member_use
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            'The picked date and times with this room size is already reserved')));
                                  return;
                                }
                              }
                            }
                            setState(() {
                              loading = true;
                            });

                            bool movieAdded = await FireBaseServices().addMovie(
                                titleinputController.text,
                                _pickedDate,
                                start,
                                end,
                                _roomsize,
                                [],
                                fromPicker,
                                'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
                                context);
                            if (movieAdded) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Movie added successfully')));
                            } else {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Movie could not be added')));
                            }
                          } else {
                            setState(() {
                              loading = true;
                            });

                            //check if roomsize is updated:
                            if (oldRoomSize != -1 && oldRoomSize > _roomsize) {
                              //room was 30 -> 20
                              print('here');
                              //see if in the picked seats ->seats Num > 20:
                              for (int seatNo
                                  in movies[widget.index].screeningRoom) {
                                if (seatNo > 20) {
                                  // ignore: deprecated_member_use
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'Can\'t change this room size as there are seats above seat number 20!!')));
                                  setState(() {
                                    loading = false;
                                  });
                                  return;
                                }
                              }
                            }
                            //check if no any changed values:
                            /*
                            String title = '';
                            int oldRoomSize = -1;
                            int dateDay = -1;
                            int dateMonth = -1;
                            int dateYear = -1;
                            int startHour = -1;
                            int startMin = -1;
                            int endHour = -1;
                            int endMin = -1;
                            */
                            if (title == titleinputController.text &&
                                oldRoomSize == _roomsize &&
                                dateDay == _pickedDate.day &&
                                dateMonth == _pickedDate.month &&
                                dateYear == _pickedDate.year &&
                                startHour == start.hour &&
                                startMin == start.minute &&
                                endHour == end.hour &&
                                endMin == end.minute) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'No any values have been change to update!!')));
                              setState(() {
                                loading = false;
                              });
                              return;
                            }
                            bool movieAdded = await FireBaseServices()
                                .updateMovie(
                                    movies[widget.index].id,
                                    titleinputController.text,
                                    _pickedDate,
                                    start,
                                    end,
                                    _roomsize,
                                    context);
                            if (movieAdded) {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Movie updated successfully')));
                            } else {
                              // ignore: deprecated_member_use
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Movie could not be updated')));
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                          exist = false;
                          locator<NavigationService>().navigateTo(HomeRoute);
                        },
                  child: widget.edit
                      ? Text(loading ? "Updating" : "Update")
                      : Text(loading ? "Adding" : "Add"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
