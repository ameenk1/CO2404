import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WatchedScreen extends StatelessWidget {
  WatchedScreen();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final Uri uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=ba99f6ccb496e7c89f997871aff42499');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  void removeMovieFromWatched(String movieId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('watched')
        .doc(movieId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watched Movies'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('watched')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No watched movies found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final movieId = snapshot.data!.docs[index].id;
              return FutureBuilder<Map<String, dynamic>>(
                future: fetchMovieDetails(int.parse(movieId)),
                builder: (context, movieSnapshot) {
                  if (movieSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (movieSnapshot.hasError) {
                    return const ListTile(
                      title: Text('Error loading movie details'),
                    );
                  }

                  final movieDetails = movieSnapshot.data!;
                  // Construct the poster URL
                  final posterPath = movieDetails['poster_path'];
                  final posterUrl =
                      'https://image.tmdb.org/t/p/w500$posterPath';

                  return ListTile(
                    leading: Image.network(
                        posterUrl), // Display poster as leading widget
                    title: Text(movieDetails['title']),
                    subtitle: Text(movieDetails['overview']),
                    // You can add more details here as per your requirement
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        removeMovieFromWatched(movieId);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
