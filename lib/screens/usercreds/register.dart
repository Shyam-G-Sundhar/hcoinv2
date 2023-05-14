import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';
import 'package:hcoinv2/screens/usercreds/regotp.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
DateTime now = DateTime.now();
String formatedDate = DateFormat('kk:mm:ss \t EEE d MMM').format(now);

class _RegisterState extends State<Register> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phncontroller = TextEditingController();
  final TextEditingController DOB = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController heightcontroller = TextEditingController();
  final TextEditingController weightcontroller = TextEditingController();
  String selectedDate = 'Select Date of Birth';
  String selectedGender = '';
  GlobalKey<FormState> namekey = GlobalKey<FormState>();
  GlobalKey<FormState> heightkey = GlobalKey<FormState>();
  GlobalKey<FormState> weightkey = GlobalKey<FormState>();
  GlobalKey<FormState> usernamekey = GlobalKey<FormState>();
  GlobalKey<FormState> emailkey = GlobalKey<FormState>();
  GlobalKey<FormState> phnkey = GlobalKey<FormState>();
  final TextEditingController regotpController = new TextEditingController();
  @override
  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    namecontroller.dispose();
    phncontroller.dispose();
    regotpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : register();
  }

  Widget register() {
    final node = FocusScope.of(context);
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hi, Register Yourself !',
                        style: GoogleFonts.reemKufi(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
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
                          Icons.person,
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
                  height: 8.h,
                ),
                Form(
                  key: usernamekey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: usernamecontroller,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Username';
                      } else if (value.length <= 2) {
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
                        prefixIcon: Image.asset('assets/htrans.png'),
                        fillColor: Colors.grey[200],
                        hintText: 'Enter the Username',
                        hintStyle: GoogleFonts.reemKufi(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Form(
                  key: emailkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: emailcontroller,
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
                        prefixIcon: const Icon(
                          Icons.email,
                          size: 25,
                        ),
                        fillColor: Colors.grey[200],
                        hintText: 'Enter the Email',
                        hintStyle: GoogleFonts.reemKufi(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Form(
                  key: phnkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: phncontroller,
                    keyboardType: TextInputType.phone,
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
                        prefixIcon: const Icon(
                          Icons.call,
                          size: 25,
                        ),
                        fillColor: Colors.grey[200],
                        hintText: 'Enter the Phone Number',
                        hintStyle: GoogleFonts.reemKufi(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Male';
                            print(selectedGender);
                          });
                        },
                        child: Container(
                          height: 53.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: selectedGender == 'Male'
                                ? Colors.blue
                                : Colors.grey.shade300,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: selectedGender == 'Male'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Male",
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Female';
                            print(selectedGender);
                          });
                        },
                        child: Container(
                          height: 53.h,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: selectedGender == 'Female'
                                ? Colors.pink
                                : Colors.grey.shade300,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: selectedGender == 'Female'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Female",
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0.h,
                          width: 280.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color.fromARGB(224, 224, 224, 224),
                          ),
                          child: Center(
                              child: Text(selectedDate,
                                  style: GoogleFonts.reemKufi(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7.h,
                ),
                Form(
                  key: heightkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: heightcontroller,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Height';
                      } else if (value.length <= 2) {
                        return 'Please enter a valid Height';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Height',
                        alignLabelWithHint: true,
                        labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                        prefixIcon: const Icon(
                          Icons.call,
                          size: 25,
                        ),
                        fillColor: Colors.grey[200],
                        hintText: 'Enter the Height',
                        hintStyle: GoogleFonts.reemKufi(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Form(
                  key: weightkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: weightcontroller,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Weight';
                      } else if (value.length <= 1) {
                        return 'Please enter a valid Weight';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Weight',
                        alignLabelWithHint: true,
                        labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                        prefixIcon: const Icon(
                          Icons.call,
                          size: 25,
                        ),
                        fillColor: Colors.grey[200],
                        hintText: 'Enter the Weight',
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
                            if (namekey.currentState == null ||
                                !namekey.currentState!.validate()) {
                            } else if (usernamekey.currentState == null ||
                                !usernamekey.currentState!.validate()) {
                            } else if (emailkey.currentState == null ||
                                !emailkey.currentState!.validate()) {
                            } else if (phnkey.currentState == null ||
                                !phnkey.currentState!.validate()) {
                            } else if (weightkey.currentState == null ||
                                !weightkey.currentState!.validate()) {
                            } else if (heightkey.currentState == null ||
                                !heightkey.currentState!.validate()) {
                            } else {
                              if (!isLoading) {
                                setState(() {
                                  signUp();
                                  isRegister = false;
                                  isOTPScreen = true;
                                });
                              }
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => RegisterOtp()));
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.blue,
                            child: Text(
                              "Next",
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
      ),
    );
  }

  /* Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        body: ListView(children: [
          Form(
            key: _formKeyOTP,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                            !isLoading
                                ? "Enter OTP from SMS"
                                : "Sending OTP code SMS",
                            textAlign: TextAlign.center))),
                !isLoading
                    ? Container(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: regotpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: 'OTP',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter OTP';
                            }
                          },
                        ),
                      ))
                    : Container(),
                !isLoading
                    ? Container(
                        margin: EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: new ElevatedButton(
                              onPressed: () async {
                                if (_formKeyOTP.currentState!.validate()) {
                                  // If the form is valid, we want to show a loading Snackbar
                                  // If the form is valid, we want to do firebase signup...
                                  setState(() {
                                    isResend = false;
                                    isLoading = true;
                                  });
                                  try {
                                    await _auth
                                        .signInWithCredential(
                                            PhoneAuthProvider.credential(
                                                verificationId:
                                                    verificationCode,
                                                smsCode: regotpController.text
                                                    .toString()))
                                        .then((user) async => {
                                              //sign in was success
                                              if (user != null)
                                                {
                                                  //store registration details in firestore database
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(_auth
                                                          .currentUser!.uid)
                                                      .set(
                                                          {
                                                        'name': namecontroller
                                                            .text
                                                            .trim(),
                                                        'username':
                                                            usernamecontroller
                                                                .text
                                                                .trim(),
                                                        'cellnumber':
                                                            phncontroller.text,
                                                        'phonenumber': '+91' +
                                                            phncontroller.text
                                                                .trim(),
                                                        'email': emailcontroller
                                                            .text
                                                            .trim(),
                                                      },
                                                          SetOptions(
                                                              merge:
                                                                  true)).then(
                                                          (value) => {
                                                                //then move to authorised area
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  isResend =
                                                                      false;
                                                                })
                                                              }),

                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Home()),
                                                    (route) => false,
                                                  )
                                                }
                                            })
                                        .catchError((error) => {
                                              setState(() {
                                                isLoading = false;
                                                isResend = true;
                                              }),
                                            });
                                    setState(() {
                                      isLoading = true;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Submit",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              ].where((c) => c != null).toList(),
                            )
                          ]),
                isResend
                    ? Container(
                        margin: EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: new ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await signUp();
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Resend Code",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column()
              ],
            ),
          )
        ]));
  }
*/
  Widget returnOTPScreen() {
    return SafeArea(
        child: Scaffold(
      key: scaffoldkey,
      body: Padding(
        padding: const EdgeInsets.all(25),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !isLoading
                        ? 'An Otp is sent to +91xxx54'
                        : 'An Otp Is Sending...',
                    style: GoogleFonts.reemKufi(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Column(
              children: [
                !isLoading
                    ? Form(
                        key: _formKeyOTP,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: regotpController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Otp number';
                            } else if (value.length != 6) {
                              return 'Please enter a valid Otpnumber';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              filled: true,
                              labelText: 'OTP',
                              alignLabelWithHint: true,
                              labelStyle: GoogleFonts.reemKufi(fontSize: 18),
                              prefixIcon: const Icon(
                                Icons.dialpad,
                                size: 25,
                              ),
                              fillColor: Colors.grey[200],
                              hintText: 'Enter Your OTP Number',
                              hintStyle: GoogleFonts.reemKufi(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 14,
                ),
                !isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            color: Colors.white,
                            width: 160,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: GestureDetector(
                                onTap: () async {
                                  if (_formKeyOTP.currentState == null ||
                                      !_formKeyOTP.currentState!.validate()) {
                                  } else {
                                    /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Valid Otp number',
                                    style: GoogleFonts.reemKufi(fontSize: 25),
                                  ),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (route) => false);
                            }*/
                                    setState(() {
                                      isResend = false;
                                      isLoading = true;
                                    });
                                  }
                                  try {
                                    await _auth
                                        .signInWithCredential(
                                            PhoneAuthProvider.credential(
                                                verificationId:
                                                    verificationCode,
                                                smsCode: regotpController.text
                                                    .toString()))
                                        .then((user) async => {
                                              //sign in was success
                                              if (user != null)
                                                {
                                                  //store registration details in firestore database
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(_auth
                                                          .currentUser!.uid)
                                                      .set(
                                                          {
                                                        'name': namecontroller
                                                            .text
                                                            .trim(),
                                                        'username':
                                                            usernamecontroller
                                                                .text
                                                                .trim(),
                                                        'cellnumber':
                                                            phncontroller.text,
                                                        'phonenumber': _auth
                                                            .currentUser!
                                                            .phoneNumber,
                                                        'email': emailcontroller
                                                            .text
                                                            .trim(),
                                                        'weight': int.parse(
                                                            weightcontroller
                                                                .text),
                                                        'height': int.parse(
                                                            heightcontroller
                                                                .text),
                                                        'DOB': selectedDate,
                                                        'gender':
                                                            selectedGender,
                                                        'Created_on':
                                                            formatedDate,
                                                        'Coins': 0
                                                      },
                                                          SetOptions(
                                                              merge:
                                                                  true)).then(
                                                          (value) => {
                                                                //then move to authorised area
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  isResend =
                                                                      false;
                                                                })
                                                              }),

                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Home(),
                                                    ),
                                                    (route) => false,
                                                  )
                                                }
                                            })
                                        .catchError((error) => {
                                              setState(() {
                                                isLoading = false;
                                                isResend = true;
                                              }),
                                            });
                                    setState(() {
                                      isLoading = true;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.blue,
                                  child: Text(
                                    "Verify",
                                    style: GoogleFonts.reemKufi(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              )
                            ].where((c) => c != null).toList(),
                          )
                        ],
                      ),
                isResend
                    ? Container(
                        margin: EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: new ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await signUp();
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Resend Code",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column()
              ],
            )
          ],
        ),
      ),
    ));
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    print(selectedDate);
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('Gideon test 1');
    var phoneNumber = '+91 ' + phncontroller.text.trim();
    debugPrint('Gideon test 2');
    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
              if (user != null)
                {
                  //store registration details in firestore database
                  await _firestore
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .set({
                        'name': namecontroller.text.trim(),
                        'username': usernamecontroller.text.trim(),
                        'email': emailcontroller.text.trim(),
                        'cellnumber': phncontroller.text.trim(),
                        'phonenumber': _auth.currentUser!.phoneNumber,
                        'weight': int.parse(weightcontroller.text),
                        'height': int.parse(heightcontroller.text),
                        'DOB': selectedDate,
                        'gender': selectedGender,
                        'Created_on': formatedDate,
                        'Coins': 0
                      }, SetOptions(merge: true))
                      .then((value) => {
                            //then move to authorised area
                            setState(() {
                              isLoading = false;
                              isRegister = false;
                              isOTPScreen = false;

                              //navigate to is
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Home(),
                                ),
                                (route) => false,
                              );
                            })
                          })
                      .catchError((onError) => {
                            debugPrint(
                                'Error saving user to db.' + onError.toString())
                          })
                }
            });
        debugPrint('Gideon test 4');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Gideon test 5' + "($error.message)");
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        debugPrint('Gideon test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Gideon test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
    debugPrint('Gideon test 7');
    await verifyPhoneNumber;
    debugPrint('Gideon test 8');
  }
}
