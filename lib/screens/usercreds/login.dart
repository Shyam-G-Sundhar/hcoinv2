import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/usercreds/loginotp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Home/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController logphonecontroller = TextEditingController();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> logphnkey = GlobalKey<FormState>();
  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';
  @override
  void initState() {
    // TODO: implement initState
    if (_auth.currentUser != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (route) => false,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    logphonecontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnOTPScreen() {
    final TextEditingController logotpcontroller = TextEditingController();
    final scaffoldkey = GlobalKey<ScaffoldState>();
    GlobalKey<FormState> logotpkey = GlobalKey<FormState>();
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
                        key: logotpkey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: logotpcontroller,
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
                                  if (logotpkey.currentState == null ||
                                      !logotpkey.currentState!.validate()) {
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
                                    try {
                                      await _auth
                                          .signInWithCredential(
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      verificationCode,
                                                  smsCode: logotpcontroller.text
                                                      .toString()))
                                          .then((user) async => {
                                                //sign in was success
                                                if (user != null)
                                                  {
                                                    //store registration details in firestore database
                                                    setState(() {
                                                      isLoading = false;
                                                      isResend = false;
                                                    }),
                                                    Navigator
                                                        .pushAndRemoveUntil(
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
                                await login();
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

  Widget returnLoginScreen() {
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
                    'Hi, Welcome back !',
                    style: GoogleFonts.reemKufi(
                        fontSize: 30, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Form(
                  key: logphnkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: logphonecontroller,
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
                        hintText: 'Enter Your Phone Number',
                        hintStyle: GoogleFonts.reemKufi(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none)),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: !isLoading
                      ? Container(
                          color: Colors.white,
                          width: 160,
                          height: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: GestureDetector(
                              onTap: () {
                                if (logphnkey.currentState == null ||
                                    !logphnkey.currentState!.validate()) {
                                } else {
                                  if (!isLoading) {
                                    login();
                                  }

                                  /* ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Valid phone number',
                                        style:
                                            GoogleFonts.reemKufi(fontSize: 25),
                                      ),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginOtp()));*/
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.blue,
                                child: Text(
                                  "Send OTP",
                                  style: GoogleFonts.reemKufi(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ))
                      : const SpinKitDualRing(
                          color: Colors.blue,
                          size: 45,
                          duration: Duration(seconds: 2),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+91 ' + logphonecontroller.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = logphonecontroller.text.trim();

    await _firestore
        .collection('users')
        .where('cellnumber', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
                if (user != null)
                  {
                    //redirect
                    setState(() {
                      isLoading = false;
                      isOTPScreen = false;
                    }),
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(),
                      ),
                      (route) => false,
                    )
                  }
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Validation error, please try again later');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('Number not found, please sign up first');
    }
  }
}
