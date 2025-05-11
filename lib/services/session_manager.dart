import 'package:http/http.dart' as http;
import '../models/user.dart';

/// Maneja la sesión del usuario en memoria y mantiene un HTTP client con cookies.
class SessionManager {
  static User? currentUser;
  static final http.Client client = http.Client();
}
