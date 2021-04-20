class MovieImage {
  String file_path;

  MovieImage(this.file_path);

  factory MovieImage.fromJson(Map<String, dynamic> json) {
    return MovieImage(json['file_path']);
  }
}
