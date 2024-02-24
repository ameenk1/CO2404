import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:g21097717/api.dart';

class TvTonight extends StatefulWidget {
  const TvTonight({Key? key});

  @override
  State<TvTonight> createState() => _TvTonightState();
}

class _TvTonightState extends State<TvTonight> {
  List<Map<String, dynamic>> tvTonightList = [];

  Future<void> tvTonightFunction() async {
    var tonightResponse = await http.get(Uri.parse(MoviesTonight));
    if (tonightResponse.statusCode == 200) {
      var tempData = jsonDecode(tonightResponse.body);
      var tonightJson = tempData['Results'];
      for (var i = 0; i < tonightJson.length; i++) {
        tvTonightList.add({
          "name": tonightJson[i]["name"],
          "poster_path": tonightJson[i]["poster_path"],
          "vote_average": tonightJson[i]["vote_average"],
          "date": tonightJson[i]["date"],
          "id": tonightJson[i]["id"],
        });
      }
    } else {
      print(tonightResponse.statusCode);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tvTonightFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
                child: Text("What's on TV Tonight"),
              ),
              Container(
                height: 250,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: tvTonightList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration( 
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${tvTonightList[index]['poster_path']}'),
                            fit: BoxFit.cover
                          ),
                        ),
                        margin: EdgeInsets.only(left:13),
                        width: 170,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                              top: 2, left: 6),
                              child: Text(tvTonightList[index]['date'])), // Corrected 'Date' to 'date'
                              Padding(
                               padding: const EdgeInsets.only(
                              top: 2, right: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2, bottom: 2,
                                      left: 5, right: 5),
                                      child: Row(children: [
                                        Icon( // Removed 'const' before Icon
                                          Icons.star, // Corrected 'Icon.star' to 'Icons.star'
                                          color: Colors.yellow,
                                          ),
                                          SizedBox(width: 10), // Adjusted width
                                        Text(
                                          tvTonightList[index]['vote_average'].toString()
                                        )
                                      ])
                                  )
                              )
                              ) 
                          ]
                        )
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}
