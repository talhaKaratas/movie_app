import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/dao/movie_dao.dart';
import 'package:tmdb_movie_app/models/Movie.dart';

class FavoriteMovie with ChangeNotifier {
  List<Movie> favoriteMovie = new List<Movie>();

  FavoriteMovie() {
    addFavoriteMovieAppInitilaized();
  }

  List<Movie> readFavoriteMovies() {
    return List.from(favoriteMovie.reversed);
  }

  void addFavoriteMovie(Movie movie) {
    favoriteMovie.add(movie);
    notifyListeners();
  }

  void removeFavoriteMovie(int movieId) {
    favoriteMovie.removeWhere((element) => element.id == movieId);
    notifyListeners();
  }

  void addFavoriteMovieAppInitilaized() async {
    favoriteMovie = await MovieDao().fetchMovies();
    notifyListeners();
  }
}
