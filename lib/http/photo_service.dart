import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/MovieImage.dart';

class PhotoService {
  String _serviceUrl;

  PhotoService(this._serviceUrl);

  Future<List<MovieImage>> fetchMovieImage() async {
    var response = await http.get(_serviceUrl);

    if (response.statusCode == 200) {
      Iterable movieImage = json.decode(response.body)['backdrops'];

      return movieImage.map((image) => MovieImage.fromJson(image)).toList();
    } else {
      throw Exception('Something went wrong');
    }
  }
}
