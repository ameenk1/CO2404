import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g21097717/detailScreens/MovieDetails.dart';
import 'package:g21097717/watchlist.dart';


// Function to save user information to Firestore
Future<void> saveUserInfo(String email) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to the users collection in Firestore
      CollectionReference<Map<String, dynamic>> users =
          FirebaseFirestore.instance.collection('users');

      // Add a new document with a generated ID
      await users.doc(user.uid).set({
        'email': email,
        // You can add more fields as per your requirement
      });
    } else {
      print('User is not signed in.');
    }
  } catch (e) {
    print('Error saving user information: $e');
  }
}



Future<void> saveMovieDetails(String userId, int movieId, String listType) async {
  try {
    // Reference to the user's document in the users collection
    DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Reference to the appropriate subcollection within the user's document based on listType
    CollectionReference<Map<String, dynamic>> movies =
        userDocRef.collection('watched');

    // Add a new document with a generated ID
    await movies.doc(movieId.toString()).set({
      'id': movieId,
    });
  } catch (e) {
    print('Error saving movie details: $e');
  }
}