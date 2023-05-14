import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Wallet/wlthome.dart';

class Logpin extends StatefulWidget {
  const Logpin({super.key});

  @override
  State<Logpin> createState() => _LogpinState();
}

class _LogpinState extends State<Logpin> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool _obscureText = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    newTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<String> _getValueFromFirestore() async {
    final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore
        .instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await docRef.get();
    return docSnapshot.data()!['hpin'];
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
      body: FutureBuilder(
          future: _getValueFromFirestore(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/hlock.png',
                      width: 250.w,
                      height: 250.h,
                    ),
                  ),
                  Text(
                    'Enter Pin Code',
                    style: GoogleFonts.reemKufi(
                        fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.h, vertical: 10.w),
                    child: PinCodeFields(
                      keyboardType: TextInputType.number,
                      length: 4,
                      obscureText: _obscureText,
                      obscureCharacter: '*',
                      controller: newTextEditingController,
                      textStyle: GoogleFonts.reemKufi(fontSize: 25),
                      focusNode: focusNode,
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
                        onPressed: () {
                          if (newTextEditingController.text == snapshot.data) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Correct Pin"),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const WalletHome()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Wrong Pin, Entered the Correct Pin"),
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
            );
          }),
    ));
  }
}
