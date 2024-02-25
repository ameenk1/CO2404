import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:g21097717/checker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:g21097717/api.dart';

class SearchFunction extends StatefulWidget {
  const SearchFunction({Key? key}) : super(key: key);

  @override
  State<SearchFunction> createState() => _SearchFunctionState();
}

class _SearchFunctionState extends State<SearchFunction> {
  List<Map<String, dynamic>> searchResult = [];
  final TextEditingController searchText = TextEditingController();
  bool showResultsList = false;
  var val1;

  Future<void> searchList(String value) async {
    var searchLink =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$value';

    var searchResponse = await http.get(Uri.parse(searchLink));

    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];

      searchResult.clear(); // Clear previous search results
      for (var obj in searchJson) {
        if (obj['id'] != null &&
            obj['poster_path'] != null &&
            obj['vote_average'] != null &&
            obj['media_type'] != null) {
          searchResult.add({
            'id': obj['id'],
            'poster_path': obj['poster_path'],
            'vote_average': obj['vote_average'],
            'media_type': obj['media_type'], // Corrected field name
            'popularity': obj['popularity'],
            'overview': obj['overview']
          });

          if (searchResult.length > 20) {
            searchResult.removeRange(20, searchResult.length);
          }
        } else {
          print('Result not found');
        }
      }
    } else {
      print('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showResultsList = !showResultsList; //bool
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextField(
                  autofocus: false,
                  controller: searchText,
                  onSubmitted: (value) {
                    setState(() {
                      val1 = value;
                      searchList(val1);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      val1 = value;
                      searchList(val1);
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                          webBgColor: "#000000",
                          webPosition: "center",
                          webShowClose: true,
                          msg: "Search Cleared",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        setState(() {
                          searchText.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                          searchResult.clear();
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.amber.withOpacity(0.6),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.amber,
                    ),
                    hintText: 'search here',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 5),
              if (searchText.text.isNotEmpty)
                FutureBuilder(
                  future: searchList(val1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      );
                    } else {
                      return Container(
                        height: 400,
                        child: ListView.builder(
                          itemCount: searchResult.length,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => descriptioncheckui(
                                      searchResult[index]['id'],
                                      searchResult[index]['media_type'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 4, bottom: 4),
                                height: 180,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(20, 20, 20, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${searchResult[index]['poster_path']}',
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                '${searchResult[index]['media_type']}',
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber.withOpacity(0.2),
                                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('${searchResult[index]['vote_average']}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    height: 30,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber.withOpacity(0.2),
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.people_outline_sharp,
                                                          color: Colors.amber,
                                                          size: 10,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              '${searchResult[index]['popularity']}',
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              height: 85,
                                              child: Text(
                                                ' ${searchResult[index]['overview']}',
                                                style: TextStyle(fontSize: 12, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

