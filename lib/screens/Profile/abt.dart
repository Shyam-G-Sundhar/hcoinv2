import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Abt extends StatelessWidget {
  const Abt({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Image.asset(
                'assets/logo.png',
                width: 170.w,
                height: 170.h,
              ),
              Text(
                'About',
                style: GoogleFonts.reemKufi(
                    fontSize: 35.sp, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                'The H Coin project is a health and fitness product that incentivizes users to exercise by rewarding them with coins that can only be spent on medical and hospital bills. The project includes an H Wallet for users to store their coins and aims to promote healthy living while addressing the financial burdens of medical expenses. The success of the project will depend on clear and user-friendly platforms for tracking and redeeming H Coins, as well as partnerships with healthcare providers and insurance companies. Overall, H Coin has the potential to positively impact both the physical and financial well-being of its users.',
                style: GoogleFonts.reemKufi(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
