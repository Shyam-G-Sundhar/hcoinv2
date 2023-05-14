import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcoinv2/screens/Wallet/scantrans.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;

  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
      if (result != null && result!.code!.contains('hcoin')) {
        String? qrdata = result!.code;
        String? name = qrdata!.split(',')[1].toString();
        String? accnum = qrdata.split(',')[2].toString();
        String? reaccnum = qrdata.split(',')[3].toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScanTrans(
                    code: qrdata,
                    name: name,
                    accnum: accnum,
                    reaccnum: reaccnum,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Scan To Live',
                          style: GoogleFonts.reemKufi(
                              color: Colors.black,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    height: 400,
                    width: 400,
                    child: QRView(key: _gLobalkey, onQRViewCreated: qr),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: (result != null)
                      ? (result!.code!.contains('hcoin')
                          ? Text('${result!.code}')
                          : Text(
                              'Invalid H Code',
                              style: GoogleFonts.reemKufi(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ))
                      : Text(
                          'Scan a code',
                          style: GoogleFonts.reemKufi(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
