import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Workouts/Outdoor/Cycling/cycmap.dart';

class CyclingLimit extends StatefulWidget {
  const CyclingLimit({super.key});

  @override
  State<CyclingLimit> createState() => _CyclingLimitState();
}

class _CyclingLimitState extends State<CyclingLimit> {
  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void decrementCounter() {
    setState(() {
      if (counter <= 0) {
      } else {
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    return SafeArea(
        child: Scaffold(
            body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                  String gender = snapshot.data!.get('gender');
                  return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(children: [
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
                          height: 45.h,
                        ),
                        gender == 'Female'
                            ? Image.asset(
                                'assets/girlcycbig.png',
                                width: 225.w,
                                height: 225.h,
                                alignment: Alignment.center,
                              )
                            : Image.asset(
                                'assets/boycycbig.png',
                                width: 225.w,
                                height: 225.h,
                                alignment: Alignment.center,
                              ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Cycling',
                          style: GoogleFonts.reemKufi(
                              fontSize: 32.sp, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Target Distance',
                          style: GoogleFonts.reemKufi(
                              fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: IconButton(
                                alignment: Alignment.center,
                                onPressed: () {
                                  decrementCounter();
                                },
                                icon: const Icon(
                                  Icons.minimize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '$counter km',
                              style: GoogleFonts.reemKufi(
                                  fontSize: 45, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: IconButton(
                                  style: const ButtonStyle(),
                                  onPressed: () {
                                    incrementCounter();
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CycMap(
                                                  distancelimit: counter,
                                                )));
                                  },
                                  child: Container(
                                      color: Colors.white,
                                      width: 150,
                                      height: 65,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CycMap(
                                                          distancelimit:
                                                              counter,
                                                        )));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.blue,
                                            child: Text(
                                              "Start",
                                              style: GoogleFonts.reemKufi(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 30,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]));
                })));
  }
}
