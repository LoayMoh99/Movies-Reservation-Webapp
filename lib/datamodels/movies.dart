// Here will be movies model
class Movie {
  final String title;
  final DateTime date; //stored only date
  final DateTime startTime; //stored only time
  final DateTime endTime; //stored only time
  final int roomSize; //20 or 30
  final List<int> screeningRoom; //contains chairs reserved
  final String posterUrl;

  Movie(this.title, this.date, this.startTime, this.endTime, this.roomSize,
      this.screeningRoom, this.posterUrl);

  static Movie fromMap(Map<String, dynamic> data) {
    List<int> scrRoom = [];
    for (int place in data['screeningRoom']) scrRoom.add(place);
    return Movie(
        data['title'],
        DateTime.parse(data['date']),
        DateTime.parse(data['startTime']),
        DateTime.parse(data['endTime']),
        data['roomSize'] as int,
        scrRoom,
        data['posterUrl']);
  }
}
