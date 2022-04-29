import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class CardUsersContainer extends StatelessWidget {

  const CardUsersContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: ListView(
          children: <Widget>[
            miCard(context),
          ],
        ));
  }

  Card miCard(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Card(
      color: Color(0xFFEAE6E6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text(authService.userLogged.name),
            subtitle: Text(
                authService.userLogged.lastname),
            leading: Icon(Icons.person_pin),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(onPressed: () => {}, child: Text('Editar')),
              FlatButton(onPressed: () => {}, child: Text('Eliminar'))
            ],
          )
        ],
      ),
    );
  }
}
