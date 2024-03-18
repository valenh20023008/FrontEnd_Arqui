import 'package:flutter/material.dart';
import 'package:flutter_application_1/service.dart';
import 'dart:convert';
import 'my_home_page.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerGender = TextEditingController();
  TextEditingController controllerStatus = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controllerName,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controllerEmail,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controllerGender,
              decoration: InputDecoration(labelText: 'Género'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controllerStatus,
              decoration: InputDecoration(labelText: 'Estado'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _registerUser();
              },
              child: Text('Guardar Usuario'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    String name = controllerName.text;
    String email = controllerEmail.text;
    String gender = controllerGender.text;
    String status = controllerStatus.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        gender.isNotEmpty &&
        status.isNotEmpty) {
      Map<String, String> userData = {
        'name': name,
        'email': email,
        'gender': gender,
        'status': status,
      };
      User newUser = User(
        name: name,
        email: email,
        gender: gender,
        status: status,
      );

      String jsonBody = json.encode(userData);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      BackendService.sendRegistrationRequest(
              jsonBody, headers, "http://127.0.0.1:4000/user")
          .then((_) {
        print('Usuario registrado con éxito');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado exitosamente')),
        );

        Navigator.pop(context, newUser);
      }).catchError((error) {
        print('Error al registrar el usuario: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el usuario: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }
}
