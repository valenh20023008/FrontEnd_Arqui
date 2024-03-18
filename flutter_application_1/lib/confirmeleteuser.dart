import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'my_home_page.dart';

class confirmdeleteuser extends StatelessWidget {
  final User user;
  final Function onConfirmed;

  const confirmdeleteuser({
    Key? key,
    required this.user,
    required this.onConfirmed,
  }) : super(key: key);

  Future<http.Response> deleteUser(String email) async {
    final String webhookUrl = "http://127.0.0.1:4000/user/$email";
    final response = await http.delete(
      Uri.parse(webhookUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Eliminación'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('¿Estás seguro de que quieres eliminar a ${user.name}?'),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: Text('Eliminar'),
                  onPressed: () async {
                    await deleteUser(user.email);
                    onConfirmed();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
