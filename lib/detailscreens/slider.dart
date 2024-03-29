import 'package:flutter/material.dart';
import 'package:g21097717/detailscreens/TvSeriesDetails.dart';
import 'package:g21097717/detailscreens/MovieDetails.dart';

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return sliderlist([], "Category Title", "movie", 0);
  }
}

Widget sliderlist(List firstlistname, String categorytittle, String type, int itemlength) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
        child: Text(categorytittle), // Placeholder for tittletext
      ),
      Container(
        height: 250,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: itemlength,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (type == 'movie') {
                      // print(firstlistname[index]['id']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                    id: firstlistname[index]['id'],
                                  )));
                    } else if (type == 'tv') {
                      // print(firstlistname[index]['id']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TvSeriesDetails(
                                  id: firstlistname[index]['id'])));
                    }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${firstlistname[index]['poster_path']}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: EdgeInsets.only(left: 13),
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 6),
                      child: Text(firstlistname[index]['name'], style: TextStyle(color: Colors.white)), // Name of the movie or TV series
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 6),
                          child: Text(firstlistname[index]['Date'].toString()), // Placeholder for datetext
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 15,
                                  ),
                                  SizedBox(width: 2),
                                  Text(firstlistname[index]['vote_average'].toString()), // Placeholder for ratingtext
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}
