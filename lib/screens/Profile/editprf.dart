import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';
import 'package:intl/intl.dart';

class EditPrf extends StatefulWidget {
  const EditPrf({super.key});

  @override
  State<EditPrf> createState() => _EditPrfState();
}

class _EditPrfState extends State<EditPrf> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController namecontroller = TextEditingController();
  GlobalKey<FormState> namekey = GlobalKey<FormState>();
  final TextEditingController usernamecontroller = TextEditingController();
  GlobalKey<FormState> usernamekey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  GlobalKey<FormState> emailkey = GlobalKey<FormState>();
  final TextEditingController phonecontroller = TextEditingController();
  GlobalKey<FormState> phonekey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  GlobalKey<FormState> heightkey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  GlobalKey<FormState> weightkey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> datekey = GlobalKey<FormState>();
  final TextEditingController genderController = TextEditingController();
  GlobalKey<FormState> genderkey = GlobalKey<FormState>();
  User? _user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<void> updateProfile() async {
    if (namecontroller.text != null) {
      if (usernamecontroller.text != null) {
        if (emailcontroller.text != null) {
          if (phonecontroller.text != null) {
            if (_heightController.text != null)
            // ignore: curly_braces_in_flow_control_structures
            if (_weightController.text != null) {
              if (dateController.text != null) {
                if (genderController.text != null) {
                  try {
                    DateTime now = DateTime.now();
                    String formatedDate =
                        DateFormat('kk:mm:ss \t EEE d MMM').format(now);

                    await _firestore.collection('users').doc(_user!.uid).update(
                      {
                        'name': namecontroller.text.trim(),
                        'username': usernamecontroller.text.trim(),
                        'email': emailcontroller.text.trim(),
                        'cellnumber': phonecontroller.text.trim(),
                        'phonenumber': '91' + phonecontroller.text.trim(),
                        'height': int.parse(_heightController.text.trim()),
                        'weight': int.parse(_weightController.text.trim()),
                        'DOB': dateController.text.trim(),
                        'gender': genderController.text.trim(),
                        'Updated_on': formatedDate
                      },
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Failed to update profile. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((userData) {
      int height = userData['height'] ?? 0;
      int weight = userData['weight'] ?? 0;
      String date = userData['DOB'] ?? '';
      String gender = userData['gender'] ?? '';
      namecontroller.text = userData['name'] ?? '';
      usernamecontroller.text = userData['username'] ?? '';
      emailcontroller.text = userData['email'] ?? '';
      phonecontroller.text = userData['cellnumber'] ?? '';
      _heightController.text = height.toString();
      _weightController.text = weight.toString();
      dateController.text = date.toString();
      genderController.text = gender.toString();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        updateProfile();
                      },
                      icon: const Icon(
                        Icons.done,
                        size: 35,
                      ))
                ],
              ),
              SizedBox(
                height: 15.h,
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

                    return Align(
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
                    );
                  }),
              Column(
                children: [
                  TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                        label: Text(
                      'Name',
                      style: GoogleFonts.reemKufi(),
                    )),
                  ),
                  TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      label: Text(
                        'Username',
                        style: GoogleFonts.reemKufi(),
                      ),
                    ),
                  ),
                  TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        label: Text(
                      'E-mail',
                      style: GoogleFonts.reemKufi(),
                    )),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      label: Text(
                        'Phone Number',
                        style: GoogleFonts.reemKufi(),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      label: Text(
                        'Height',
                        style: GoogleFonts.reemKufi(),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      label: Text(
                        'Weight',
                        style: GoogleFonts.reemKufi(),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      label: Text(
                        'DOB',
                        style: GoogleFonts.reemKufi(),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                      controller: genderController,
                      decoration: InputDecoration(
                        label: Text(
                          'Gender',
                          style: GoogleFonts.reemKufi(),
                        ),
                      ),
                      keyboardType: TextInputType.text),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
