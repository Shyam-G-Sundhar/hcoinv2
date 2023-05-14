import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Home/home.dart';
import 'getscreens/getscreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (_auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (route) => false);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GetScreen()));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
            extendBody: true,
            body: Center(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 230,
                        width: 216,
                        child: Image.asset("assets/logo.png"),
                      ),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                                  colors: [
                                Colors.red,
                                Colors.blue,
                              ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter)
                              .createShader(bounds);
                        },
                        child: Text(
                          "H Coin",
                          style: GoogleFonts.reemKufi(
                              fontSize: 45, color: const Color(0x000096ff)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
