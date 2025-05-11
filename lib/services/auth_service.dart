import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'session_manager.dart';
import '../models/user.dart';

class AuthService {
  bool get isLoggedIn => SessionManager.currentUser != null;

  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:9000/api/users';
    if (Platform.isAndroid) return 'http://10.0.2.2:9000/api/users';
    return 'http://localhost:9000/api/users';
  }

  static String? loggedInUserId; // Variable para almacenar el _id del usuario logueado

  Future<User> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final resp = await SessionManager.client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final user = User.fromJson(data);
      SessionManager.currentUser = user;
      loggedInUserId = user.id; // Almacenar el _id del usuario logueado
      return user;
    } else if (resp.statusCode == 401) {
      throw Exception('Credenciales inválidas');
    } else {
      throw Exception('Error de login (${resp.statusCode})');
    }
  }

  void logout() {
    SessionManager.currentUser = null;
    // Opcional: si tu backend soporta /logout por cookies:
    // SessionManager.client.get(Uri.parse('$_baseUrl/logout'));
  }
}
