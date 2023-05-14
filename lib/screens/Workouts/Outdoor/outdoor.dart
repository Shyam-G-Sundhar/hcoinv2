import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Workouts/Outdoor/Cycling/cycdislt.dart';
import 'package:hcoinv2/screens/Workouts/Outdoor/Running/rundislt.dart';
import 'package:intl/intl.dart';

import 'Walking/wlkdislt.dart';

class Outdoor extends StatefulWidget {
  const Outdoor({super.key});

  @override
  State<Outdoor> createState() => _OutdoorState();
}

class _OutdoorState extends State<Outdoor> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> getCombinedWorkouts() async* {
    while (true) {
      QuerySnapshot runningwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Running')
          .get();
      QuerySnapshot walkingwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Walking')
          .get();
      QuerySnapshot cyclingwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Cycling')
          .get();
      int wrkSum = 0;
      runningwrkSnapshot.docs.forEach((doc) {
        int rwrk = doc.get('Workout');
        wrkSum += rwrk ?? 0;
      });
      walkingwrkSnapshot.docs.forEach((doc) {
        int wwrk = doc.get('Workout');
        wrkSum += wwrk ?? 0;
      });
      cyclingwrkSnapshot.docs.forEach((doc) {
        int cwrk = doc.get('Workout');
        wrkSum += cwrk ?? 0;
      });
      yield wrkSum;

      await Future.delayed(Duration(minutes: 1)); // delay for 1 minute
    }
  }

  Stream<int> getCycling() async* {
    while (true) {
      QuerySnapshot cyclingwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Cycling')
          .get();
      int cwrk = 0;

      cyclingwrkSnapshot.docs.forEach((doc) {
        cwrk = doc.get('Workout') ?? 0;
      });
      yield cwrk;

      await Future.delayed(Duration(minutes: 1)); // delay for 1 minute
    }
  }

  Stream<int> getRunning() async* {
    while (true) {
      QuerySnapshot cyclingwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Running')
          .get();
      int rwrk = 0;

      cyclingwrkSnapshot.docs.forEach((doc) {
        rwrk = doc.get('Workout') ?? 0;
      });
      yield rwrk;

      await Future.delayed(Duration(minutes: 1)); // delay for 1 minute
    }
  }

  Stream<int> getWalking() async* {
    while (true) {
      QuerySnapshot cyclingwrkSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('OutdoorWorkouts')
          .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .collection('Walking')
          .get();
      int wwrk = 0;

      cyclingwrkSnapshot.docs.forEach((doc) {
        wwrk = doc.get('Workout') ?? 0;
      });
      yield wwrk;

      await Future.delayed(Duration(minutes: 1)); // delay for 1 minute
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
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
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Image.asset('assets/orunbig.png'),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Outdoor Workouts',
                  style: GoogleFonts.reemKufi(
                      fontSize: 25.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15.h,
                ),
                StreamBuilder<int>(
                    stream: getCombinedWorkouts(),
                    builder: (context, snapshot) {
                      int? wrkout = snapshot.data;
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.hasData ? '$wrkout' : '0',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Workouts',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '0',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Kcal',
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        );
                      }
                      return Container();
                    }),
                SizedBox(
                  height: 15.h,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      String gender = snapshot.data!.get('gender');
                      if (snapshot.hasData) {
                        return Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    StreamBuilder<int>(
                                        stream: getRunning(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          int? wrkout = snapshot.data;
                                          if (snapshot.hasData) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (wrkout! >= 1) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                height: 270.h,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        'Your Quota has finished',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts.reemKufi(
                                                                            fontSize:
                                                                                20.sp,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {},
                                                                        child: SizedBox(
                                                                            width: 120.w,
                                                                            height: 45.h,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(45),
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  color: Colors.blue,
                                                                                  child: Text(
                                                                                    "Ok",
                                                                                    style: GoogleFonts.reemKufi(fontWeight: FontWeight.w700, fontSize: 20.sp, color: Colors.white),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RunningLimit()));
                                                }
                                              },
                                              child: Container(
                                                width: 135.w,
                                                height: 135.h,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        224, 224, 224, 224),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        gender == 'Female'
                                                            ? Image.asset(
                                                                'assets/girlrun.png',
                                                              )
                                                            : Image.asset(
                                                                'assets/boyrun.png',
                                                              ),
                                                        Text(
                                                          'Running',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .reemKufi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            const Center(
                                              child: SpinKitRipple(
                                                color: Colors.blue,
                                                size: 45,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                          return Container();
                                        }),
                                    StreamBuilder<int>(
                                        stream: getWalking(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          int? wrkout = snapshot.data;
                                          if (snapshot.hasData) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (wrkout! >= 1) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                height: 270.h,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        'Your Quota has finished',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts.reemKufi(
                                                                            fontSize:
                                                                                20.sp,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {},
                                                                        child: SizedBox(
                                                                            width: 120.w,
                                                                            height: 45.h,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(45),
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  color: Colors.blue,
                                                                                  child: Text(
                                                                                    "Ok",
                                                                                    style: GoogleFonts.reemKufi(fontWeight: FontWeight.w700, fontSize: 20.sp, color: Colors.white),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WalkingLimit()));
                                                }
                                              },
                                              child: Container(
                                                width: 135.w,
                                                height: 135.h,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        224, 224, 224, 224),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        gender == 'Female'
                                                            ? Image.asset(
                                                                'assets/girlwlk.png',
                                                                width: 85.w,
                                                                height: 85.h,
                                                              )
                                                            : Image.asset(
                                                                'assets/boywlk.png',
                                                                width: 85.w,
                                                                height: 85.h,
                                                              ),
                                                        Text(
                                                          'Walking',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .reemKufi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            const Center(
                                              child: SpinKitRipple(
                                                color: Colors.blue,
                                                size: 45,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                          return Container();
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                StreamBuilder<int>(
                                    stream: getCycling(),
                                    builder:
                                        (context, AsyncSnapshot<int> snapshot) {
                                      int? wrkout = snapshot.data;
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (wrkout! >= 1) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 270.h,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'Your Quota has finished',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts.reemKufi(
                                                                        fontSize: 20
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child: SizedBox(
                                                                        width: 120.w,
                                                                        height: 45.h,
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(45),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              color: Colors.blue,
                                                                              child: Text(
                                                                                "Ok",
                                                                                style: GoogleFonts.reemKufi(fontWeight: FontWeight.w700, fontSize: 20.sp, color: Colors.white),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CyclingLimit()));
                                            }
                                          },
                                          child: Container(
                                            width: 135.w,
                                            height: 135.h,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    224, 224, 224, 224),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    gender == 'Female'
                                                        ? Image.asset(
                                                            'assets/girlcyc.png',
                                                            width: 85.w,
                                                            height: 85.h,
                                                          )
                                                        : Image.asset(
                                                            'assets/boycyc.png',
                                                            width: 85.w,
                                                            height: 85.h,
                                                          ),
                                                    Text(
                                                      'Cycling',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.reemKufi(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        const Center(
                                          child: SpinKitRipple(
                                            color: Colors.blue,
                                            size: 45,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                      return Container();
                                    }),
                              ],
                            )
                          ],
                        );
                      }
                      return Container();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
