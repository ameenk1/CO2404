import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:g21097717/api.dart';
import 'package:g21097717/SearchFunction.dart';
import 'package:g21097717/TvTonight.dart';
import 'package:g21097717/HighestGrossing.dart';
import 'package:g21097717/Children.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> trendinglist = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    trendinglisthome();
  }

  Future<void> trendinglisthome() async {
    var TrendingTypeResponse = await http.get(Uri.parse(TrendingMovies));

    var tempData = jsonDecode(TrendingTypeResponse.body);
    var trendingweekjason = tempData['results'];
    for (var i = 0; i < trendingweekjason.length; i++) {
      trendinglist.add({
        'id': trendingweekjason[i]['id'],
        'poster_path': trendingweekjason[i]['poster_path'],
        'vote_average': trendingweekjason[i]['vote_average'],
        'media_type': trendingweekjason[i]['media_type'],
        'indexno': i,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendinglisthome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        height: MediaQuery.of(context).size.height,
                      ),
                      items: trendinglist.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken,
                                  ),
                                  image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500${i['poster_path']}',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
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
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trending Movies' + '🔥',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SearchFunction(),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber.withOpacity(0.4)),
                    tabs: [
                      Tab(child: Text('Tv Series')),
                      Tab(child: Text('Movies')),
                      Tab(child: Text('Children Movies'))
                    ]),
              ),
              Container(
                height: 1050,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TvTonight(), //change
                    HighestGrossing(), //change
                    Children(),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
