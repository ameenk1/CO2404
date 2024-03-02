import 'package:flutter/material.dart';
import 'package:g21097717/api.dart';
import 'dart:convert';
import 'package:g21097717/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:g21097717/detailscreens/slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TvSeriesDetails extends StatefulWidget {
  var id;
  TvSeriesDetails({this.id});

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  var tvseriesdetaildata;
  List<Map<String, dynamic>> TvSeriesDetails = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendserieslist = [];

  Future<void> tvseriesdetailfunc() async {
    var tvseriesdetailurl = 'https://api.themoviedb.org/3/tv/'+widget.id.toString()+'?api_key=$apikey';
    var similarseriesurl = 'https://api.themoviedb.org/3/tv/'+widget.id.toString()+'/similar?api_key=$apikey';
    var recommendseriesurl = 'https://api.themoviedb.org/3/tv/'+widget.id.toString()+'/recommendations?api_key=$apikey';

    var tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);
      for (var i = 0; i < 1; i++) {
        TvSeriesDetails.add({
          'backdrop_path': tvseriesdetaildata['backdrop_path'],
          'title': tvseriesdetaildata['original_name'],
          'vote_average': tvseriesdetaildata['vote_average'],
          'overview': tvseriesdetaildata['overview'],
          'status': tvseriesdetaildata['status'],
          'releasedate': tvseriesdetaildata['first_air_date'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['genres'].length; i++) {
        TvSeriesDetails.add({
          'genre': tvseriesdetaildata['genres'][i]['name'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['created_by'].length; i++) {
        TvSeriesDetails.add({
          'creator': tvseriesdetaildata['created_by'][i]['name'],
          'creatorprofile': tvseriesdetaildata['created_by'][i]['profile_path'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['seasons'].length; i++) {
        TvSeriesDetails.add({
          'season': tvseriesdetaildata['seasons'][i]['name'],
          'episode_count': tvseriesdetaildata['seasons'][i]['episode_count'],
        });
      }
    } else {}

    var similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      var similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    var recommendseriesresponse = await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      var recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}
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
          future: tvseriesdetailfunc(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        leading:
                            //circular icon button
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(FontAwesomeIcons.circleArrowLeft),
                                iconSize: 28,
                                color: Colors.white),
                        actions: [
                          IconButton(
                              onPressed: () {
                                //kill all previous routes and go to home page
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
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.35,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: FittedBox(
                            fit: BoxFit.fill,
                            
                          ),
                        )),
                    SliverList(
                        delegate: SliverChildListDelegate([
                     
                      Row(children: [
                        Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: tvseriesdetaildata['genres']!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(25, 25, 25, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                          TvSeriesDetails[index + 1]['genre']
                                              .toString()));
                                }))
                      ]),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 12),
                          child: Text("Series Overview : ")),

                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text(
                              TvSeriesDetails[0]['overview'].toString())),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text("Status : " +
                              TvSeriesDetails[0]['status'].toString())),
                      //created by
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text("Created By : ")),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  tvseriesdetaildata['created_by']!.length,
                              itemBuilder: (context, index) {
                                //generes box
                                return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(25, 25, 25, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(children: [
                                      Column(children: [
                                        CircleAvatar(
                                            radius: 45,
                                            backgroundImage: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500' +
                                                    TvSeriesDetails[index + 4]
                                                            ['creatorprofile']
                                                        .toString())),
                                        SizedBox(height: 10),
                                        Text(TvSeriesDetails[index + 4]
                                                ['creator']
                                            .toString())
                                      ])
                                    ]));
                              })),
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text("Total Seasons : " +
                              tvseriesdetaildata['seasons'].length.toString())),
                      //airdate
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Text("Release date : " +
                              TvSeriesDetails[0]['releasedate'].toString())),
                      sliderlist(similarserieslist, 'Similar Series', 'tv',
                          similarserieslist.length),
                      sliderlist(recommendserieslist, 'Recommended Series',
                          'tv', recommendserieslist.length),
                      Container(
                          //     height: 50,
                          //     child: Center(child: normaltext("By Niranjan Dahal"))
                          )
                    ]))
                  ]);
            } else {
              return Center(
                  child:
                      CircularProgressIndicator(color: Colors.amber.shade400));
            }
          }),
    );
  }
}
