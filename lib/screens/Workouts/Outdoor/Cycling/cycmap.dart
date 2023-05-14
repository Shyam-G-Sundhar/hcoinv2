// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';
import 'package:hcoinv2/screens/Workouts/Outdoor/Cycling/cycfinish.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CycMap extends StatefulWidget {
  const CycMap({super.key, required this.distancelimit});
  final int distancelimit;
  @override
  State<CycMap> createState() => _CycMapState();
}

class _CycMapState extends State<CycMap> {
  Position? _previousPosition2;
  Position? _currentPosition2;
  DistanceStream _distanceStream = DistanceStream();
  StreamSubscription<double>? _distanceSubscription;
  StreamController<double>? _distanceStreamController;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  GoogleMapController? _mapController;
  Position? _startingPosition;
  Position? _previousPosition;
  Position? _currentPosition;
  bool _isTracking = false;
  Marker? _startMarker;
  Marker? _previousMarker;
  List<LatLng> _polylineCoordinates = [];
  Polyline? _polyline;
  Marker? _currentMarker;
  Set<Marker> _markers = {};
  late DateTime starttime;
  late DateTime endtime;
  double _totalDistance = 0.0;
  bool ispause = false;
  bool _isAlertShown = false;
  bool _isSppedAlert = false;
  @override
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTracking();
    _getCurrentlocation();
    _getCurrentSpeed();

    starttime = DateTime.now();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    if (_mapController != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
      ));
    }
  }

  Position? _position;
  bool _isLoading = true;
  Weather? _weather;
  Future<void> _getCurrentlocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _position = position;
      });
      await _getCurrentWeather();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _getCurrentWeather() async {
    final latitude = _position!.latitude;
    final longitude = _position!.longitude;
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

  void finishwrk() {
    setState(() {
      endtime = DateTime.now();
    });
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _previousPosition2 = position;
      _currentPosition2 = position;
    });
  }

  void _onPositionChanged(Position newPosition) {
    setState(() {
      _previousPosition2 = _currentPosition;
      _currentPosition2 = newPosition;
    });
    _distanceStream.calculateDistance(_previousPosition2!, _currentPosition2!);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    _distanceStream.dispose();
    _distanceSubscription!.cancel();
    _distanceStreamController!.close();
    await _stopWatchTimer.dispose();
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
  }

  void _startTracking() async {
    try {
      _startingPosition = await Geolocator.getCurrentPosition();
      _updateMarkers(
          _startingPosition!, _startingPosition!, _startingPosition!);
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(_startingPosition!.latitude, _startingPosition!.longitude),
          zoom: 15,
        ),
      ));
    } catch (e) {
      print('Error getting starting position: $e');
    }

    setState(() {
      _isTracking = true;
      ispause = false;
    });

    Geolocator.getPositionStream().listen((Position position) {
      if (ispause) {
        return;
      }

      setState(() {
        _previousPosition = _currentPosition;
        _currentPosition = position;
        _updateMarkers(
            _startingPosition!, _previousPosition!, _currentPosition!);
        if (!ispause) {
          _updatePolyline(_previousPosition!, _currentPosition!);
        }
      });
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ));
      }

      if (_previousPosition != null) {
        final distance = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        setState(() {
          _totalDistance += distance;

          _polylineCoordinates.add(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude));

          _polyline = Polyline(
            polylineId: const PolylineId('tracking'),
            color: Colors.blue,
            points: _polylineCoordinates,
          );
        });
      }
      if (!_isAlertShown && (_totalDistance / 1000) >= widget.distancelimit) {
        _isAlertShown = true;
        finishwrk();
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        showDialog(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(320.0)),
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      height: 270.h,
                      width: double.infinity.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '''You Have Reached the ${widget.distancelimit} km Limit the Following Distance will not taken in the account, Is It ok for u ?''',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.reemKufi(
                                  fontSize: 15.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                      width: 140.w,
                                      height: 65.h,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: InkWell(
                                          onTap: () async {
                                            finishwrk();
                                            _stopWatchTimer.onExecute
                                                .add(StopWatchExecute.stop);
                                            final now = DateTime.now();
                                            final date =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(now);
                                            finishwrk();
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'Coins': FieldValue.increment(2)
                                            });
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('OutdoorWorkouts')
                                                .doc(date)
                                                .set(
                                                    {},
                                                    SetOptions(
                                                        merge:
                                                            true)).then((e) => {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                        ..collection(
                                                                'OutdoorWorkouts')
                                                            .doc(date)
                                                            .collection(
                                                                'Cycling')
                                                            .doc()
                                                            .set({
                                                          'Mode': 'Cycling',
                                                          'Distance': (widget
                                                                      .distancelimit <
                                                                  (_totalDistance /
                                                                      1000))
                                                              ? double.parse(widget
                                                                  .distancelimit
                                                                  .toStringAsFixed(
                                                                      2))
                                                              : double.parse(
                                                                  (_totalDistance /
                                                                          1000)
                                                                      .toStringAsFixed(
                                                                          2)),
                                                          'Starttime': starttime
                                                              .toIso8601String(),
                                                          'Endtime': endtime
                                                              .toIso8601String(),
                                                          'Speed': _speed,
                                                          'Workout': FieldValue
                                                              .increment(1),
                                                          'Coins':
                                                              int.parse('0'),
                                                          'Time': _displayTime,
                                                        })
                                                    });

                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CycFinish(
                                                              starttime:
                                                                  starttime,
                                                              endtime: endtime,
                                                              speed: _speed
                                                                  .toStringAsFixed(
                                                                      2),
                                                              distance: (widget
                                                                          .distancelimit <
                                                                      (_totalDistance /
                                                                          1000))
                                                                  ? widget
                                                                      .distancelimit
                                                                  : (_totalDistance /
                                                                          1000)
                                                                      .toStringAsFixed(
                                                                          2),
                                                              time:
                                                                  _displayTime,
                                                              temp: _weather!
                                                                  .temp,
                                                              desc: _weather!
                                                                  .description,
                                                            )));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.blue,
                                            child: Text(
                                              "Finish",
                                              style: GoogleFonts.reemKufi(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.sp,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                      width: 120.w,
                                      height: 45.h,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _stopWatchTimer.onExecute
                                                .add(StopWatchExecute.start);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.blue,
                                            child: Text(
                                              "OK",
                                              style: GoogleFonts.reemKufi(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.sp,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
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
                  ])),
            );
          },
        );
      }
      if (!_isSppedAlert && (_speed) >= 18.0) {
        _isSppedAlert = true;
        finishwrk();
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        showDialog(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(320.0)),
                  child: Stack(children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        height: 270.h,
                        width: double.infinity.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'You have Exceeded the Speed Limit',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.reemKufi(
                                  fontSize: 20.sp, fontWeight: FontWeight.w300),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                    width: 120.w,
                                    height: 45.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home()),
                                                  (route) => false);
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.stop);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.blue,
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.reemKufi(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20.sp,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )),
                  ])),
            );
          },
        );
      }
    });
  }

  double _speed = 0.0;
  StreamSubscription<Position>? _positionStreamSubscription;
  Future<void> _getCurrentSpeed() async {
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position position) {
      double speed = position.speed * 3.6; // Convert m/s to km/h
      setState(() {
        _speed = speed;
      });
    });
  }

  Future<double> getdistance() async {
    Geolocator.getPositionStream().listen((Position position) {
      if (ispause) {
        return;
      }

      setState(() {
        _previousPosition = _currentPosition;
        _currentPosition = position;
        _updateMarkers(
            _startingPosition!, _previousPosition!, _currentPosition!);
        if (!ispause) {
          _updatePolyline(_previousPosition!, _currentPosition!);
        }
      });
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ));
      }
      if (_previousPosition != null) {
        final distance = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        setState(() {
          _totalDistance += distance;

          _polylineCoordinates.add(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude));

          _polyline = Polyline(
            polylineId: const PolylineId('tracking'),
            color: Colors.blue,
            points: _polylineCoordinates,
          );
        });
      }
    });

    return _totalDistance;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _updateMarkers(Position start, Position previous, Position current) {
    _markers.clear();

    _startMarker = Marker(
      markerId: const MarkerId('start'),
      position: LatLng(start.latitude, start.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: 'Start',
      ),
    );

    if (previous != null) {
      _previousMarker = Marker(
        markerId: const MarkerId('previous'),
        position: LatLng(previous.latitude, previous.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Previous',
        ),
      );
    }

    _currentMarker = Marker(
      markerId: const MarkerId('current'),
      position: LatLng(current.latitude, current.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(
        title: 'Current',
      ),
    );

    setState(() {
      _markers.add(_startMarker!);
      if (_previousMarker != null) {
        _markers.add(_previousMarker!);
      }
      _markers.add(_currentMarker!);
      if (_previousPosition != null) {
        _updatePolyline(_previousPosition!, _currentPosition!);
      }
    });
  }

  void _updatePolyline(Position previous, Position current) {
    if (previous == null) {
      return;
    }
    _polylineCoordinates.add(LatLng(current.latitude, current.longitude));

    _polyline = Polyline(
      polylineId: const PolylineId('tracking'),
      color: Colors.red,
      width: 5,
      points: _polylineCoordinates,
    );

    setState(() {});
  }

  late int _time;
  late String _displayTime;
  void togg() {
    setState(() {
      ispause = true;
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    });
  }

  void revtogg() {
    setState(() {
      ispause = false;
      // ignore: deprecated_member_use
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
  }

  @override
  Widget build(BuildContext context) {
    double distimehrs1 = 0;
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white60,
          toolbarHeight: 100.h,
          elevation: 0,
          leadingWidth: 150.w,
          leading: SizedBox(
            height: 144.h,
            child: Padding(
                padding: EdgeInsets.only(top: 28.w),
                child: Padding(
                    padding: EdgeInsets.only(left: 18.0.w),
                    child: Text(
                      'Cycling',
                      style: GoogleFonts.reemKufi(
                          fontSize: 28.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ))),
          ),
          actions: [
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
                    return const Text('Loading...');
                  }
                  String gender = snapshot.data!.get('gender');
                  return gender == 'Female'
                      ? Image.asset(
                          'assets/girlcyc.png',
                          width: 55.w,
                          height: 55.h,
                          alignment: Alignment.center,
                        )
                      : Image.asset(
                          'assets/boycyc.png',
                          width: 55.w,
                          height: 55.h,
                          alignment: Alignment.center,
                        );
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                  polylines:
                      Set<Polyline>.of(_polyline != null ? [_polyline!] : []),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 20,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 205.h,
                    width: double.infinity.w,
                    color: const Color.fromARGB(224, 224, 224, 224),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0.w),
                            child: Text('Total Duration',
                                style: GoogleFonts.reemKufi(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold)),
                          ),
                          StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snap) {
                                _time = snap.data!;
                                _displayTime = StopWatchTimer
                                        .getDisplayTimeHours(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeMinute(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeSecond(_time);
                                String hours = _displayTime.split(':')[0];
                                String minutes = _displayTime.split(':')[1];
                                String seconds = _displayTime.split(':')[2];
                                double distimehrs2 = int.parse(hours) +
                                    (int.parse(minutes) / 60) +
                                    (int.parse(seconds) / 3600);

                                return Padding(
                                  padding: EdgeInsets.only(top: 3.0.w),
                                  child: Text(
                                      '${StopWatchTimer.getDisplayTimeHours(_time)}:${StopWatchTimer.getDisplayTimeMinute(_time)}:${StopWatchTimer.getDisplayTimeSecond(_time)}',
                                      //'${(_totalDistance / 1000).toStringAsFixed(2)} km',
                                      style: GoogleFonts.reemKufi(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600)),
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Speed',
                                    style: GoogleFonts.reemKufi(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    _speed.toStringAsFixed(2),
                                    style: GoogleFonts.reemKufi(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Distance',
                                    style: GoogleFonts.reemKufi(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    (_totalDistance / 1000).toStringAsFixed(2),
                                    style: GoogleFonts.reemKufi(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              /*   StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(_auth.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SpinKitRipple(
                                        color: Colors.blue,
                                        size: 45,
                                        duration: Duration(seconds: 2),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      int weight =
                                          snapshot.data?.get('weight') ?? 0.0;
                                      double calorie =
                                          8.0 * weight * distimehrs1;
                                      return StreamBuilder<int>(
                                          stream: _stopWatchTimer.rawTime,
                                          initialData: 0,
                                          builder: (context, snapshot) {
                                            _time = snapshot.data!;
                                            _displayTime = StopWatchTimer
                                                    .getDisplayTimeHours(
                                                        _time) +
                                                ":" +
                                                StopWatchTimer
                                                    .getDisplayTimeMinute(
                                                        _time) +
                                                ":" +
                                                StopWatchTimer
                                                    .getDisplayTimeSecond(
                                                        _time);
                                            String hours =
                                                _displayTime.split(':')[0];
                                            String minutes =
                                                _displayTime.split(':')[1];
                                            String seconds =
                                                _displayTime.split(':')[2];
                                            double distimehrs2 =
                                                int.parse(hours) +
                                                    (int.parse(minutes) / 60) +
                                                    (int.parse(seconds) / 3600);
                                            double calorie =
                                                8.0 * weight * distimehrs2;
                                           return Column(
                                              children: [
                                                Text(
                                                  'Calorie',
                                                  style: GoogleFonts.reemKufi(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  '0',
                                                  style: GoogleFonts.reemKufi(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            );
                                          });
                                    }
                                  })*/
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _isTracking && !ispause
                                  ? pauseButton()
                                  : resumebutton(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 130.w,
                                    height: 45.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final now = DateTime.now();
                                          final date = DateFormat('yyyy-MM-dd')
                                              .format(now);
                                          finishwrk();
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'Coins': FieldValue.increment(2)
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('OutdoorWorkouts')
                                              .doc(date)
                                              .set(
                                                  {},
                                                  SetOptions(
                                                      merge:
                                                          true)).then((e) => {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                      ..collection(
                                                              'OutdoorWorkouts')
                                                          .doc(date)
                                                          .collection('Cycling')
                                                          .doc()
                                                          .set({
                                                        'Mode': 'Cycling',
                                                        'Distance': (widget
                                                                    .distancelimit <
                                                                (_totalDistance /
                                                                    1000))
                                                            ? double.parse(widget
                                                                .distancelimit
                                                                .toStringAsFixed(
                                                                    2))
                                                            : double.parse(
                                                                (_totalDistance /
                                                                        1000)
                                                                    .toStringAsFixed(
                                                                        2)),
                                                        'Starttime': starttime
                                                            .toIso8601String(),
                                                        'Endtime': endtime
                                                            .toIso8601String(),
                                                        'Speed': _speed,
                                                        'Workout': FieldValue
                                                            .increment(1),
                                                        'Coins': int.parse('0'),
                                                        'Time': _displayTime,
                                                      })
                                                  });

                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CycFinish(
                                                        starttime: starttime,
                                                        endtime: endtime,
                                                        speed: _speed
                                                            .toStringAsFixed(2),
                                                        distance: (widget
                                                                    .distancelimit <
                                                                (_totalDistance /
                                                                    1000))
                                                            ? widget
                                                                .distancelimit
                                                            : (_totalDistance /
                                                                    1000)
                                                                .toStringAsFixed(
                                                                    2),
                                                        time: _displayTime,
                                                        temp: _weather!.temp,
                                                        desc: _weather!
                                                            .description,
                                                      )));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.blue,
                                          child: Text(
                                            "Finish",
                                            style: GoogleFonts.reemKufi(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 30,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
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
      ),
    );
  }

  Widget pauseButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          width: 130.w,
          height: 45.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: GestureDetector(
              onTap: () {
                togg();
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                child: Text(
                  "Pause",
                  style: GoogleFonts.reemKufi(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )),
    );
  }

  Widget resumebutton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          width: 130.w,
          height: 45.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: GestureDetector(
              onTap: () {
                revtogg();
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey,
                child: Text(
                  "Resume",
                  style: GoogleFonts.reemKufi(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )),
    );
  }
}

class DistanceStream {
  final StreamController<double> _distanceStreamController =
      StreamController<double>();
  Stream<double> get distanceStream => _distanceStreamController.stream;

  void calculateDistance(
      Position previousPosition, Position currentPosition) async {
    double distanceInMeters = await Geolocator.distanceBetween(
      previousPosition.latitude,
      previousPosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    _distanceStreamController.add(distanceInMeters);
  }

  void dispose() {
    _distanceStreamController.close();
  }
}

class Weather {
  final String description;
  final double temp;
  final double feelsLike;
  final double low;
  final String city;
  final double high;

  Weather({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.low,
    required this.high,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toDouble(),
      city: json['name'],
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}
