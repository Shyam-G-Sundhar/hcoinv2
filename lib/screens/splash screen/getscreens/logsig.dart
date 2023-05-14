import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/usercreds/login.dart';
import 'package:hcoinv2/screens/usercreds/register.dart';

class LogSig extends StatefulWidget {
  const LogSig({super.key});

  @override
  State<LogSig> createState() => _LogSigState();
}

class _LogSigState extends State<LogSig> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.w),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/girlmed.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.w),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/girdum.png',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.w),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/girlstd.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Column(
                children: [
                  Text(
                    'Sweat, Earn and Repeat',
                    style: GoogleFonts.reemKufi(
                        fontWeight: FontWeight.bold, fontSize: 28.sp),
                  ),
                  Text(
                    'with our physical activity app!',
                    style: GoogleFonts.reemKufi(
                        fontWeight: FontWeight.bold, fontSize: 22.sp),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(18.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Container(
                          color: Colors.white,
                          width: 150,
                          height: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Login()));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.blue,
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.reemKufi(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.sp,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.white,
                          width: 150.w,
                          height: 65.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Register()));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.blue,
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.reemKufi(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.sp,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
