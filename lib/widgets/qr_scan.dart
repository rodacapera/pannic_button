
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../constants/texts.dart';
import '../providers/signup_form_provider.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    final signUpForm = Provider.of<SignUpFormProvider>(context);
    return Scaffold(

      appBar: AppBar(
        title: Center(child: Text(TextConstants.QRScanner)),
        backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'notification');
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 177, 19, 16),
                  onPrimary: Colors.white
              ),
              icon: Icon(Icons.camera_alt),
              label: Text('Scan'),
              onPressed: () async {
                final _possibleFormats = BarcodeFormat.values.toList()
                  ..removeWhere((e) => e == BarcodeFormat.unknown);

                List<BarcodeFormat> selectedFormats = [..._possibleFormats];
                try {
                  final result = await BarcodeScanner.scan(
                    options: ScanOptions(
                      strings: {
                        'cancel': 'Cancel',
                        'flash_on': 'Flash on',
                        'flash_off': 'Flash off',
                      },
                      restrictFormat: selectedFormats,
                      useCamera: -1,
                      autoEnableFlash: false,
                      android: const AndroidOptions(
                        aspectTolerance: 0.00,
                        useAutoFocus: true,
                      ),
                    ),
                  );
                  // qrCode = await FlutterBarcodeScanner.scanBarcode(
                  //     "#ff6666", "Cancel", true, ScanMode.QR);
                } on PlatformException {
                  qrCode = "Fallo en la lectura del codigo Qr";
                }

                if (!mounted) return;

                setState(() {
                  this.qrCode = qrCode;

                  var parts = qrCode.split('/');
                  var link = parts[0].trim(); // prefix: "date"
                  var alias = parts[1];

                  var idShop = parts[2] + '/'+ parts[3];

                  signUpForm.shop = FirebaseFirestore.instance.doc(idShop);

                  signUpForm.alias = alias;

                  //_prefs.setString("idUser", json.encode(idUser));

                  Navigator.pushNamed(context, link);
                });
              },
            ),
            SizedBox(height: 20,),
            Text(qrCode == null ? 'Scan a code' : 'Scan result : $qrCode',
              style: TextStyle(fontSize: 18),)
          ],
        ),
      ),
    );
  }
}