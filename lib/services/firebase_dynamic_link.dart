import 'package:panic_button_app/services/auth_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';

class FirebaseDynamicLinkService {
  static Future<String> CreateDynamicLink(BuildContext context) async {

    String _linkMessage;

    /*final authService = Provider.of<AuthService>(context);*/

    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://bodegalert.com/"),
      uriPrefix: "https://bodegalert.page.link",
      androidParameters:
          const AndroidParameters(packageName: "io.cordova.alarmu"),
      iosParameters: const IOSParameters(bundleId: "io.cordova.alarmu"),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);


    _linkMessage = dynamicLink.toString();
    print("Dynamic Link -> $_linkMessage");

    return "hola";
  }
}
