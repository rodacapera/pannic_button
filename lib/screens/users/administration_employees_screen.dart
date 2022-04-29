import 'package:flutter/material.dart';

import 'package:panic_button_app/constants/texts.dart';


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
      body: CardUsersContainer(),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: const Color.fromARGB(255, 177, 19, 16),
        child: const Icon(Icons.account_circle, size: 95),
      ),
    );
  }
}
