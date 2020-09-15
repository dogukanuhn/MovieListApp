import 'dart:convert';
import 'dart:async';

import 'package:bookapp/models/Movie.dart';
import 'package:bookapp/models/MovieDetail.dart';
import 'package:bookapp/models/MovieVideo.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants.dart';

class MovieService {
  static Future<List<Movie>> getPopulerMovies() async {
    String url = apiUrl + moviePopuler + "api_key=" + apiKey + "&page=1";
    final response = await http.get(url);
    return getResponse(response);
  }

  static Future<List<Movie>> getUpComingMovie() async {
    String url = apiUrl + movieUpcoming + "api_key=" + apiKey + "&page=1";
    final response = await http.get(url);
    return getResponse(response);
  }

  static Future<List<Movie>> getTopRatedMovie() async {
    String url = apiUrl + movieTopRated + "api_key=" + apiKey + "&page=1";

    final response = await http.get(url);
    return getResponse(response);
  }

  static getResponse(Response response) {
    List<Movie> coins = [];
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> movies = data['results'];

        for (var i = 0; i < 3; i++) {
          coins.add(Movie.fromJson(movies[i]));
        }
        return coins;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  static Future<MovieDetail> getMovieDetail(id) async {
    String url = apiUrl +
        movieDetail.replaceAll("_", id.toString()) +
        "api_key=" +
        apiKey;
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        var data = movieDetailFromJson(response.body);
        url = apiUrl +
            movieVideos.replaceAll("_", id.toString()) +
            "api_key=" +
            apiKey;
        final response2 = await http.get(url);
        if (response2.statusCode == 200) {
          data.videos = movieVideoFromJson(response2.body);
        }
        return data;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  static Future<MovieVideo> getMovieVideos(id) async {
    String url = apiUrl +
        movieVideos.replaceAll("_", id.toString()) +
        "api_key=" +
        apiKey;
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        return movieVideoFromJson(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}
