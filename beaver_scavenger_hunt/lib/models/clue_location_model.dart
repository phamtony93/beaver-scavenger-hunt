class ClueLocation{

  int number;
  double latitude;
  double longitude;
  String clue;
  String solution;
  bool found = false;
  bool solved = false;
  bool available = false;


  ClueLocation(this.number, this.latitude, this.longitude, this.clue, this.solution);

  ClueLocation.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        clue = json['clue'],
        solution = json['solution'],
        found = json['found'],
        solved = json['solved'],
        available = json['available'];
  
  Map<String, dynamic> toJson() =>
  {
    'number': this.number,
    'latitude': this.latitude, 
    'longitude': this.longitude,
    'clue': this.clue,
    'solution': this.solution,
    'found': this.found,
    'solved': this.solved,
    'available': this.available
  };

}