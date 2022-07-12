import 'package:flutter/material.dart';
import 'package:panic_button_app/constants/texts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print(arguments['link']);

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(TextConstants.QRScanner)),
          backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        ),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: 
              Container(
                padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                height: size.height * 0.24,
                // color: Colors.red,
                child: Column(
                  children: [
                    Text(TextConstants.generatedCode,
                      // Text("Codigo generado con el texto: \n "+ arguments['link'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24
                        )
                      ),

                      Text(TextConstants.descriptionScanQR,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24
                        )
                      ),
                  ],
                ),
              ),
          ),
          Center(
            child: SizedBox(
              height: size.height * 0.48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImage(data: arguments['link'],
                  size: 320,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}