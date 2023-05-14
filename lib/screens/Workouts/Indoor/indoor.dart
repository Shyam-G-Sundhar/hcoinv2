import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Indoor extends StatefulWidget {
  const Indoor({super.key});

  @override
  State<Indoor> createState() => _IndoorState();
}

class _IndoorState extends State<Indoor> {
  @override
  Widget build(BuildContext context) {
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
                  height: 35,
                ),
                Image.asset('assets/dbellbig.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Indoor Workouts',
                  style: GoogleFonts.reemKufi(
                      fontSize: 35, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*Column(
                      children: [
                        Text(
                          '0',
                          style: GoogleFonts.reemKufi(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Workouts',
                          style: GoogleFonts.reemKufi(
                              fontSize: 23, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),*/
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indoorcard(
                            name: 'Jumping Jacks',
                            iconname: 'jjacks',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Jumping Jacks',
                                        time: 5,
                                        img: 'jjacks',
                                      )));
                            },
                          ),
                          Indoorcard(
                            name: 'Squats',
                            iconname: 'squats',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Squats',
                                        time: 5,
                                        img: 'squats',
                                      )));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indoorcard(
                            name: 'Lunges',
                            iconname: 'lunges',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Lunges',
                                        time: 5,
                                        img: 'lunges',
                                      )));
                            },
                          ),
                          Indoorcard(
                            name: 'Planks',
                            iconname: 'planks',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Planks',
                                        time: 5,
                                        img: 'planks',
                                      )));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indoorcard(
                            name: 'Climbers',
                            iconname: 'mclimb',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Climbers',
                                        time: 5,
                                        img: 'mclimb',
                                      )));
                            },
                          ),
                          Indoorcard(
                            name: 'High Knees',
                            iconname: 'hknees',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'High Knees',
                                        time: 5,
                                        img: 'hknees',
                                      )));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indoorcard(
                            name: 'Burpees',
                            iconname: 'burpees',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Burpees',
                                        time: 5,
                                        img: 'burpees',
                                      )));
                            },
                          ),
                          Indoorcard(
                            name: 'Pushups',
                            iconname: 'pushups',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Pushups',
                                        time: 5,
                                        img: 'pushups',
                                      )));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indoorcard(
                            name: 'Situps',
                            iconname: 'situps',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Situps',
                                        time: 5,
                                        img: 'situps',
                                      )));
                            },
                          ),
                          Indoorcard(
                            name: 'Crunches',
                            iconname: 'crunches',
                            onpre: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Indoorex(
                                        exname: 'Crunches',
                                        time: 5,
                                        img: 'crunches',
                                      )));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Indoorcard extends StatelessWidget {
  const Indoorcard(
      {Key? key,
      required this.name,
      required this.iconname,
      required this.onpre})
      : super(key: key);
  final String name;
  final String iconname;
  final VoidCallback onpre;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      width: 140.w,
      height: 140.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 140.0,
            height: 140,
            child: GestureDetector(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/$iconname.png'),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      name,
                      style: GoogleFonts.reemKufi(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                onPressed: (onpre),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Indoorex extends StatefulWidget {
  const Indoorex({key, this.exname, this.time, this.img});
  final exname;
  final time;
  final img;
  @override
  State<Indoorex> createState() => _IndoorexState();
}

class _IndoorexState extends State<Indoorex> {
  late Timer _timer;
  late Duration _duration;
  bool _isPlaying = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _duration = Duration(seconds: widget.time);
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_duration!.inSeconds == 0) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Indoor()));
      } else {
        setState(() {
          _duration -= Duration(seconds: 1);
        });
      }
    });
  }

  void toggleTimer() {
    if (_isPlaying) {
      _timer.cancel();
    } else {
      startTimer();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void stopTimer() {
    _timer.cancel();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Indoor()));
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /* Widget displayTimerUI({@required String time, @required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(time,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 45)),
          ),
          SizedBox(height: 30),
          Text(header, style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      );
*/
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                width: 250.w,
                height: 300.h,
                decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid, width: 6, color: Colors.blue),
                    borderRadius: BorderRadius.circular(32.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/${widget.img}.png'),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      widget.exname,
                      style: GoogleFonts.reemKufi(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDuration(_duration),
                    style: GoogleFonts.reemKufi(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(
                            side: BorderSide(style: BorderStyle.none))),
                    onPressed: () {
                      toggleTimer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(58.0)),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 48,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(
                            side: BorderSide(style: BorderStyle.none))),
                    onPressed: () {
                      stopTimer();
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => Indoor()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(58.0)),
                      child: Icon(
                        Icons.stop,
                        size: 48,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
