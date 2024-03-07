import 'package:flutter/material.dart';
import 'package:g21097717/api.dart';
import 'dart:convert';
import 'package:g21097717/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:g21097717/detailscreens/slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDetails extends StatefulWidget {
  final int id;
  MovieDetails({required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> MovieDetails = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List MoviesGenres = [];

  Future<void> Moviedetails() async {
    var MovieDetailUrl =
        'https://api.themoviedb.org/3/movie/' + widget.id.toString() + '?api_key=$apikey';

    var SimilarMoviesUrl =
        'https://api.themoviedb.org/3/movie/' + widget.id.toString() + '/similar?api_key=$apikey';

    var RecommendedMoviesUrl =
        'https://api.themoviedb.org/3/movie/' + widget.id.toString() + '/recommendations?api_key=$apikey';

    var moviedetailresponse = await http.get(Uri.parse(MovieDetailUrl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      MovieDetails.add({
        "backdrop_path": moviedetailjson['backdrop_path'],
        "title": moviedetailjson['title'],
        "vote_average": moviedetailjson['vote_average'],
        "overview": moviedetailjson['overview'],
        "release_date": moviedetailjson['release_date'],
        "runtime": moviedetailjson['runtime'],
        "budget": moviedetailjson['budget'],
        "revenue": moviedetailjson['revenue'],
      });
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGenres.add(moviedetailjson['genres'][i]['name']);
      }
    } else {
      // Handle error
    }

    //similar movies
    var similarmoviesresponse = await http.get(Uri.parse(SimilarMoviesUrl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovieslist.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {
      // Handle error
    }

    //recommended movies
    var recommendedmoviesresponse =
        await http.get(Uri.parse(RecommendedMoviesUrl));
    if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovieslist.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: Moviedetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(FontAwesomeIcons.arrowLeft),
                    iconSize: 28,
                    color: Colors.white,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: Icon(FontAwesomeIcons.home),
                      iconSize: 25,
                      color: Colors.white,
                    )
                  ],
                  backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                  centerTitle: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    background: MovieDetails[0]['backdrop_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500/${MovieDetails[0]['backdrop_path']}',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey, // Placeholder color if no backdrop path available
                          ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        Row(children: [
                          Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: MoviesGenres.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(MoviesGenres[index]),
                                  );
                                },
                              )),
                        ]),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(MovieDetails[0]['runtime'].toString() + 'min'))
                          ],
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text('Movie Story: ')),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(MovieDetails[0]['overview'].toString())),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text('Release Date' + MovieDetails[0]['release_date'].toString())),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text('Budget: ' + MovieDetails[0]['budget'].toString())),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text('Revenue: ' + MovieDetails[0]['revenue'].toString())),
                    // Add your sliderlist widgets here with similarmovieslist and recommendedmovieslist
                  ]),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
