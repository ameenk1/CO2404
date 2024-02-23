import 'dart:html';
import 'package:g21097717/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:g21097717/api.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
List<Map<String, dynamic>> trendinglist =[];

  Future<void> trendinglisthome() async {
    var TrendingTypeResponse = await http.get(Url.parse(TrendingWeek));
    if (TrendingTypeResponse.statusCode == 200 ){
      var tempData = jsonDecode(TrendingTypeResponse.body);
      var trendingweekjason = tempData['Results'];
      for (var i =0; i< trendingweekjason.length; i++){
        trendinglist.add({
          'id': trendingweekjason[i]['id'],
          'poster_path': trendingweekjason[i]['poster_path'],
          'vote_average': trendingweekjason[i]['vote_average'],
          'media_type': trendingweekjason[i]['media_type'],
          'indexno': i,    
        });
      }
    }
  }

  int value = 1;
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
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.done){
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds:2),
                        height: MediaQuery.of(context).size.height
                      ),
                  items: trendinglist.map((i){
                    return Builder(builder: (BuildContext context){
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken
                              ),
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${i['poster_path']'}),
                                fit: BoxFit.fill)),
                        )
                      );
                    });
                  }).toList(),   
                  } else{
                    return Center(
                      child: CircularProgressIndicator{
                        Color: Colors.amber,
                      },
                    );
                  }
                },
              ),
             ),
              title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Trending' + '🔥',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 16)),
              SizedBox(width: 10),
            ],
          )),
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Text("Sample Text"),
            )
          ]))
        ],
      ),
    );
  }
}


CarouselSlider(
   items: items,
   options: CarouselOptions(
      height: 400,
      aspectRatio: 16/9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.3,
      onPageChanged: callbackFunction,
      scrollDirection: Axis.horizontal,
   )
 )