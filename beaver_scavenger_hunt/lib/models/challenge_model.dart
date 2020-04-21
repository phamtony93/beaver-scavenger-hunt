class Challenge{

  int number;
  bool completed;
  String description;
  String photoURL;

  bool solved = false;
  bool available = false;


  Challenge(this.number, this.completed, this.description, this.photoURL);

  Challenge.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        completed = json['completed'],
        description = json['description'],
        photoURL = json['photoURL'];
  
  Map<String, dynamic> toJson() =>
  {
    'number': this.number,
    'completed': this.completed, 
    'description': this.description,
    'photoURL': this.photoURL
  };

}