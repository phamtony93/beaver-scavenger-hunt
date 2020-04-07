
class ClueLocation{

  int number;
  double latitude;
  double longitude;
  String clue;
  String solution;

  bool solved = false;
  bool available = false;


  ClueLocation(this.number, this.latitude, this.longitude, this.clue, this.solution);
}