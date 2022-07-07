import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:panic_button_app/models/models.dart';
import 'package:http/http.dart' as http;

class PaymentService extends ChangeNotifier {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        await displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('Payment Successful');
    } on Exception catch (e) {
      if (e is StripeException) {
        print(
            "Notifica el error a tu proveedor: Error from Stripe: ${e.error.localizedMessage} ");
      } else {
        print("Notifica el error a tu proveedor: Unforeseen error: ${e}");
      }
    } catch (e) {
      print("Notifica el error a tu proveedor: exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51LIEQIJSA4gqgXTS2JJ0iYWC0zokJe5yD12RPlkXv8B64eosnin0yc0h8W9z1hsO2zeuk1PtDzthDa5u7iKOJF5P00hXI8ZKp5',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print("response ${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
