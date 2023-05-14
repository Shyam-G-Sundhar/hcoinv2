// ignore_for_file: missing_return

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Workout History',
                      style: GoogleFonts.reemKufi(
                          color: Colors.black,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  height: 700,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('OutdoorWorkouts')
                        //.orderBy('Date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        final documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return const Center(
                            child: Text('No workout history found.'),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                final doc = documents[index];
                                final date = doc.id;
                                return ExpansionTile(
                                  title: Text(date.toString()),
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('OutdoorWorkouts')
                                          .doc(date)
                                          .collection('Cycling')
                                          .orderBy('Endtime', descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          final cyclingDocuments =
                                              snapshot.data!.docs;
                                          if (cyclingDocuments.isEmpty) {
                                            return const Center(
                                              child: Text(''),
                                            );
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount:
                                                  cyclingDocuments.length,
                                              itemBuilder: (context, index) {
                                                final cyclingDoc =
                                                    cyclingDocuments[index];
                                                final start = DateTime.parse(
                                                    cyclingDoc['Starttime']);
                                                final end = DateTime.parse(
                                                    cyclingDoc['Endtime']);
                                                final formattedStart = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(start);
                                                final formattedEnd = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(end);

                                                return ListTile(
                                                  title: const Text('Cycling'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                          'Start time: $formattedStart'),
                                                      Text(
                                                          'End time: $formattedEnd'),
                                                      Text(
                                                          'Distance: ${cyclingDoc['Distance']} km'),
                                                      Text(
                                                          'Time: ${cyclingDoc['Time']}'),
                                                      Text(
                                                          'Speed: ${cyclingDoc['Speed']} km/h'),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('OutdoorWorkouts')
                                          .doc(date)
                                          .collection('Running')
                                          .orderBy('Endtime', descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          final runningDocuments =
                                              snapshot.data!.docs;
                                          if (runningDocuments.isEmpty) {
                                            return const Center(
                                              child: Text(''),
                                            );
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount:
                                                  runningDocuments.length,
                                              itemBuilder: (context, index) {
                                                final runningDoc =
                                                    runningDocuments[index];
                                                final start = DateTime.parse(
                                                    runningDoc['Starttime']);
                                                final end = DateTime.parse(
                                                    runningDoc['Endtime']);
                                                final formattedStart = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(start);
                                                final formattedEnd = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(end);

                                                return ListTile(
                                                  title: const Text('Running'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                          'Start time: $formattedStart'),
                                                      Text(
                                                          'End time: $formattedEnd'),
                                                      Text(
                                                          'Distance: ${runningDoc['Distance']} km'),
                                                      Text(
                                                          'Time: ${runningDoc['Time']}'),
                                                      Text(
                                                          'Speed: ${runningDoc['Speed']} km/h'),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('OutdoorWorkouts')
                                          .doc(date)
                                          .collection('Walking')
                                          .orderBy('Endtime', descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          final walkingDocuments =
                                              snapshot.data!.docs;
                                          if (walkingDocuments.isEmpty) {
                                            return const Center(
                                              child: Text(''),
                                            );
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount:
                                                  walkingDocuments.length,
                                              itemBuilder: (context, index) {
                                                final walkingDoc =
                                                    walkingDocuments[index];
                                                final start = DateTime.parse(
                                                    walkingDoc['Starttime']);
                                                final end = DateTime.parse(
                                                    walkingDoc['Endtime']);
                                                final formattedStart = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(start);
                                                final formattedEnd = DateFormat(
                                                        'MMMM dd, yyyy - HH:mm')
                                                    .format(end);

                                                return ListTile(
                                                  title: const Text('Walking'),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                          'Start time: $formattedStart'),
                                                      Text(
                                                          'End time: $formattedEnd'),
                                                      Text(
                                                          'Distance: ${walkingDoc['Distance']} km'),
                                                      Text(
                                                          'Time: ${walkingDoc['Time']}'),
                                                      Text(
                                                          'Speed: ${walkingDoc['Speed']} km/h'),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
