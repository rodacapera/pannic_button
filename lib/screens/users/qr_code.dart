import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> with SingleTickerProviderStateMixin {

  final String data = "prueba";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Codigo QR"),
          backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Codigo generado con el texto: \n $data",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24
              )
            ),
            SizedBox(height: 20,),
            QrImage(data: data,
            size: 300,)
          ],
        ),
      ),
    );
  }
}