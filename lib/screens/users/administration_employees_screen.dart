import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:panic_button_app/blocs/location/location_bloc.dart';
import 'package:panic_button_app/blocs/map/map_bloc.dart';
import 'package:panic_button_app/constants/texts.dart';
import 'package:panic_button_app/models/panic.dart';
import 'package:panic_button_app/models/user.dart';
import 'package:panic_button_app/services/auth_service.dart';
import 'package:panic_button_app/services/notifications_service.dart';
import 'package:panic_button_app/services/panic_service.dart';
import 'package:panic_button_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

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
