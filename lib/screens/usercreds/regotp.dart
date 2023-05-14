/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';

class RegisterOtp extends StatefulWidget {
  const RegisterOtp({super.key});

  @override
  State<RegisterOtp> createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  final TextEditingController registerotpcontroller = TextEditingController();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> registerotp = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    'An Otp is sent to +91xxx54',
                    style: GoogleFonts.reemKufi(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Form(
                  key: registerotp,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: registerotpcontroller,
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
                ),
                const SizedBox(
                  height: 14,
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
                            if (registerotp.currentState == null ||
                                !registerotp.currentState!.validate()) {
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}*/
