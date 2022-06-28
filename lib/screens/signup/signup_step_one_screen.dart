import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:panic_button_app/constants/texts.dart';
import 'package:panic_button_app/helpers/validators.dart';
import 'package:panic_button_app/models/payload_mp.dart';
import 'package:panic_button_app/providers/signup_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';


import 'package:panic_button_app/services/services.dart';

import 'package:panic_button_app/ui/input_decorations.dart';
import 'package:panic_button_app/widgets/widgets.dart';

class SignUpStepOneScreen extends StatelessWidget {
  const SignUpStepOneScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    final signUpForm = Provider.of<SignUpFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    if(data != null){
      var parts = data.toString().split(',');
      signUpForm.alias = parts[0].replaceAll("{", "");
      var shopReference = parts[1].replaceAll("}", "");
      signUpForm.shop = FirebaseFirestore.instance.doc(shopReference.replaceAll(" ", ""));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        ),
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 210),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(height: 10),
              Text(TextConstants.createAccount,
                  style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _SignUpStepOneForm(),
              )
            ],
          )),
          const SizedBox(height: 50),
          Visibility(
              visible: !authService.isValidUser,
              child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: Text(
                TextConstants.readyAccount,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              )),),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _SignUpStepOneForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpForm = Provider.of<SignUpFormProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final MercadoPagoService mercadopago = Provider.of<MercadoPagoService>(context);

    return Form(
      key: signUpForm.formKeyOne,
      child: Column(
        children: [
          IntlPhoneField(
            decoration: InputDecorations.authInputDecoration(
                hintText: '3003543968',
                labelText: TextConstants.cellPhone,
                prefixIcon: Icons.lock_outline),
            initialCountryCode: 'US',
            countries: const ["US", "DO", "CO"],
            validator: checkEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            pickerDialogStyle: PickerDialogStyle(
                searchFieldInputDecoration:
                  InputDecoration(label: Text(TextConstants.searchCountry))),
            onChanged: (phone) {
              signUpForm.phone = '${phone.countryCode}${phone.number}';
            },
            invalidNumberMessage: TextConstants.invalidNumber,
          ),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: TextConstants.john,
                labelText: TextConstants.names,
                prefixIcon: Icons.person),
            onChanged: (value) => signUpForm.name = value,
            validator: checkEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 10),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: TextConstants.doe,
                labelText: TextConstants.lastnames,
                prefixIcon: Icons.person),
            onChanged: (value) => signUpForm.lastName = value,
            validator: checkEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromARGB(255, 177, 19, 16),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    signUpForm.isLoading ? TextConstants.await : TextConstants.next,
                    style: const TextStyle(color: Colors.white),
                  )),
              onPressed: !signUpForm.isLoading
                  ? () async {
                      signUpForm.isLoading = true;
                      if (!signUpForm.isValidStepOneForm()) {
                        Timer(const Duration(seconds: 1), () {
                          signUpForm.isLoading = false;
                        });
                        return;
                      }
                      PayloadMp payload = PayloadMp(
                        title: "Pago de la licencia",
                        description: "Licencia",
                        quantity: 1,
                        unit_price: 1,
                        email: "rodacapera@gmail.com",
                        app: "bodega"
                      );
                      if(signUpForm.shop != null){
                        print('es un registro de empleado deja registrar sin cobro');
                        signUpForm.isLoading = false;
                        Navigator.pushNamed(context, 'signup_step_two');
                      } else {
                        print('es un registro de empresa, cobra antes de completar el registro');
                        final product = await mercadopago.getProductReferenceId(payload);
                        PaymentResult result =
                            await MercadoPagoMobileCheckout.startCheckout(
                                'TEST-a8931263-ca44-48ee-974e-73a02834d6cc',
                                '${product["result"]["id"]}');
                        if (result.result == "done") {
                          await authService.verifyIsRegistered(signUpForm.phone);

                          if (authService.isRegistered == true) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: TextConstants.ops,
                              text: TextConstants.existingAccount,
                              loopAnimation: false,
                            );
                            signUpForm.isLoading = false;

                            return;
                          }

                          try {
                            List<Placemark> address =
                                await placemarkFromCoordinates(
                                    signUpForm.location["lat"],
                                    signUpForm.location["lng"]);
                            signUpForm.countryCode =
                                address.first.isoCountryCode!;
                            signUpForm.zipCode = address.first.postalCode ?? '';

                            /*final authService = Provider.of<AuthService>(context);*/

                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: "Exito",
                                loopAnimation: false);
                            Navigator.pushNamed(context, 'signup_step_two');

                          } catch (e) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: TextConstants.ops,
                              text: e.toString(),
                              loopAnimation: false,
                            );
                          }
                          signUpForm.isLoading = false;
                        } else {
                          signUpForm.isLoading = false;
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: TextConstants.ops,
                            text: TextConstants.failPayment,
                            loopAnimation: false,
                          );
                        }
                      }
                                          }
                  : null)
        ],
      ),
    );
  }
}
