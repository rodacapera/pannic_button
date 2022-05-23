import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:panic_button_app/constants/texts.dart';

import '../../services/firebase_dynamic_link.dart';
import '../../widgets/auth_background.dart';
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
    FirebaseDynamicLinkService.CreateDynamicLink(context);
    return SpeedDial(
      child: const Icon(Icons.account_circle, size: 55),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.qr_code),
          label: 'QR',
          onTap: () async {
            Navigator.pushNamed(context, 'qr_code');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.person_add),
          label: 'Registrar',
          onTap: () {

          },
        )
      ],
      backgroundColor: const Color.fromARGB(255, 177, 19, 16),
    );
  }
}
