import 'package:flutter/material.dart';
import 'package:g21097717/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActorDetails extends StatefulWidget {
  final int id;
  ActorDetails({required this.id});

  @override
  State<ActorDetails> createState() => _ActorDetailsState();
}

class _ActorDetailsState extends State<ActorDetails> {
  List<Map<String, dynamic>> actorDetails = [];
  List<Map<String, dynamic>> actorMoviesList = [];
  List actorGenres = [];
  bool sortByAscending = true;

  Future<void> fetchActorDetails() async {
    var actorDetailsUrl = 'https://api.themoviedb.org/3/person/${widget.id}?api_key=$apikey';
    var actorMoviesUrl = 'https://api.themoviedb.org/3/person/${widget.id}/movie_credits?api_key=$apikey';

    var actorDetailsResponse = await http.get(Uri.parse(actorDetailsUrl));
    if (actorDetailsResponse.statusCode == 200) {
      var actorDetailsJson = jsonDecode(actorDetailsResponse.body);
      actorDetails.add({
        "profile_path": actorDetailsJson['profile_path'],
        "name": actorDetailsJson['name'],
        "known_for_department": actorDetailsJson['known_for_department'],
        "biography": actorDetailsJson['biography'],
        "birthday": actorDetailsJson['birthday'],
        // Add more details as required
      });

      // Fetching actor's movies
      var actorMoviesResponse = await http.get(Uri.parse(actorMoviesUrl));
      if (actorMoviesResponse.statusCode == 200) {
        var actorMoviesJson = jsonDecode(actorMoviesResponse.body);
        for (var movie in actorMoviesJson['cast']) {
          actorMoviesList.add({
            "title": movie['title'],
            "character": movie['character'],
            "release_date": movie['release_date'],
            "poster_path": movie['poster_path'], // New field for storing poster path
            // Add more details as required
          });
        }
      } else {
        // Handle error
      }
    } else {
      // Handle error
    }
  }

  void toggleSortOrder() {
    setState(() {
      sortByAscending = !sortByAscending;
      actorMoviesList.sort((a, b) {
        if (sortByAscending) {
          return a['release_date'].compareTo(b['release_date']);
        } else {
          return b['release_date'].compareTo(a['release_date']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: fetchActorDetails(),
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
                  backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                  centerTitle: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    background: actorDetails[0]['profile_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500/${actorDetails[0]['profile_path']}',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey, // Placeholder color if no profile path available
                          ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actorDetails[0]['name'],
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Known For: ${actorDetails[0]['known_for_department']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Biography:',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            actorDetails[0]['biography'],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Birthday: ${actorDetails[0]['birthday']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Movies:',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: toggleSortOrder,
                                icon: Icon(sortByAscending ? Icons.arrow_upward : Icons.arrow_downward),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: actorMoviesList.map((movie) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (movie['poster_path'] != null)
                                        Image.network(
                                          'https://image.tmdb.org/t/p/w200/${movie['poster_path']}',
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      else
                                        Container(
                                          width: 100,
                                          height: 150,
                                          color: Colors.grey, // Placeholder color if no poster available
                                        ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Title: ${movie['title']}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Character: ${movie['character']}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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
