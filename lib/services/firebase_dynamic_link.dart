import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';


class FirebaseDynamicLinkService {

  static Future<String> CreateDynamicLink(String alias, String shop, date) async {

    String _linkMessage;


    String view =  'signup_step_one';


    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: "https://bodegalert.page.link",
      link: Uri.parse("https://bodegalert.com/?view=$view&alias=$alias&shop=$shop&date=$date"),
      androidParameters:
          const AndroidParameters(packageName: "io.cordova.alarmu"),
      iosParameters: const IOSParameters(bundleId: "io.cordova.alarmu"),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);


    _linkMessage = dynamicLink.toString();
    print("Dynamic Link -> $_linkMessage");
    return _linkMessage;
  }

  static Future<void> listenDynamicLink(BuildContext context) async {
    //final signUpForm = Provider.of<SignUpFormProvider>(context);

    await Future.delayed(const Duration(seconds: 5));
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        /// Data recuperada del listener, llamaremos a una función para manejar esta información.

        final deepLink = dynamicLinkData.link;
        if (deepLink != null) {
          final view = deepLink.queryParameters['view'];
          final alias = deepLink.queryParameters['alias'];
          final shop = deepLink.queryParameters['shop'];
          final date = deepLink.queryParameters['date'];

          if(view == 'signup_step_one'){
            Navigator.pushNamed(context, view!, arguments: {alias, shop, date});
          }
        }

      }).onError((e) {
        return false;
      });
  }
  /*
  static String handleDynamicLink(PendingDynamicLinkData data) {

      final deepLink = data.link;
      if (deepLink != null) {
          final view = deepLink.queryParameters['view'];
            if (view != null) {
              return view;    // Aca tenemos el código de que recibimos a través del link que apretamos, es decir el código de mi referido, acá tu debes crear tu lógica.
            }
        }
      return '';
    }
   */
}
