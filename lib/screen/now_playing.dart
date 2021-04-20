import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/components/movie_grid.dart';
import 'package:tmdb_movie_app/http/movie_service.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  String _url =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=ec05eba6536bd9e3c915f2e783745be3&language=en-US&page=1';

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
