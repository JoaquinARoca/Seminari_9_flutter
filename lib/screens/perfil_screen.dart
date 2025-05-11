// lib/screens/perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/Layout.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart';    // ¡Importa aquí!
import '../services/UserService.dart';
import '../models/user.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late final Future<User> _futureUser;

  @override
  void initState() {
    super.initState();

    // Verificar si currentUser es nulo
    final user = SessionManager.currentUser;
    if (user == null) {
      // Redirigir al login si no hay usuario actual
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      _futureUser = Future.error('Usuario no autenticado'); // Manejar error explícito
      return;
    }

    // Inicializar _futureUser con el usuario actual
    _futureUser = UserService.getUserById(user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      title: 'Perfil',
      child: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            // Manejar el error de forma adecuada
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snap.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Ir al login'),
                  ),
                ],
              ),
            );
          }

          final user = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                        style:
                            const TextStyle(fontSize: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildProfileItem(
                                context, Icons.badge, 'ID', user.id!),
                            const Divider(),
                            _buildProfileItem(
                                context, Icons.cake, 'Edat', '${user.age}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Configuració del compte',
                                style:
                                    Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: Icon(Icons.edit,
                                  color:
                                      Theme.of(context).colorScheme.primary),
                              title: const Text('Editar Perfil'),
                              onTap: () => context.push('/editarPerfil'),
                            ),
                            ListTile(
                              leading: Icon(Icons.lock,
                                  color:
                                      Theme.of(context).colorScheme.primary),
                              title: const Text('Canviar contrasenya'),
                              onTap: () =>
                                  context.push('/cambiarContrasena'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        AuthService().logout();
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Tancar sessió'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
          BuildContext context, IconData icon, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
}
