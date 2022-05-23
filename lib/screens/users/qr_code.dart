import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
        appBar: AppBar(
          title: Text("Codigo QR"),
          backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Codigo generado con el texto: \n "+ arguments['link'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24
              )
            ),
            SizedBox(height: 20,),
            QrImage(data: arguments['link'],
            size: 300,)
          ],
        ),
      ),
    );
  }
}