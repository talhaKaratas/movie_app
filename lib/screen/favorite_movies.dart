import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_movie_app/models/Movie.dart';
import 'package:tmdb_movie_app/state/favorite_movie.dart';

class FavoriteMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidthSize = MediaQuery.of(context).size.width;
    return Container(child: Consumer<FavoriteMovie>(
      builder: (context, value, child) {
        return ListView.builder(
            itemCount: value.readFavoriteMovies().length,
            itemBuilder: (context, index) {
              var data = value.readFavoriteMovies()[index];
              return Stack(
                alignment: Alignment.center,
                children: [
                  Background(data: data),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                            height: 170,
                            child: Image.network(
                                'https://image.tmdb.org/t/p/w500${data.poster_path}')),
                      ),
                      SizedBox(
                        height: 170,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Spacer(flex: 2,),
                            SizedBox(
                              width: screenWidthSize/2.5,
                              child: Text(
                                data.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                          offset: Offset(2, 2))
                                    ]
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: false,
                                    textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(flex: 3,),
                            Text(
                              'Rating: ${data.vote_average}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 10,
                                        color: Colors.black,
                                        offset: Offset(2, 2))
                                  ]),
                            ),
                            Spacer(flex: 5,)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 170,
                        child: Column(
                          children: [
                            Spacer(flex: 2,),
                            Icon(Icons.favorite, size: 27, color: Colors.white,),
                            Spacer(flex: 8,)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            });
      },
    ));
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Movie data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${data.backdrop_path}'),
              fit: BoxFit.cover)),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
      ),
    );
  }
}
