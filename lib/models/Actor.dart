class Actor {
  String original_name;
  String profile_path;
  String character;

  Actor({this.original_name, this.profile_path, this.character});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
        original_name: json['original_name'],
        profile_path: json['profile_path'] ,
        character: json['character']);
  }
}
