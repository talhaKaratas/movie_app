class Movie {
  String backdrop_path;
  int id;
  String original_language;
  String overview;
  String poster_path;
  String release_date;
  String title;
  double vote_average;
  int vote_count;

  Movie(
      {this.backdrop_path,
      this.id,
      this.original_language,
      this.overview,
      this.poster_path,
      this.release_date,
      this.title,
      this.vote_average,
      this.vote_count});

  factory Movie.fromJson(Map<String, dynamic> data) {
    double vote_average = data['vote_average'].toDouble();
    return Movie(
        backdrop_path: data['backdrop_path'] as String,
        id: data['id'] as int,
        original_language: data['original_language'] as String,
        overview: data['overview'] as String,
        poster_path: data['poster_path'] as String,
        release_date: data['release_date'] as String,
        title: data['title'] as String,
        vote_average: vote_average,
        vote_count: data['vote_count'] as int);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'backdrop_path': backdrop_path,
      'original_language': original_language,
      'overview': overview,
      'poster_path': poster_path,
      'release_date': release_date,
      'title': title,
      'vote_average': vote_average,
      'vote_count': vote_count
    };
  }
}
