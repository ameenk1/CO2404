import 'package:flutter/material.dart';
import 'package:g21097717/api.dart';
import 'dart:convert';
import 'package:g21097717/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:g21097717/detailscreens/slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDetails extends StatefulWidget {
  var id;
  MovieDetails({this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> MovieDetails = [];
  List<Map<String, dynamic>> UserReviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List MoviesGenres = [];
  List<Map<String, dynamic>> movieCast = [];

  Future Moviedetails() async {
    var moviedetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '?api_key=$apikey';
    var UserReviewurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/reviews?api_key=$apikey';
    var similarmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    var recommendedmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    var moviecreditsurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/credits?api_key=$apikey';

    var moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      for (var i = 0; i < 1; i++) {
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
      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGenres.add(moviedetailjson['genres'][i]['name']);
      }
    } else {}

    /////////////////////////////User Reviews///////////////////////////////
    var UserReviewresponse = await http.get(Uri.parse(UserReviewurl));
    if (UserReviewresponse.statusCode == 200) {
      var UserReviewjson = jsonDecode(UserReviewresponse.body);
      for (var i = 0; i < UserReviewjson['results'].length; i++) {
        UserReviews.add({
          "name": UserReviewjson['results'][i]['author'],
          "review": UserReviewjson['results'][i]['content'],
          "rating": UserReviewjson['results'][i]['author_details']['rating'] ==
                  null
              ? "Not Rated"
              : UserReviewjson['results'][i]['author_details']['rating']
                  .toString(),
          "avatarphoto": UserReviewjson['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  UserReviewjson['results'][i]['author_details']['avatar_path'],
          "creationdate":
              UserReviewjson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": UserReviewjson['results'][i]['url'],
        });
      }
    } else {}
    /////////////////////////////similar movies
    var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
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
    } else {}
    /////////////////////////////recommended movies
    var recommendedmoviesresponse =
        await http.get(Uri.parse(recommendedmoviesurl));
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
    } else {}
    /////////////////////////////movie cast
    var moviecreditsresponse = await http.get(Uri.parse(moviecreditsurl));
    if (moviecreditsresponse.statusCode == 200) {
      var moviecreditsjson = jsonDecode(moviecreditsresponse.body);
      for (var i = 0; i < moviecreditsjson['cast'].length; i++) {
        movieCast.add({
          "name": moviecreditsjson['cast'][i]['name'],
          "character": moviecreditsjson['cast'][i]['character'],
          "profile_path": moviecreditsjson['cast'][i]['profile_path'] == null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  moviecreditsjson['cast'][i]['profile_path'],
        });
      }
    } else {}

    print(movieCast);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
          future: Moviedetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    actions: [
                       IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              },
                              icon: Icon(FontAwesomeIcons.houseUser),
                              iconSize: 25,
                              color: Colors.white)
                    ],
                    backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                    centerTitle: false,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: Placeholder(), // replace with desired widget
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Add widgets for movie details, genres, reviews, etc.

                        // Example:
                        // MovieDetailWidget(),
                        // GenresWidget(),
                        // ReviewsWidget(),
                        // SimilarMoviesWidget(),
                        // RecommendedMoviesWidget(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }


                       
