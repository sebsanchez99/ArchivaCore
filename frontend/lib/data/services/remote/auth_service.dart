import 'dart:convert';

import 'package:frontend/data/services/handler/http_request_handler.dart';
import 'package:frontend/domain/typedefs.dart';
import 'package:http/http.dart';

// Servicio de autentiación que maneja las solicitudes HTTP al backend
class AuthService {
  AuthService(this._client);

  final Client _client;

  // Método encargado de autenticar un usuario con nombre de usuario y contraseña
  HttpFuture<String> authUser(String username, String password) async {
    return handleHttpRequest(
      () async {
        final url = Uri.parse('http://localhost:3000/api/v1/auth/login');
        final headers = {'Content-Type': 'application/json'};
        final body = {'username': username, 'password': password};
        final response = await _client.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        return response;
      },
      (responseBody) {
        final token = jsonDecode(responseBody);
        return token;
      },
    );
  }
}
