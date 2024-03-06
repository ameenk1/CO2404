import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:g21097717/api.dart';
import 'package:g21097717/DetailScreen.dart';
import 'package:g21097717/detailscreens/slider.dart';
import 'package:url_launcher/url_launcher.dart';

class Movie extends StatefulWidget {
  const Movie({Key? key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  List<Map<String, dynamic>> Childrenmovies = [];
  List<Map<String, dynamic>> nowplayingmovies = [];
  List<Map<String, dynamic>> grossmovies = [];

  Future<void> moviesfunction() async {
    var Childrenmoviesresponse = await http.get(Uri.parse(childrenurl));
    if (Childrenmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(Childrenmoviesresponse.body);
      var childrenmoviesjson = tempdata['results'];
      for (var i = 0; i < childrenmoviesjson.length; i++) {
        Childrenmovies.add({
          'name': childrenmoviesjson[i]['title'],
          'poster_path': childrenmoviesjson[i]['poster_path'],
          'vote_average': childrenmoviesjson[i]['vote_average'],
          'Date': childrenmoviesjson[i]['release_date'],
          'id': childrenmoviesjson[i]['id'],
        });
      }
    } else {
      print(Childrenmoviesresponse.statusCode);
    }

    var nowplayingmoviesresponse = await http.get(Uri.parse(MoviesTonight));
    if (nowplayingmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(nowplayingmoviesresponse.body);
      var nowplayingmoviesjson = tempdata['results'];
      for (var i = 0; i < nowplayingmoviesjson.length; i++) {
        nowplayingmovies.add({
          "name": nowplayingmoviesjson[i]["title"],
          "poster_path": nowplayingmoviesjson[i]["poster_path"],
          "vote_average": nowplayingmoviesjson[i]["vote_average"],
          "Date": nowplayingmoviesjson[i]["release_date"],
          "id": nowplayingmoviesjson[i]["id"],
        });
      }
    } else {
      print(nowplayingmoviesresponse.statusCode);
    }

    var grossmoviesresponse = await http.get(Uri.parse(HighestGross));
    if (grossmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(grossmoviesresponse.body);
      var topratedmoviesjson = tempdata['results'];
      for (var i = 0; i < topratedmoviesjson.length; i++) {
        grossmovies.add({
          "name": topratedmoviesjson[i]["title"],
          "poster_path": topratedmoviesjson[i]["poster_path"],
          "vote_average": topratedmoviesjson[i]["vote_average"],
          "Date": topratedmoviesjson[i]["release_date"],
          "id": topratedmoviesjson[i]["id"],
        });
      }
    } else {
      print(grossmoviesresponse.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    moviesfunction();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moviesfunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(color: Colors.amber.shade400),
          );
        else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sliderlist(Childrenmovies, "Children Movies", "movie", 20),
              sliderlist(nowplayingmovies, "Now Playing", "movie", 20),
              sliderlist(grossmovies, "Highest Gross", "movie", 20),
            ],
          );
        }
      },
    );
  }
}
