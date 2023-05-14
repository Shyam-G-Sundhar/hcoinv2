import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class WalkFinish extends StatefulWidget {
  const WalkFinish(
      {super.key,
      required this.starttime,
      required this.endtime,
      this.time,
      this.speed,
      this.distance,
      this.temp,
      this.desc});
  final DateTime starttime;
  final DateTime endtime;
  //ignore: prefer_typing_uninitialized_variables
  final time, speed, distance, temp, desc;
  @override
  State<WalkFinish> createState() => _WalkFinishState();
}

class _WalkFinishState extends State<WalkFinish> {
  String? _displayTime;
  double? _totalTimeInHours;
  double? caloriesBurned;
  final _screenshotController = ScreenshotController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _displayTime = widget.time;
    _calculateTime();
  }

  void _calculateTime() {
    List<String> timeParts = _displayTime!.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    int totalTimeInSeconds = hours * 3600 + minutes * 60 + seconds;
    _totalTimeInHours = totalTimeInSeconds / 3600;
  }

  void calculateCaloriesBurned(double timeInMinutes) {
    double metValue = 9.0; // MET value for running at 9-minute mile pace
    double bodyWeight = 0; // Body weight in kilograms
    double timeInHours =
        timeInMinutes / 60.0; // Convert time from minutes to hours
    double caloriesPerHour = metValue * bodyWeight; // Calories burned per hour
    double caloriesBurned =
        caloriesPerHour * timeInHours; // Total calories burned
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm:ss');
    final duration = widget.endtime.difference(widget.starttime);
    final durationFormatted = timeFormat.format(
        DateTime(0, 0, 0, 0, duration.inMinutes, duration.inSeconds % 60));

    String getWeatherImageAsset(String description) {
      if (description.toLowerCase().contains('cloud')) {
        return 'assets/bgcl.png';
      } else if (description.toLowerCase().contains('rain')) {
        return 'assets/rcl.png';
      } else if (description.toLowerCase().contains('sun')) {
        return 'assets/sun.png';
      } else if (description.toLowerCase().contains('clear')) {
        return 'assets/clrsky.png';
      } else {
        return 'assets/clrsky.png';
      }
    }

    void _takeScreenshot() async {
      final uint8List = await _screenshotController.capture();
      String tempPath = (await getTemporaryDirectory()).path;
      String fileName = "screen";
      File file = await File('$tempPath/$fileName.png').create();
      await file.writeAsBytes(uint8List!);
      // ignore: deprecated_member_use
      Share.shareFiles([file.path]);
    }

    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Screenshot(
          controller: _screenshotController,
          child: Padding(
            padding: EdgeInsets.all(25.0.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.arrow_back,
                          size: 35,
                        ),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false);
                        },
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        'Walking',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return Text('Loading...');
                        }
                        String gender = snapshot.data!.get('gender');
                        return gender == 'Female'
                            ? Image.asset(
                                'assets/girlwlkbig.png',
                                width: 225.w,
                                height: 225.h,
                                alignment: Alignment.center,
                              )
                            : Image.asset(
                                'assets/boywlkbig.png',
                                width: 225.w,
                                height: 225.h,
                                alignment: Alignment.center,
                              );
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 190.h,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(25.w)),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0.w, vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormat('EEEE').format(widget.starttime)}, ${widget.starttime.day}, ${DateFormat('MMMM').format(widget.starttime)} \n${DateFormat('hh:mm a').format(widget.starttime)} - ${DateFormat('hh:mm a').format(widget.endtime)}',
                                style: GoogleFonts.reemKufi(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: Colors.white),
                              ),
                              InkWell(
                                child: IconButton(
                                    onPressed: () {
                                      _takeScreenshot();
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      weight: 15,
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Text(
                            '${widget.distance} Km',
                            style: GoogleFonts.reemKufi(
                                fontSize: 35.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 19.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${widget.time}',
                              style: GoogleFonts.reemKufi(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              '${widget.speed} km/h',
                              style: GoogleFonts.reemKufi(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0.w, vertical: 10.0.h),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Workout Details',
                        style: GoogleFonts.reemKufi(
                            fontSize: 20.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0.w),
                    child: Container(
                      height: 225.h,
                      width: double.infinity.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.w),
                          color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.all(15.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Workout Duration',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Distance',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Avg Speed',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Mode',
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Walking',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Earned Coins',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Coins',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Weather',
                        style: GoogleFonts.reemKufi(
                            fontSize: 20.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    width: double.infinity.w,
                    height: 185.h,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(32.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              getWeatherImageAsset(
                                widget.desc,
                              ),
                              height: 90.h,
                              width: 90.h,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${widget.temp} °C',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  '${widget.desc}',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  /* Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0.h),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Notes',
                        style: GoogleFonts.reemKufi(
                            fontSize: 20.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 15.h,
                  ),
                  /* Container(
                      width: double.infinity.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          
                          ),
                      child: Column(
                        children: [TextFormField()],
                      ))*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}