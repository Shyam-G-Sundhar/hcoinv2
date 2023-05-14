import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Wallet/logpin.dart';
import 'package:hcoinv2/screens/Wallet/wlthome.dart';

class SetHlock extends StatefulWidget {
  const SetHlock({super.key});

  @override
  State<SetHlock> createState() => _SetHlockState();
}

class _SetHlockState extends State<SetHlock> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController f1TextEditingController = TextEditingController();
  TextEditingController f2TextEditingController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  bool _obscureText = true;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  void dispose() {
    f1TextEditingController.dispose();

    super.dispose();
  }

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
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
          height: 144.h,
          child: Padding(
              padding: EdgeInsets.only(top: 28),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: const Image(
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/hlock.png',
                width: 150.w,
                height: 150.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Enter Pin Code',
              style: GoogleFonts.reemKufi(
                  fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 10.w),
              child: PinCodeFields(
                keyboardType: TextInputType.number,
                length: 4,
                obscureText: _obscureText,
                obscureCharacter: '*',
                controller: f1TextEditingController,
                textStyle: GoogleFonts.reemKufi(fontSize: 25),
                focusNode: focusNode1,
                onComplete: (text) {
                  print(text);
                },
              ),
            ),
            Text(
              'Re Enter Pin Code',
              style: GoogleFonts.reemKufi(
                  fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 10.w),
              child: PinCodeFields(
                keyboardType: TextInputType.number,
                length: 4,
                obscureText: _obscureText,
                obscureCharacter: '*',
                controller: f2TextEditingController,
                textStyle: GoogleFonts.reemKufi(fontSize: 25),
                focusNode: focusNode2,
                onComplete: (text) {
                  print(text);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Text(_obscureText ? 'Show' : 'Hide'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (f2TextEditingController.text ==
                        f1TextEditingController.text) {
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .set({
                        'hpin': f2TextEditingController.text.trim()
                      }, SetOptions(merge: true)).then((value) =>
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => WalletHome()),
                                  (route) => false));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Wrong Pin, Entered the Correct Pin"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class Pin extends StatefulWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    checkPINSetup();
    super.initState();
  }

  Future<void> checkPINSetup() async {
    final user = _auth.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (userData.data()!['hpin'] == null) {
      // User has not set a PIN, navigate to PIN setup page
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SetHlock()));
    } else {
      // User has set a PIN, navigate to other page
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Logpin()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
