import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/Movie.dart';

class MovieService {
  String _serviceUrl;

  MovieService(this._serviceUrl);

  Future<List<Movie>> fetchMovie() async {
    var response = await http.get(_serviceUrl);

    if (response.statusCode == 200) {
      List movies = json.decode(response.body)['results'];

      List<Movie> movieList =
          movies.map((movie) => Movie.fromJson(movie)).toList();

      return movieList;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
