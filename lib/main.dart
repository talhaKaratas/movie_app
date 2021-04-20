import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_movie_app/screen/favorite_movies.dart';
import 'package:tmdb_movie_app/screen/now_playing.dart';
import 'package:tmdb_movie_app/screen/popular_movies.dart';
import 'package:tmdb_movie_app/screen/top_rated_movies.dart';
import 'package:tmdb_movie_app/state/favorite_movie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xff212121), accentColor: Color(0xff303030)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String appTitle = 'Popular Movies';

  static  List<Widget> _widgetOption = [
    PopularMovies(),
    NowPlaying(),
    TopRatedMovies(),
    FavoriteMovies()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        appTitle = 'Popular Movies';
      } else if (_selectedIndex == 1) {
        appTitle = 'Now Playing Movies';
      } else if (_selectedIndex == 2) {
        appTitle = 'Top Rated Movies';
      } else {
        appTitle = 'Favorite Movies';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => FavoriteMovie())],
      child: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
        ),
        body: Container(
          // color: Theme.of(context).accentColor,
          child: _widgetOption[_selectedIndex]
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.star_border),
                  activeIcon: Icon(Icons.star),
                  label: 'Popular'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  activeIcon: Icon(Icons.info_sharp),
                  label: 'Now Playing'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.whatshot_outlined),
                  activeIcon: Icon(Icons.whatshot),
                  label: 'Top Rated'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Favorite'),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.white,
            onTap: _onItemTapped),
      ),
    );
  }
}
