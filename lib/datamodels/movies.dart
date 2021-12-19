// Here will be movies model
class Movies {
  final String title;
  final DateTime date; //stored only date
  final DateTime startTime; //stored only time
  final DateTime endTime; //stored only time
  final int roomSize; //20 or 30
  final List<int> screeningRoom; //contains chairs reserved
  final String posterUrl;

  Movies(this.title, this.date, this.startTime, this.endTime, this.roomSize,
      this.screeningRoom, this.posterUrl);
}
