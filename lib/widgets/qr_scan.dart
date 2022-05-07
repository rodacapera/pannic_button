import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/texts.dart';
import '../providers/signup_form_provider.dart';
import '../services/auth_service.dart';

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
                try {
                  qrCode = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Cancel", true, ScanMode.QR);
                } on PlatformException {
                  qrCode = "Fallo en la lectura del codigo Qr";
                }

                if (!mounted) return;

                setState(() {
                  this.qrCode = qrCode;

                  var parts = qrCode.split('/');
                  var link = parts[0].trim(); // prefix: "date"
                  var alias = parts[1];
                  final pos = parts[3].length - 1;
                  final result = parts[3].substring(0, pos);

                  var shop = result;

                  signUpForm.shop = shop;
                  signUpForm.alias = alias;

                  //_prefs.setString("idUser", json.encode(idUser));

                  print("ID DEL DOCUMENTO DE LA SHOP = " + alias);
                  print("ID DEL DOCUMENTO DE LA SHOP = " + shop);


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