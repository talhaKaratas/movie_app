import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/components/movie_grid.dart';
import 'package:tmdb_movie_app/http/movie_service.dart';

class PopularMovies extends StatefulWidget {
  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  String _url =
      'https://api.themoviedb.org/3/movie/popular?api_key=ec05eba6536bd9e3c915f2e783745be3&language=en-US&page=1';

  MovieService _movieService;

  @override
  void initState() {
    super.initState();
    _movieService = MovieService(_url);
  }

  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      fetchMovie: _movieService.fetchMovie,
    );
  }
}
