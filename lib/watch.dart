import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:g21097717/api.dart';
import 'package:g21097717/DetailScreen.dart';
import 'package:g21097717/detailscreens/slider.dart';
import 'package:url_launcher/url_launcher.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  List<Map<String, dynamic>> toWatchMovies = [];
  List<Map<String, dynamic>> upMovies = [];

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _fetchMovies();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchMovies() async {
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
      // Save movies to local storage
      _prefs.setString('upcomingMovies', jsonEncode(upMovies));
    } else {
      print(cinemaMoviesResponse.statusCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(color: Colors.amber.shade400),
          );
        else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sliderlist(upMovies, "On Cinema", "movie", 20),
            ],
          );
        }
      },
    );
  }
}
