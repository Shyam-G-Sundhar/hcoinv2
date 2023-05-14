import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/splash%20screen/getscreens/logsig.dart';
import 'package:introduction_screen/introduction_screen.dart';

class GetScreen extends StatefulWidget {
  const GetScreen({super.key});

  @override
  State<GetScreen> createState() => _GetScreenState();
}

class _GetScreenState extends State<GetScreen> {
  final List<String> images = [
    "assets/c1.png",
    "assets/c2.png",
    "assets/c3.png",
  ];
  final List<String> titles = [
    "Welcome!",
    "Grab The Coins",
    'Save Your Coins',
  ];
  final List<String> bodies = ["H Coin", "H Coin", 'H Wallet'];
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Image.asset(
                        images[index],
                        height: 350,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Expanded(
            flex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  titles[_currentPage],
                  style: GoogleFonts.reemKufi(
                      fontSize: 30, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.0),
                Text(
                  bodies[_currentPage],
                  style: GoogleFonts.reemKufi(
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(height: 15.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (_currentPage == images.length - 1) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LogSig()));
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                _currentPage == images.length - 1
                                    ? Icons.done
                                    : Icons.arrow_forward,
                                color: Colors.white,
                                size: 35,
                              ))),
                    ]),
              ],
            ))
      ],
    ));
  }
}
