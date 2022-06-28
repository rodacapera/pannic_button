import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:panic_button_app/helpers/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:panic_button_app/models/payload_mp.dart';


class MercadoPagoService extends ChangeNotifier {
  HttpService http = HttpService();

  Future<dynamic> getProductReferenceId(PayloadMp payload) async {
    // final referenceBody = {
    //   "title": "Pago de la licencia",
    //   "description": "Licencia",
    //   "quantity": 1,
    //   "unit_price": 60,
    //   "email": "rodacapera@gmail.com",
    //   "app": "bodega"
    // };
    Response res = await http.post(
        endpoint: '/api/mercadopago',
        body: json.encode(payload.toJson()),
        params: {});
        
        // print('sdfsf ${res.statusCode}');
        // print(json.decode(res.body)['result']);
    return json.decode(res.body);
  }
  
  Future<dynamic> sendPay() async {
  }
}