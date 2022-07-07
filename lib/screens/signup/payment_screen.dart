import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:panic_button_app/services/stripe_payment_service.dart';
import 'package:panic_button_app/services/auth_service.dart';
import 'package:panic_button_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final paymentService =
                          Provider.of<PaymentService>(context, listen: false);

                      await paymentService.makePayment(
                          amount: "50", currency: "USD");
                    },
                    child: Text("Pay fee to complete registration"))
              ],
            )),
    ));
  }
}
