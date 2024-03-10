import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:g21097717/api.dart';
import 'package:g21097717/detailscreens/slider.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<Map<String, dynamic>> upMovies = [];
  List<Map<String, dynamic>> trendingMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    await _fetchCinemaMovies();
    await _fetchTrendingMovies();
    setState(() {});
  }

  Future<void> _fetchCinemaMovies() async {
    var cinemaMoviesResponse = await http.get(Uri.parse(popularmoviesurl));
    if (cinemaMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(cinemaMoviesResponse.body);
      var cinemaMoviesJson = tempData['results'];
      for (var i = 0; i < cinemaMoviesJson.length; i++) {
        upMovies.add({
          'name': cinemaMoviesJson[i]['title'],
          'poster_path': cinemaMoviesJson[i]['poster_path'],
          'vote_average': cinemaMoviesJson[i]['vote_average'],
          'Date': cinemaMoviesJson[i]['release_date'],
          'id': cinemaMoviesJson[i]['id'],
        });
      }
    } else {
      print("Loading");
    }
  }

  Future<void> _fetchTrendingMovies() async {
    var trendingMoviesResponse = await http.get(Uri.parse(UpComingMoviesurl));
    if (trendingMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(trendingMoviesResponse.body);
      var trendingMoviesJson = tempData['results'];
      for (var i = 0; i < trendingMoviesJson.length; i++) {
        trendingMovies.add({
          'name': trendingMoviesJson[i]['title'],
          'poster_path': trendingMoviesJson[i]['poster_path'],
          'vote_average': trendingMoviesJson[i]['vote_average'],
          'Date': trendingMoviesJson[i]['release_date'],
          'id': trendingMoviesJson[i]['id'],
        });
      }
    } else {
      print("Loading");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider for cinema movies
        sliderlist(upMovies, "On Cinema", "movie", 20),

        // Slider for trending movies
        sliderlist(trendingMovies, "Recommened Watch List", "movie", 20),
      ],
    );
  }
}
