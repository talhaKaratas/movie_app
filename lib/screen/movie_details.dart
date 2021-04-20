import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/http/actor_service.dart';
import 'package:tmdb_movie_app/http/photo_service.dart';
import 'package:tmdb_movie_app/models/Actor.dart';
import 'package:tmdb_movie_app/models/Movie.dart';
import 'package:tmdb_movie_app/models/MovieImage.dart';

class MovieDetails extends StatefulWidget {
  Movie movie;

  MovieDetails({this.movie});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool readMore = false;
  ActorService _actorService;
  PhotoService _photoService;

  @override
  void initState() {
    super.initState();
    _actorService = ActorService(
        'https://api.themoviedb.org/3/movie/${widget.movie.id}/credits?api_key=ec05eba6536bd9e3c915f2e783745be3&language=en-US');
    _photoService = PhotoService(
        'https://api.themoviedb.org/3/movie/${widget.movie.id}/images?api_key=ec05eba6536bd9e3c915f2e783745be3');
  }

  @override
  Widget build(BuildContext context) {
    var screenHeightSize = MediaQuery.of(context).size.height;
    var screenWidthSize = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        ClipperImage(
                            screenHeightSize: screenHeightSize, widget: widget),
                        MovieInfo(
                            widget: widget, screenWidthSize: screenWidthSize)
                      ],
                    ),
                    storyLine(),
                    photos(),
                    actors()
                  ],
                ),
              ),
            );
          },
        ));
  }

  Column photos() {
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                             left: 15, right: 15),
                        child: Text(
                          'Photos',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: FutureBuilder<List<MovieImage>>(
                          future: _photoService.fetchMovieImage(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data;
                              return ListView.builder(
                                itemCount: data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  MovieImage image = data[index];
                                  return Padding(
                                    padding: index != (data.length - 1)
                                        ? EdgeInsets.only(right: 10)
                                        : EdgeInsets.only(right: 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          'https://image.tmdb.org/t/p/w500${image.file_path}'),
                                    ),
                                  );
                                },
                              );
                            }
                            if (snapshot.hasError) {
                              return Center();
                            } else {
                              return Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
  }

  Column actors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
          child: Text(
            'Actors',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        Container(
            height: 80,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: FutureBuilder<List<Actor>>(
              future: _actorService.fetchActor(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Actor actor = data[index];
                      return Padding(
                        padding: index != (data.length - 1)
                            ? EdgeInsets.only(right: 20)
                            : EdgeInsets.only(right: 0),
                        child: Column(
                          children: [
                            actor.profile_path != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${actor.profile_path}'),
                                    maxRadius: 30,
                                    minRadius: 20,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.greenAccent,
                                    maxRadius: 30,
                                    minRadius: 20,
                                    child: Text(
                                        actor.original_name.substring(0, 2))),
                            Text(
                              actor.original_name,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Center();
                } else {
                  return Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                      width: 20,
                      height: 20,
                    ),
                  );
                }
              },
            ))
      ],
    );
  }

  Column storyLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'Story Line',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            widget.movie.overview,
            style: TextStyle(color: Colors.white, fontSize: 18),
            maxLines: readMore ? null : 4,
            overflow: readMore ? null : TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Row(
                children: [
                  Text(
                    readMore ? 'less' : 'more',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  Icon(
                    readMore ? Icons.expand_less : Icons.expand_more,
                    color: Colors.greenAccent,
                  )
                ],
              ),
              onPressed: () {
                setState(() {
                  readMore = !readMore;
                });
              },
            )
          ],
        )
      ],
    );
  }
}

class MovieInfo extends StatelessWidget {
  const MovieInfo({
    Key key,
    @required this.widget,
    @required this.screenWidthSize,
  }) : super(key: key);

  final MovieDetails widget;
  final double screenWidthSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.poster_path}'),
              height: 200,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.vote_average.toString(),
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Ratings',
                              style: TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: List.generate(10, (index) {
                                  int roundedVote =
                                      widget.movie.vote_average.round();
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
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Grade now',
                              style: TextStyle(color: Colors.greenAccent),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Popularity:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(width: screenWidthSize / 20),
                        Text(widget.movie.vote_count.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClipperImage extends StatelessWidget {
  const ClipperImage({
    Key key,
    @required this.screenHeightSize,
    @required this.widget,
  }) : super(key: key);

  final double screenHeightSize;
  final MovieDetails widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeightSize / 3 + 100,
      child: Stack(
        children: [
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              width: double.infinity,
              height: screenHeightSize / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${widget.movie.backdrop_path}'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
