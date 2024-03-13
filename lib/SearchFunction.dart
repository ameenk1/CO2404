import 'package:flutter/material.dart';

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
  var val1;
  String selectedOption = "Default"; // Default option selected

  Future<void> searchList(String value) async {
    var searchLink = 'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$value';
    var searchLinkkids =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$value&adult=false&with_genres=16';

    var currentSearchLink = selectedOption == "Default" ? searchLink : searchLinkkids;

    var searchResponse = await http.get(Uri.parse(currentSearchLink));

    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];

      searchResult.clear(); // Clear previous search results
      for (var obj in searchJson) {
        if ((obj['id'] != null && obj['vote_average'] != null && obj['media_type'] != null) ||
            (obj['id'] != null && obj['name'] != null && obj['profile_path'] != null)) {
          searchResult.add({
            'id': obj['id'],
            'name': obj['title'] ?? obj['name'],
            'poster_path': obj['poster_path'],
            'profile_path': obj['profile_path'],
            'vote_average': obj['vote_average'],
            'media_type': obj['media_type'] ?? 'person',
            'popularity': obj['popularity'],
            'overview': obj['overview'],
            'known_for_department': obj['known_for_department'],
          });

          if (searchResult.length > 20) {
            searchResult.removeRange(20, searchResult.length);
          }
        } else {
          print('Result found');
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
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue!;
                        });
                      },
                      items: <String>['Default', 'Children'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextField(
                          autofocus: false,
                          controller: searchText,
                          onChanged: (value) {
                            setState(() {
                              val1 = value;
                              searchList(val1);
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
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
                    ),
                  ],
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
                                      width: 120,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            (searchResult[index]['media_type'] == 'tv' ||
                                                    searchResult[index]['media_type'] == 'movie')
                                                ? 'https://image.tmdb.org/t/p/w500${searchResult[index]['poster_path']}'
                                                : 'https://image.tmdb.org/t/p/w200${searchResult[index]['profile_path']}',
                                          ),
                                          fit: BoxFit.cover,
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
                                                '${searchResult[index]['name']}',
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
                                            if (selectedOption == "Children")
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                height: 85,
                                                child: Text(
                                                  'Type: ${searchResult[index]['media_type'] == 'tv' ? 'TV Series' : searchResult[index]['media_type'] == 'movie' ? 'Movie' : 'Actor'}',
                                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                                ),
                                              ),
                                            if (selectedOption == "Default")
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                height: 85,
                                                child: Text(
                                                  'Type: ${searchResult[index]['media_type'] ?? ''}',
                                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                                ),
                                              ),
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
