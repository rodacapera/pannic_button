import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:panic_button_app/blocs/location/location_bloc.dart';
import 'package:panic_button_app/constants/texts.dart';
import 'package:panic_button_app/helpers/validators.dart';
import 'package:panic_button_app/providers/login_form_provider.dart';
import 'package:panic_button_app/providers/signup_form_provider.dart';
import 'package:panic_button_app/services/services.dart';

import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import 'package:panic_button_app/ui/input_decorations.dart';
import 'package:panic_button_app/widgets/widgets.dart';

import '../blocs/gps/gps_bloc.dart';
import '../services/firebase_dynamic_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    FirebaseDynamicLinkService.listenDynamicLink(context);
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
                child: Column(
              children: [
                const SizedBox(height: 10),
                Text(TextConstants.login,
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 20),
                _LoginForm()
              ],
            )),
            const SizedBox(height: 50),
            BlocListener<LocationBloc, LocationState>(
              bloc: locationBloc = BlocProvider.of<LocationBloc>(context),
              listener: (context, state) async {
                final gpsBloc = BlocProvider.of<GpsBloc>(context);
                final signUpForm =
                    Provider.of<SignUpFormProvider>(context, listen: false);

                final isGpsPermissionGranted = await gpsBloc.askGpsAccess();

                if (isGpsPermissionGranted) {
                  signUpForm.location = {
                    "lat": state.lastKnownLocation?.latitude,
                    "lng": state.lastKnownLocation?.longitude
                  };
                }
              },
              child: TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, 'signup_step_one');
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 177, 19, 16)
                              .withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: Text(
                    TextConstants.newAccount,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  )),
            ),
            const SizedBox(height: 50),
          ],
        ),
      )),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final signUpForm = Provider.of<SignUpFormProvider>(context);
    final authService = Provider.of<AuthService>(context);
    

    String qrCode = 'Unknown';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: loginForm.formKey,
        child: Column(
          children: [
            IntlPhoneField(
              decoration: InputDecorations.authInputDecoration(
                  hintText: '3003543968',
                  labelText: TextConstants.cellPhone,
                  prefixIcon: Icons.lock_outline),
              initialCountryCode: 'US',
              initialValue: loginForm.phoneNumber,
              countries: const ["US", "DO", "CO"],
              validator: checkEmpty,
              autovalidateMode: AutovalidateMode.always,
              pickerDialogStyle: PickerDialogStyle(
                  searchFieldInputDecoration: InputDecoration(
                      label: Text(TextConstants.searchCountry))),
              onChanged: (phone) {
                loginForm.phoneNumber = '${phone.countryCode}${phone.number}';
              },
              invalidNumberMessage: TextConstants.invalidNumber,
            ),
            const SizedBox(height: 10),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromARGB(255, 177, 19, 16),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading
                          ? TextConstants.await
                          : TextConstants.login,
                      style: const TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        final errorMessage =
                            await authService.login(loginForm.phoneNumber);

                        if (authService.isValidUser) {
                          Navigator.pushReplacementNamed(context, 'checkOtp');
                        } else {
                          // ignore: todo
                          //TODO CHANGE TO VALIDATE ERROR
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: TextConstants.ops,
                            text: errorMessage,
                            loopAnimation: false,
                          );

                          loginForm.isLoading = false;
                        }
                      }),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 177, 19, 16),
                  onPrimary: Colors.white
              ),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan'),
              onPressed: () async {
                final _possibleFormats = BarcodeFormat.values.toList()
                  ..removeWhere((e) => e == BarcodeFormat.unknown);

                List<BarcodeFormat> selectedFormats = [..._possibleFormats];
                final qrCode = await BarcodeScanner.scan(
                    options: ScanOptions(
                      strings: {
                        'cancel': 'Cancel',
                        'flash_on': 'Flash on',
                        'flash_off': 'Flash off',
                      },
                      restrictFormat: selectedFormats,
                      useCamera: -1,
                      autoEnableFlash: false,
                      android: const AndroidOptions(
                        aspectTolerance: 0.00,
                        useAutoFocus: true,
                      ),
                    ),
                  );
                  // qrCode = await FlutterBarcodeScanner.scanBarcode(
                  //  
                if(qrCode.type.toString() != 'Cancelled'){
                  var link = 'signup_step_one';

                  var parts = qrCode.rawContent.split('%2F');

                  var parts2 = parts[3].split('3D');

                  var idShop = 'shops/'+ parts[parts.length-1];

                  signUpForm.shop = FirebaseFirestore.instance.doc(idShop);

                  signUpForm.alias = await authService.searchShop(parts[parts.length-1]);

                  signUpForm.date = parts2[3].split('%')[0];

                  Navigator.pushNamed(context, link);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}