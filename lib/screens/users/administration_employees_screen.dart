import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:panic_button_app/constants/texts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/firebase_dynamic_link.dart';
import '../../widgets/card_users_widget.dart';

class AdministrationEmployeeScreen extends StatefulWidget {
  const AdministrationEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AdministrationEmployeeScreen> createState() =>
      _AdministrationEmployeeScreenState();
}

class _AdministrationEmployeeScreenState
    extends State<AdministrationEmployeeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(TextConstants.userAdministration)),
        backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'notification');
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: const CardUsersContainer(),
      floatingActionButton: const BotonFlotante(),
    );
  }
}

class BotonFlotante extends StatelessWidget {
  const BotonFlotante({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    String alias = authService.userLogged.alias;
    String shop = authService.userLogged.shop;

    return SpeedDial(
      child: const Icon(Icons.account_circle, size: 55),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.qr_code),
          label: 'QR',
          onTap: () async {
            String route = await FirebaseDynamicLinkService.CreateDynamicLink(alias, shop);
            Navigator.pushNamed(context, 'qr_code', arguments:{'link' : route});
          },
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 177, 19, 16),
    );
  }
}
