import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/Actor.dart';

class ActorService {
  String _serviceUrl;

  ActorService(this._serviceUrl);

  Future<List<Actor>> fetchActor() async {
    var response = await http.get(_serviceUrl);

    if (response.statusCode == 200) {
      Iterable actors = json.decode(response.body)['cast'];

      return actors.map((actor) => Actor.fromJson(actor)).toList();
    }else {
      throw Exception('Something went wrong');
    }
  }
}
