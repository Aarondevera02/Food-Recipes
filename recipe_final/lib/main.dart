import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:recipe_final/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Recipes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EasySplashScreen(
      logo: Image.asset(
          'assets/images/bg.png',
          height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
          ),
      title: const Text(
        "Foodies",
        style: TextStyle(
          color: Colors.brown,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      showLoader: true,
      loadingText:const Text("Created by: Joseph Aaron Jumawan", style: TextStyle(
        color: Colors.brown
      ),),
      navigator:Home(),
      durationInSeconds: 3,
    ),
    );
  }
}