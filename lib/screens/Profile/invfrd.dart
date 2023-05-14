import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Invite extends StatefulWidget {
  const Invite({super.key});

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  final GlobalKey _globalKey = GlobalKey();
  final _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
        child: Scaffold(
      body: Screenshot(
        controller: _screenshotController,
        child: RepaintBoundary(
          key: _globalKey,
          child: SingleChildScrollView(
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
                    height: 5.h,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/invfrd.png',
                        width: 300.w,
                        height: 300.h,
                      )),
                  Text(
                    'Invite A Friend',
                    style: GoogleFonts.reemKufi(
                        fontSize: 25.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250.h,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25.w)),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0.w),
                          child: Text(
                            'Hey, Lets earn money by just doing physical workouts. You can spend your at medicals and hospitals',
                            style: GoogleFonts.reemKufi(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _takeScreenshot();
                                    },
                                    child: SizedBox(
                                        width: 130.w,
                                        height: 45.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child: InkWell(
                                            onTap: () {
                                              _takeScreenshot();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: Text(
                                                "Share",
                                                style: GoogleFonts.reemKufi(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30,
                                                    color: Colors.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(const ClipboardData(
                                          text:
                                              'Hey, Lets earn money by just doing physical workouts. You can spend your at medicals and hospitals'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Link copied to clipboard'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                        width: 130.w,
                                        height: 45.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child: InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  const ClipboardData(
                                                      text: 'Oh Baby!!!'));
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Link copied to clipboard',
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: Text(
                                                "Copy",
                                                style: GoogleFonts.reemKufi(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30,
                                                    color: Colors.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void _takeScreenshot() async {
    final uint8List = await _screenshotController.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    String fileName = "screen";
    File file = await File('$tempPath/$fileName.png').create();
    await file.writeAsBytes(uint8List!);
    // ignore: deprecated_member_use
    Share.shareFiles([file.path]);
  }
}
