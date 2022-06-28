import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:panic_button_app/helpers/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:panic_button_app/models/payload_mp.dart';


class MercadoPagoService extends ChangeNotifier {
  HttpService http = HttpService();

  Future<dynamic> getProductReferenceId(PayloadMp payload) async {
    Response res = await http.post(
        endpoint: '/api/mercadopago',
        body: json.encode(payload.toJson()),
        params: {});
    return json.decode(res.body);
  }
  
  Future<dynamic> sendPay() async {
  }
}