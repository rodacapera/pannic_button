import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          ),
          SizedBox(height: 20,),
          Text(qrCode == null ? 'Scan a code': 'Scan result : $qrCode',
          style: TextStyle(fontSize: 18 ),)
        ],
      ),
    ),
  );

  Future scanQRCode() async {

    try{
      qrCode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      qrCode = "Fallo en la lectura del codigo Qr";
    }

    if(!mounted ) return;

    setState(() {
      this.qrCode = qrCode;
      Navigator.pushNamed(context, qrCode);
    });
  }
}