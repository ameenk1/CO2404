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
    var upcomingMoviesResponse = await http.get(Uri.parse(popularmoviesurl));
    if (upcomingMoviesResponse.statusCode == 200) {
      var tempData = jsonDecode(upcomingMoviesResponse.body);
      var upcomingMoviesJson = tempData['results'];
      for (var i = 0; i < upcomingMoviesJson.length; i++) {
        upMovies.add({
          'name': upcomingMoviesJson[i]['title'],
          'poster_path': upcomingMoviesJson[i]['poster_path'],
          'vote_average': upcomingMoviesJson[i]['vote_average'],
          'Date': upcomingMoviesJson[i]['release_date'],
          'id': upcomingMoviesJson[i]['id'],
        });
      }
      // Save movies to local storage
      _prefs.setString('upcomingMovies', jsonEncode(upMovies));
    } else {
      print(upcomingMoviesResponse.statusCode);
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
              sliderlist(upMovies, "Cinema Movies", "movie", 20),
            ],
          );
        }
      },
    );
  }
}
