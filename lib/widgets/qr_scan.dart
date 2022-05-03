import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../constants/texts.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) => Scaffold(
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
            onPressed: scanQRCode,
          )
        ],
      ),
    ),
  );

  Future scanQRCode() async {
    var result = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    setState(() {
      qrCode = result as String;
    });
  }
}