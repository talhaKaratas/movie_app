import 'package:tmdb_movie_app/database_helper.dart';
import 'package:tmdb_movie_app/models/Movie.dart';

class MovieDao {
  Future<List<Movie>> fetchMovies() async {
    var db = await DatabaseHelper.databaseAccess();

    List<Map<String, dynamic>> movieMap =
        await db.rawQuery('select * from Movie');

    List<Movie> movies =
        movieMap.map((movie) => Movie.fromJson(movie)).toList();

    return movies;
  }

  Future<void> insertMovie(Movie movie) async {
    var db = await DatabaseHelper.databaseAccess();

    await db.insert('Movie', movie.toMap());
  }

  Future<void> deleteMovie(int movieId) async {
    var db = await DatabaseHelper.databaseAccess();

    await db.delete('Movie', where: 'id = ?', whereArgs: [movieId]);
  }
}
