import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:movie_http/movie.dart';

class HttpHelper {
  final String urlKey = 'api_key=2d24dc7249549ca040620a610a502cdb';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=2d24dc7249549ca040620a610a502cdb&query=';

  Future<List> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      //String responseBody = result.body;
      //return responseBody;
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }

  Future<List> findMovies(String title) async {
    final String query = urlSearchBase + title;
    http.Response result = await http.get(query);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      print(jsonResponse);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
