import 'package:flutter/material.dart';
import 'package:g21097717/HomePage.dart';
import 'package:g21097717/firebase/auth_gate.dart'; // Import AuthGate
import 'package:flutter/services.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:g21097717/firebase/firebase_options.dart';

bool loggedIn = false; // Declare loggedIn as a global variable

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.getBool('loggedIn') ?? false; // Set the value of loggedIn

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Assignment CineWhiz',
      home: SplashPage(), // Show SplashScreen initially
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final Size screenSize = MediaQuery.of(context).size;

    // Delay navigation to the relevant screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => loggedIn ? const HomePage() : AuthGate(),
      ));
    });

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: SizedBox(
          width: screenSize.width * 0.6, // Adjust width as needed (60% of screen width)
          height: screenSize.height * 0.6, // Adjust height as needed (60% of screen height)
          child: Image.asset(
            'cinewhiz.png', // Replace 'cinewhiz.png' with your image asset path
            fit: BoxFit.contain, // Adjust image fit as needed
          ),
        ),
      ),
    );
  }
}
