import 'dart:convert';

import 'package:panic_button_app/services/auth_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class FirebaseDynamicLinkService {

  static Future<String> CreateDynamicLink(BuildContext context) async {

    String _linkMessage;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    late final userLogged = _prefs.get('userLogged');

    print(_prefs.toString());

    //final authService = Provider.of<AuthService>(context);

    String view =  'signup_step_one';
    String alias = 'authService.userLogged.alias';
    String shop = 'authService.userLogged.shop.path';

    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: "https://bodegalert.page.link",
      link: Uri.parse("https://bodegalert.com/?view=$view&alias=$alias&shop=$shop"),
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
      await Future.delayed(const Duration(seconds: 5));
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        /// Data recuperada del listener, llamaremos a una función para manejar esta información.
        String route = handleDynamicLink(dynamicLinkData);
        if(route == 'signup_step_one'){
          Navigator.pushNamed(context, route);
        }
      }).onError((e) {
        return false;
      });
  }
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
}
