class Challenge{

  int number;
  bool completed;
  String description;
  String photoUrl;

  bool confirmed = false;
  bool checked = false;


  Challenge(this.number, this.completed, this.description, this.photoUrl);

  Challenge.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        completed = json['completed'],
        description = json['description'],
        photoUrl = json['photoUrl'],
        confirmed = json['confirmed'],
        checked = json['checked'];
  
  Map<String, dynamic> toJson() =>
  {
    'number': this.number,
    'completed': this.completed, 
    'description': this.description,
    'photoUrl': this.photoUrl,
    'confirmed': this.confirmed,
    'checked': this.checked
  };

}