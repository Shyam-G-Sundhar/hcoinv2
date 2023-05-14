import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Home/home.dart';
import 'package:hcoinv2/screens/Wallet/cointrans.dart';
import 'package:hcoinv2/screens/Wallet/scanner.dart';
import 'package:hcoinv2/screens/Wallet/transacthis.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        toolbarHeight: 100,
        elevation: 0,
        leadingWidth: 100,
        leading: SizedBox(
          height: 144,
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
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0.h),
            child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 30.sp,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TransacHis()));
                },
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Text(
                          'Loading...',
                          style: GoogleFonts.reemKufi(fontSize: 20.sp),
                        );
                      }
                      var userdoc = snapshot.data;
                      return Container(
                        width: double.infinity.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'XXXX YYYY XXXX',
                                      style: GoogleFonts.reemKufi(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${userdoc!["cellnumber"]}',
                                      style: GoogleFonts.reemKufi(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Balance',
                                              style: GoogleFonts.reemKufi(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${userdoc["Coins"]}  Coins',
                                              style: GoogleFonts.reemKufi(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.h,
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Image.asset(
                                          'assets/logo.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 35.h,
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
                    int coins = snapshot.data!.get('Coins');
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (coins < 10) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0)),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 270.h,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'You Are Not Eligible',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .reemKufi(
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: SizedBox(
                                                                  width: 120.w,
                                                                  height: 45.h,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            45),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        color: Colors
                                                                            .blue,
                                                                        child:
                                                                            Text(
                                                                          "Ok",
                                                                          style: GoogleFonts.reemKufi(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 20.sp,
                                                                              color: Colors.white),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CoinTrans()));
                                      }
                                    },
                                    child: Container(
                                      width: 135.w,
                                      height: 145.h,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/ctrans.png',
                                                width: 105.w,
                                                height: 105.h,
                                              ),
                                              Text(
                                                'Coin Transfer',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.reemKufi(
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_auth.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData) {
                                          return Text('Loading...');
                                        }
                                        int coins = snapshot.data!.get('Coins');
                                        return GestureDetector(
                                          onTap: () {
                                            if (coins < 10) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 270.h,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'You Are Not Eligible',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts.reemKufi(
                                                                        fontSize: 20
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child: SizedBox(
                                                                        width: 120.w,
                                                                        height: 45.h,
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(45),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              color: Colors.blue,
                                                                              child: Text(
                                                                                "Ok",
                                                                                style: GoogleFonts.reemKufi(fontWeight: FontWeight.w700, fontSize: 20.sp, color: Colors.white),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Scanner(
                                                            title: '',
                                                          )));
                                            }
                                          },
                                          child: Container(
                                            width: 135.w,
                                            height: 145.h,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/stl.png',
                                                      width: 105.w,
                                                      height: 105.h,
                                                    ),
                                                    Text(
                                                      'Scan to Live',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.reemKufi(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ), /*
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 135.w,
                            height: 145.h,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/sts.png',
                                      alignment: Alignment.center,
                                      width: 105.w,
                                      height: 105.h,
                                    ),
                                    Text(
                                      'Statistics',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.reemKufi(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),*/
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
