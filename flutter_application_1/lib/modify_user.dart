import 'package:flutter/material.dart';
import 'package:flutter_application_1/service.dart';
import 'my_home_page.dart';

class ModifyUser extends StatefulWidget {
  final User _user;
  ModifyUser(this._user);

  @override
  State<StatefulWidget> createState() => _ModifyUserState();
}

class _ModifyUserState extends State<ModifyUser> {
  TextEditingController controllerStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerStatus = TextEditingController(text: widget._user.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modificar Estado del Usuario"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // Campo para modificar el estado del usuario
            TextField(
              controller: controllerStatus,
              decoration: InputDecoration(labelText: 'Estado'),
            ),
            SizedBox(height: 20), // Espacio entre el TextField y el botón
            ElevatedButton(
              onPressed: () {
                String status = controllerStatus.text;
                if (status.isNotEmpty) {
                  // Construir el cuerpo de la solicitud
                  Map<String, dynamic> userData = {
                    'name': widget._user.name,
                    'gender': widget._user.gender,
                    'email': widget._user.email,
                    'status': status,
                  };
                  // Enviar la solicitud de modificación al servicio backend
                  BackendService.ModifyWebhookData(userData,
                          "http://127.0.0.1:4000/user/${widget._user.email}")
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Estado del usuario modificado exitosamente')),
                    );
                    // Actualizar el estado local del usuario y cerrar la pantalla de modificación
                    Navigator.pop(
                        context,
                        User(
                            name: widget._user.name,
                            email: widget._user.email,
                            gender: widget._user.gender,
                            status: status));
                  }).catchError((error) {
                    print('Error al modificar el estado: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Error al modificar el estado del usuario: $error')),
                    );
                  });
                }
              },
              child: Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
