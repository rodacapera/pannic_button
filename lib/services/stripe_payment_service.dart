import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService extends ChangeNotifier {
  Map<String, dynamic>? paymentIntentData;

  Future makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: false,
          merchantCountryCode: 'US',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'] ?? 'customer',
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        
        final result = await displayPaymentSheet();
        return result;
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return 'complete';
      
    } on Exception catch (e) {
      if (e is StripeException) {
        print(
            "Notifica el error a tu proveedor: Error from Stripe: ${e.error.localizedMessage} ");
      } else {
        print("Notifica el error a tu proveedor: Unforeseen error: ${e}");
      }
      return 'incomplete';
    } catch (e) {
      print("Notifica el error a tu proveedor: exception:$e");
      return 'incomplete';
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer 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',
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
