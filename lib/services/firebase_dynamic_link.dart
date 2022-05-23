import 'package:panic_button_app/services/auth_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';

class FirebaseDynamicLinkService {

  static Future<String> CreateDynamicLink(BuildContext context) async {

    String _linkMessage;

    final authService = Provider.of<AuthService>(context);

    // String data =  'signup_step_one?'+ authService.userLogged.alias+ '/'+ authService.userLogged.shop.path;

    String view =  'signup_step_one';
    String alias = authService.userLogged.alias;
    String reference = authService.userLogged.shop.path;

    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: "https://bodegalert.page.link",
      link: Uri.parse("https://bodegalert.com/?view=$view&alias=$alias&reference=$reference"),
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
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        /// Data recuperada del listener, llamaremos a una función para manejar esta información.
        final deepLink = dynamicLinkData.link;
        final view = deepLink.queryParameters['view'];
        final alias = deepLink.queryParameters['alias'];
        final reference = deepLink.queryParameters['reference'];
        if(view == 'signup_step_one'){
          final data = {"view": view, "alias": alias, "reference": reference};
          Navigator.pushNamed(context, view.toString(),  arguments: data );
        }
      }).onError((e) {
        return false;
      });
  }
}
