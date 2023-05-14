import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Profile/abt.dart';
import 'package:hcoinv2/screens/Profile/editprf.dart';
import 'package:hcoinv2/screens/Profile/history.dart';
import 'package:hcoinv2/screens/Profile/invfrd.dart';
import 'package:hcoinv2/screens/Wallet/sethpin.dart';
import 'package:hcoinv2/screens/Wallet/wlthome.dart';
import 'package:hcoinv2/screens/Workouts/Indoor/indoor.dart';
import 'package:hcoinv2/screens/splash%20screen/getscreens/getscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Workouts/Outdoor/outdoor.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userName = '';

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  Location location = Location();
  PermissionStatus? _permissionGranted;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkPermission();
    Timer.periodic(Duration(seconds: 1), (timer) {});
  }

  Future<void> _checkPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // Handle denied permission
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      // Handle denied permission permanently
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _position = position;
      });
      await _getCurrentWeather();
    } catch (error) {
      print(error);
    }
  }

  bool _isLoading = true;
  Weather? _weather;
  late Position _position;
  Future<void> _getCurrentWeather() async {
    final latitude = _position.latitude;
    final longitude = _position.longitude;
    final apiKey = "33f3e9a1ca621c56313222021b8499cb";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _weather = Weather.fromJson(jsonDecode(response.body));
          _isLoading = false;
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (error) {
      print('Failed to load weather data');
    }
  }

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

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const WalletPage(),
    const ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white60,
          toolbarHeight: 100,
          elevation: 0,
          leadingWidth: 100,
          leading: SizedBox(
            height: 144,
            child: Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: const AssetImage(
                        'assets/logo.png',
                      ),
                      width: 150.w,
                      height: 150.h,
                    ),
                  ),
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(320.0)),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 4.w),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              height: 450,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(right: 18.0.w),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: 18.0.h),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    FutureBuilder(
                                      builder: (context, snapshot) {
                                        // ignore: unnecessary_null_comparison
                                        if (snapshot != null) {
                                          // ignore: unnecessary_null_comparison
                                          if (_weather == null) {
                                            return const Center(
                                              child: SpinKitRipple(
                                                color: Colors.blue,
                                                size: 45,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            _getCurrentLocation();
                                            return Cloud(_weather!);
                                          }
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                      future: _getCurrentLocation(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: _isLoading
                    ? const Center(
                        child: SpinKitRipple(
                          color: Colors.blue,
                          size: 45,
                          duration: Duration(seconds: 2),
                        ),
                      )
                    : Image.asset(
                        getWeatherImageAsset(_weather!.description),
                        height: 30,
                        width: 30,
                      ),
              ),
            )
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex)
        /*SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 35,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/girlprf.png',
                  width: 180,
                  height: 180,
                ),
              ),
              Text(
                '@username',
                style: GoogleFonts.reemKufi(
                    fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),*/
        ,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget Cloud(Weather _weather) {
    return _isLoading
        ? const Center(
            child: SpinKitRipple(
              color: Colors.blue,
              size: 45,
              duration: Duration(seconds: 2),
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 120.h,
                width: 150.w,
                child: Image.asset(
                  getWeatherImageAsset(_weather.description),
                ),
              ),
              Text(
                // ignore: unnecessary_null_comparison
                _weather.temperature == null
                    ? 'Loading'
                    : '${_weather.temperature}°C',
                textAlign: TextAlign.center,
                style: GoogleFonts.reemKufi(
                    color: Colors.blue,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  // ignore: unnecessary_null_comparison
                  _weather.description == null
                      ? 'Loading'
                      : '${_weather.description}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.reemKufi(
                      color: Colors.blue,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(left: 4.0.w),
                child: SizedBox(
                  height: 150.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/location.jpg'),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          (_weather.cityName == null)
                              ? 'Loading'
                              : '${_weather.cityName}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.reemKufi(
                              color: Colors.blue,
                              fontSize: 33.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }
}

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int conditionCode;
  Weather({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.conditionCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];
    final temperature = json['main']['temp'];
    final description = json['weather'][0]['description'];
    final conditionCode = json['weather'][0]['id'];
    return Weather(
        cityName: cityName,
        temperature: temperature,
        description: description,
        conditionCode: conditionCode);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  double _totalDistance = 0;
  int _totalCoinsoneday = 0;
  double? totcoin;
  int _streakCount = 0;
  late FirebaseMessaging messaging;
  String _messageText = '';
  Location location = Location();
  PermissionStatus? _permissionGranted;
  void initState() {
    // TODO: implement initState
    _getStreakCount();
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Request permission for receiving notifications
    FirebaseMessaging.instance.requestPermission();

    // Configure the app to handle notifications that were opened from a background state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Handle the initial message
        print(
            'Opened app from FCM notification (initial): ${message.notification?.title}');
      }
    });

    // Configure the app to listen for incoming messages and update the UI with the message text
    FirebaseMessaging.onMessage.listen((message) {
      // Handle the incoming message
      print('FCM notification received: ${message.notification?.body}');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? 'Notification'),
          content: Text(message.notification?.body ?? ''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });

    // Configure the app to handle notifications that were opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle the message opened from a terminated state
      print(
          'Opened app from FCM notification (terminated): ${message.notification?.title}');
    });
/*
    // Request permission for receiving push notifications
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);

    // Configure the app to handle notifications that were opened from a background state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
            'Opened app from FCM notification (initial): ${message.notification?.title}');
      }
    });*/

    // Configure the app to listen for incoming messages and update the UI with the message text
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messageText = message.notification?.body ?? '';
      });
    });
  }

  Future<int> getCombinedDistance() async {
    QuerySnapshot runningSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('OutdoorWorkouts')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('Cycling')
        .get();
    QuerySnapshot walkingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('OutdoorWorkouts')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('Running')
        .get();
    QuerySnapshot cyclingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('OutdoorWorkouts')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .collection('Walking')
        .get();

    int disSum = 0;
    runningSnapshot.docs.forEach((doc) {
      int dis = doc.get('Distance');
      disSum += dis ?? 0;
    });
    walkingSnapshot.docs.forEach((doc) {
      int dis = doc.get('Distance');
      disSum += dis ?? 0;
    });
    cyclingSnapshot.docs.forEach((doc) {
      int dis = doc.get('Distance');
      disSum += dis ?? 0;
    });

    return disSum;
  }

  void _getStreakCount() async {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final todayDateString = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayDateString = DateFormat('yyyy-MM-dd').format(yesterday);

    final todayStreakSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('streaks')
        .doc(todayDateString)
        .get();
    final yesterdayStreakSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('streaks')
        .doc(yesterdayDateString)
        .get();

    final todayExists = todayStreakSnapshot.exists;
    final yesterdayExists = yesterdayStreakSnapshot.exists;

    setState(() {
      if (todayExists && yesterdayExists) {
        // If both today and yesterday documents exist, then the streak continues
        _streakCount = yesterdayStreakSnapshot.data()!['count'] + 1;
      } else if (todayExists) {
        // If only today document exists, then it's the first day of the streak
        _streakCount = 1;
      } else {
        // If neither today nor yesterday documents exist, then the streak is broken
        _streakCount = 0;
      }
    });

    // Update or create today's streak document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('streaks')
        .doc(todayDateString)
        .set({'count': _streakCount});
  }

  Future<void> _checkPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      // Handle denied permission
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      // Handle denied permission permanently
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 35,
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
                String gender = snapshot.data!.get('gender');
                return Container(
                  alignment: Alignment.topCenter,
                  child: gender == 'Female'
                      ? Image.asset(
                          'assets/girlprf.png',
                          width: 180,
                          height: 180,
                        )
                      : Image.asset(
                          'assets/boyprf.png',
                          width: 180,
                          height: 180,
                        ),
                );
              }),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                String username = snapshot.data!.get('username');
                return Text(
                  snapshot != null ? username : 'Loading',
                  style: GoogleFonts.reemKufi(
                      fontSize: 25, fontWeight: FontWeight.w600),
                );
              }),
          const SizedBox(
            height: 15,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(224, 224, 224, 224),
                      borderRadius: BorderRadius.circular(25)),
                  width: MediaQuery.of(context).size.width,
                  height: 139.h,
                  child: FutureBuilder(
                      future: Future.wait([
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('OutdoorWorkouts')
                            .doc(
                                DateFormat('yyyy-MM-dd').format(DateTime.now()))
                            .collection('Cycling')
                            .get(),
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('OutdoorWorkouts')
                            .doc(
                                DateFormat('yyyy-MM-dd').format(DateTime.now()))
                            .collection('Walking')
                            .get(),
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('OutdoorWorkouts')
                            .doc(
                                DateFormat('yyyy-MM-dd').format(DateTime.now()))
                            .collection('Running')
                            .get(),
                      ]),
                      builder: (context,
                          AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                        if (snapshot.hasError) {
                          // If the future completes with an error, display an error message
                          return CircularProgressIndicator();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: SpinKitRipple(
                            color: Colors.blue,
                            size: 45,
                            duration: Duration(seconds: 2),
                          ));
                        }
                        double cyclingDistance = 0;
                        double walkingDistance = 0;
                        double runningDistance = 0;
                        double cyclingCoins = 0;
                        double walkingCoins = 0;
                        double runningCoins = 0;
                        final snn = snapshot.data!;
                        if (snapshot.hasData) {
                          for (var querySnapshot in snn) {
                            querySnapshot.docs.forEach((doc) {
                              if (querySnapshot == snapshot.data?[0]) {
                                // Cycling
                                cyclingDistance += doc['Distance'] ?? 0;
                                cyclingCoins += doc['Coins'] ?? 0;
                              } else if (querySnapshot == snapshot.data?[1]) {
                                // Walking
                                walkingDistance += doc['Distance'] ?? 0;
                                walkingCoins += doc['Coins'] ?? 0;
                              } else if (querySnapshot == snapshot.data?[2]) {
                                // Running
                                runningDistance += doc['Distance'] ?? 0;
                                runningCoins += doc['Coins'] ?? 0;
                              } else {
                                runningCoins = walkingCoins = cyclingCoins = 0;
                                runningDistance =
                                    walkingDistance = cyclingDistance = 0;
                              }
                            });
                          }
                        } else {
                          return CircularProgressIndicator();
                        }

                        _totalDistance =
                            cyclingDistance + walkingDistance + runningDistance;
                        _totalCoinsoneday =
                            (cyclingCoins + walkingCoins + runningCoins)
                                    .toInt() ??
                                0;

                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 29),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Image.asset('assets/stk.png'),
                                      Text(
                                        // ignore: unnecessary_null_comparison
                                        snapshot.hasData == null
                                            ? '0'
                                            : '$_streakCount',
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      Text(
                                        'Streaks',
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Image.asset('assets/dloc.png'),
                                      Text(
                                        (snapshot.hasData == null)
                                            ? '0'
                                            : _totalDistance.toStringAsFixed(3),
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      Text(
                                        'Distance',
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Image.asset('assets/hwlt.png'),
                                      Text(
                                        (snapshot.hasData == null)
                                            ? '0'
                                            : _totalCoinsoneday.toString(),
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      Text(
                                        'Coins',
                                        style: GoogleFonts.reemKufi(
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Indoor()));
                  },
                  child: Container(
                    width: 135.w,
                    height: 135.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(224, 224, 224, 224),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/dbell.png'),
                            Text(
                              'Indoor \nWorkouts',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.reemKufi(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Outdoor()));
                  },
                  child: Container(
                    width: 135.w,
                    height: 135.h,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(224, 224, 224, 224),
                        borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/orun.png',
                            ),
                            Text(
                              'Outdoor \nWorkouts',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.reemKufi(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  String gender = snapshot.data!.get('gender');
                  return gender == 'Female'
                      ? Image.asset(
                          'assets/girlwlt.png',
                          width: 350.w,
                          height: 350.h,
                        )
                      : Image.asset(
                          'assets/boywlt.png',
                          width: 350.w,
                          height: 350.h,
                        );
                }),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0.w),
          child: GestureDetector(
            onTap: () {},
            child: Container(
                color: Colors.white,
                width: 200.w,
                height: 55.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Pin()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blue,
                      child: Text(
                        "Open Wallet",
                        style: GoogleFonts.reemKufi(
                            fontWeight: FontWeight.w700,
                            fontSize: 30.sp,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    ));
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isNotify = false;
  bool isShowSwitch = false;
  String _messageText = '';
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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

            String username = snapshot.data!.get('username');
            String name = snapshot.data!.get('name');
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 12.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: gender == 'Female'
                      ? Image.asset(
                          'assets/girlprf.png',
                          width: 180,
                          height: 180,
                        )
                      : Image.asset(
                          'assets/boyprf.png',
                          width: 180,
                          height: 180,
                        ),
                ),
                Text(
                  snapshot.data != null ? name : 'Loading',
                  style: GoogleFonts.reemKufi(
                      fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  snapshot.data != null ? username : 'Loading',
                  style: GoogleFonts.reemKufi(
                      fontSize: 22.sp, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Container(
                      color: Colors.white,
                      width: 150.w,
                      height: 50.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EditPrf()));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            child: Text(
                              "Edit Profile",
                              style: GoogleFonts.reemKufi(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.sp,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => History())));
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          ))
                    ],
                  ),
                ),
                /* SizedBox(
                  height: 15.0.h,
                ),
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w700),
                      ),
                      Switch(
                        value: isShowSwitch,
                        onChanged: (value) {
                          setState(
                            () {
                              isShowSwitch = value;
                              print(isShowSwitch);
                            },
                          );
                        },
                        activeTrackColor: Colors.lightBlue,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 15.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invite A Friend',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Invite()));
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'About',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Abt()));
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Logout',
                        style: GoogleFonts.reemKufi(
                            fontSize: 25.sp, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(320.0)),
                                      child: Stack(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 4),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          height: 270.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Would you really like to Logout?',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.reemKufi(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: SizedBox(
                                                          width: 120.w,
                                                          height: 45.h,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45),
                                                            child: InkWell(
                                                              onTap: () {
                                                                _auth.signOut().then((value) => Navigator.of(
                                                                        context)
                                                                    .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const GetScreen()),
                                                                        (route) =>
                                                                            false));
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color:
                                                                    Colors.blue,
                                                                child: Text(
                                                                  "Yes",
                                                                  style: GoogleFonts.reemKufi(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          20.sp,
                                                                      color: Colors
                                                                          .white),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: SizedBox(
                                                          width: 120.w,
                                                          height: 45.h,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color:
                                                                    Colors.blue,
                                                                child: Text(
                                                                  "No",
                                                                  style: GoogleFonts.reemKufi(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          20.sp,
                                                                      color: Colors
                                                                          .white),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ]));
                                });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20.sp,
                          )),
                    ],
                  ),
                )
              ],
            );
          }),
    ));
  }
}
