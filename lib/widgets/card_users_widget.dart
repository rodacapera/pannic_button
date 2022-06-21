import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class CardUsersContainer extends StatelessWidget {

  const CardUsersContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: ListView.builder(itemCount: authService.employees.length, itemBuilder: (BuildContext context, int index)
        {
          return Card(
            color: Color(0xFFEAE6E6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: Text(authService.employees[index].name),
                  subtitle: Text(
                      authService.employees[index].lastname),
                  leading: Icon(Icons.person_pin),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(onPressed: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Eliminar Usuario'),
                        content:
                        Text("¿Esta seguro que desea eliminar el usuario?"),
                        actions: <Widget>[
                          FlatButton(
                              child: Text("Aceptar"),
                              textColor: Colors.blue,
                              onPressed: () {
                                authService.deleteEmploye(authService.employees[index]);
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text("Cancelar"),
                              textColor: Colors.red,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      ));
                    }, child: Text('Eliminar'))
                  ],
                )
              ],
            ),
          );
        },
        )
    );
  }
}
