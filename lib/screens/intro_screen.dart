import 'dart:async';

import 'package:audio_player_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/track.png'),
              ),

              SizedBox(height: 20),
              Text(
                "Enjoy Your Moment!",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
