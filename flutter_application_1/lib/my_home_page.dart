import 'package:flutter/material.dart';
import 'package:flutter_application_1/modify_user.dart';
import 'package:flutter_application_1/register_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: MyHomePage("Usuarios"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String _title;
  MyHomePage(this._title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Obtener la lista de usuarios al iniciar la aplicación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // Código existente para la acción de tocar en el ListTile
            },
            title: Text(users[index].email),
            subtitle: Text(users[index].status),
            leading: CircleAvatar(
              child: Text(users[index].name.substring(0, 1)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModifyUser(users[index]),
                      ),
                    ).then((newUser) {
                      if (newUser != null) {
                        setState(() {
                          users[index] = newUser;
                        });
                      }
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16), // Espacio entre los íconos
                GestureDetector(
                  onTap: () {
                    removeUser(index);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de registro de usuario
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterUser()),
          ).then((newUser) {
            if (newUser != null) {
              setState(() {
                users.add(newUser);
              });
            }
          });
        },
        tooltip: "Agregar Usuario",
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchUsers() async {
    final url =
        "http://127.0.0.1:4000/user"; // Endpoint para obtener la lista de usuarios
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          users = responseData.map((json) => User.fromJson(json)).toList();
        });
      } else {
        print(
            'Error al obtener la lista de usuarios. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener la lista de usuarios: $error');
    }
  }

  void removeUser(int index) async {
    User removedUser = users[index];
    final String email = removedUser.email;
    if (email != null) {
      final String webhookUrl = "http://127.0.0.1:4000/user/$email";
      try {
        final response = await http.delete(
          Uri.parse(webhookUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 204) {
          // Eliminar el usuario de la lista local
          setState(() {
            users.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario eliminado exitosamente')),
          );
        } else {
          print(
              'Error al eliminar el usuario. Código de estado: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error al eliminar el usuario: ${response.statusCode}')),
          );
        }
      } catch (error) {
        print('Error al eliminar el usuario: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el usuario: $error')),
        );
      }
    } else {
      print('Correo electrónico del usuario nulo. No se puede eliminar.');
    }
  }
}

class User {
  final String name;
  final String email;
  final String gender;
  final String status;

  User({
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }
}
