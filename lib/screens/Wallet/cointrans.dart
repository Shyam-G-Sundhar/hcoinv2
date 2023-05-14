import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Wallet/hpin.dart';

class CoinTrans extends StatefulWidget {
  const CoinTrans({super.key});

  @override
  State<CoinTrans> createState() => _CoinTransState();
}

class _CoinTransState extends State<CoinTrans> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController acccontroller = TextEditingController();
  GlobalKey<FormState> acckey = GlobalKey<FormState>();
  final TextEditingController reacccontroller = TextEditingController();
  GlobalKey<FormState> reacckey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  GlobalKey<FormState> namekey = GlobalKey<FormState>();
  final TextEditingController coincontroller = TextEditingController();
  GlobalKey<FormState> coinkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0.w),
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
                height: 45.h,
              ),
              Image.asset(
                'assets/ctransbig.png',
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Coin Transfer',
                style: GoogleFonts.reemKufi(
                    fontSize: 30.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                key: acckey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: acccontroller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Phone Number',
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                      prefixIcon: const Icon(
                        Icons.call,
                        size: 25,
                      ),
                      fillColor: Colors.grey[200],
                      hintText: 'Enter Receiver Phone Number',
                      hintStyle: GoogleFonts.reemKufi(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                key: reacckey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: reacccontroller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please receiver phone number';
                    } else if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Phone Number',
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                      prefixIcon: const Icon(
                        Icons.call,
                        size: 25,
                      ),
                      fillColor: Colors.grey[200],
                      hintText: 'Enter Receiver Phone Number',
                      hintStyle: GoogleFonts.reemKufi(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                key: namekey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: namecontroller,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Name';
                    } else if (value.length <= 2) {
                      return 'Please enter a valid 2-characters';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Name',
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.grey[200],
                      hintText: 'Enter The Receiver name',
                      hintStyle: GoogleFonts.reemKufi(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Form(
                key: coinkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: coincontroller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Coins';
                    } else if (value.length != 0 && value == 0) {
                      return 'Please enter a valid 10-digit phone number';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Coins',
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                      prefixIcon: Image.asset('assets/htrans.png'),
                      fillColor: Colors.grey[200],
                      hintText: 'Enter The Coins',
                      hintStyle: GoogleFonts.reemKufi(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: Colors.white,
                    width: 160,
                    height: 65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: GestureDetector(
                        onTap: () {
                          if (acckey.currentState == null ||
                              !acckey.currentState!.validate()) {
                          } else if (reacckey.currentState == null ||
                              !reacckey.currentState!.validate()) {
                          } else if (namekey.currentState == null ||
                              !namekey.currentState!.validate()) {
                          } else if (coinkey.currentState == null ||
                              !coinkey.currentState!.validate()) {
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HLock(
                                      name: namecontroller.text,
                                      accnum: acccontroller.text,
                                      reaccnum: reacccontroller.text,
                                      coin: coincontroller.text,
                                    )));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.blue,
                          child: Text(
                            "Send",
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
          ),
        ),
      ),
    ));
  }
}
/*Form(
              key: namekey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: namecontroller,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your Name';
                  } else if (value.length != 2) {
                    return 'Please enter a valid Name';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Name',
                    alignLabelWithHint: true,
                    labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                    prefixIcon: const Icon(
                      Icons.call,
                      size: 25,
                    ),
                    fillColor: Colors.grey[200],
                    hintText: 'Enter the Name',
                    hintStyle: GoogleFonts.reemKufi(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Form(
              key: usernamekey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: usernamecontroller,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your Username';
                  } else if (value.length != 10) {
                    return 'Please enter a valid Username';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Username',
                    alignLabelWithHint: true,
                    labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                    prefixIcon: const Icon(
                      Icons.call,
                      size: 25,
                    ),
                    fillColor: Colors.grey[200],
                    hintText: 'Enter your Username',
                    hintStyle: GoogleFonts.reemKufi(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Form(
              key: namekey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: namecontroller,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Email Address';
                  } else if (value.length <= 2) {
                    return 'Please enter a valid Email Address';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Email',
                    alignLabelWithHint: true,
                    labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.grey[200],
                    hintText: 'Enter The Email Address',
                    hintStyle: GoogleFonts.reemKufi(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Form(
              key: phonekey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: phonecontroller,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Phone number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Phone Number',
                    alignLabelWithHint: true,
                    labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                    prefixIcon: Image.asset('assets/htrans.png'),
                    fillColor: Colors.grey[200],
                    hintText: 'Enter The Phone Number',
                    hintStyle: GoogleFonts.reemKufi(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
            ),*/