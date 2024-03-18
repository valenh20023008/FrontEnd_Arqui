import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendService {
 static Future<void> sendRegistrationRequest(String jsonBody, Map<String, String> headers, String url) async {
  try {
    // Envía la solicitud POST al servidor con el cuerpo JSON y los encabezados configurados
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );


    if (response.statusCode == 201) {
      return; // Usuario registrado exitosamente
    } else {
      // Maneja el error si la solicitud no se completa correctamente
      throw Exception('Error al registrar el usuario. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    // Maneja el error si ocurre una excepción durante el proceso de solicitud
    throw Exception('Error al enviar la solicitud de registro: $e');
  }
}


  static Future<void> ModifyWebhookData(Map<String, dynamic> data, String url) async {
    try {
      http.Response response = await http.put( 
        Uri.parse(url), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Error al Modificar. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al Modificar: $error');
    }
  }
}

