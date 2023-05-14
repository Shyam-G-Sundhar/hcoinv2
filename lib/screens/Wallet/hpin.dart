import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Wallet/wlthome.dart';

class HLock extends StatefulWidget {
  const HLock({super.key, this.name, this.accnum, this.reaccnum, this.coin});
  final name, accnum, reaccnum, coin;
  @override
  State<HLock> createState() => _HLockState();
}

class _HLockState extends State<HLock> {
  TextEditingController f1TextEditingController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  bool _obscureText = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    f1TextEditingController.dispose();
    focusNode1.dispose();
    super.dispose();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
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
                      controller: f1TextEditingController,
                      textStyle: GoogleFonts.reemKufi(fontSize: 25),
                      focusNode: focusNode1,
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
                          if (f1TextEditingController.text == snapshot.data) {
                            try {
                              await transferMoney(
                                      _auth.currentUser!.phoneNumber,
                                      widget.reaccnum,
                                      int.parse(widget.coin))
                                  .then((value) => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const WalletHome())));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Transfer successful')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
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

  Future<void> transferMoney(String? senderPhonenumber,
      String recipientPhonenumber, int amount) async {
    final senderSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phonenumber', isEqualTo: _auth.currentUser!.phoneNumber)
        .get();
    if (senderSnapshot.docs.isEmpty) {
      throw Exception("Sender Account not found");
    }
    final senderDocId = senderSnapshot.docs.first.id;
    final senderData = senderSnapshot.docs.first.data();
    if (senderData['Coins'] < amount) {
      throw Exception("Insufficient Balance");
    }
    final recipientSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('cellnumber', isEqualTo: recipientPhonenumber)
        .get();
    if (recipientSnapshot.docs.isEmpty) {
      throw Exception("Receipient Account Not Found");
    }
    final recipientDocId = recipientSnapshot.docs.first.id;
    final recipientData = recipientSnapshot.docs.first.data();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
          FirebaseFirestore.instance.collection('users').doc(senderDocId),
          {'Coins': senderData['Coins'] - amount});

      transaction.update(
          FirebaseFirestore.instance.collection('users').doc(recipientDocId),
          {'Coins': recipientData['Coins'] + amount});

      //add transaction to sender's transaction history
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('transactions')
          .add({
        'name': widget.name,
        'recipientPhoneNumber': recipientPhonenumber,
        'coins': amount,
        'date': DateTime.now(),
        'type': "Sent"
      });
    });
    //add transaction to recipient's transaction history
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipientDocId)
        .collection('transactions')
        .add({
      'senderPhoneNumber': _auth.currentUser!.phoneNumber,
      'coins': amount,
      'date': Timestamp.now(),
      'type': "Received"
    });
  }
}
