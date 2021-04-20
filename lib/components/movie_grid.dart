import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_movie_app/dao/movie_dao.dart';
import 'package:tmdb_movie_app/models/Movie.dart';
import 'package:tmdb_movie_app/screen/movie_details.dart';
import 'package:tmdb_movie_app/state/favorite_movie.dart';

class MovieGrid extends StatefulWidget {
  Function fetchMovie;

  MovieGrid({this.fetchMovie});
  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: widget.fetchMovie(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
                mainAxisSpacing: 20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var movie = data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieDetails(
                                movie: movie,
                              )));
                },
                child: MoviePoster(movie: movie),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center();
        } else {
          return Loading();
        }
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        width: 50,
        height: 50,
      ),
    );
  }
}

class MoviePoster extends StatefulWidget {
  const MoviePoster({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _MoviePosterState createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.movie.poster_path}'),
              ),
              Positioned(
                child: Consumer<FavoriteMovie>(
                  builder: (context, value, child) {
                    if (value
                        .readFavoriteMovies()
                        .any((element) => element.id == widget.movie.id)) {
                      _isFavorite = true;
                    } else {
                      _isFavorite = false;
                    }
                    return IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        iconSize: 35,
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          if (_isFavorite) {
                            value.addFavoriteMovie(widget.movie);
                            MovieDao().insertMovie(widget.movie);
                          } else {
                            value.removeFavoriteMovie(widget.movie.id);
                            MovieDao().deleteMovie(widget.movie.id);
                          }
                        });
                  },
                ),
                right: 0,
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(10, (index) {
                      int roundedVote = widget.movie.vote_average.round();
                      if (roundedVote > widget.movie.vote_average)
                        roundedVote--;

                      if (index < roundedVote) {
                        return Icon(
                          Icons.star,
                          color: Colors.greenAccent,
                          size: 14.5,
                        );
                      } else {
                        return Icon(
                          Icons.star,
                          color: Colors.grey,
                          size: 14.5,
                        );
                      }
                    }),
                  ),
                ),
                Text(
                  '(${widget.movie.vote_average})',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.movie.release_date,
                  style: TextStyle(color: Colors.grey)),
              Text(
                'Vote(${widget.movie.vote_count})',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }
}
