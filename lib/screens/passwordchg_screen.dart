// lib/screens/change_password_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user.dart';
import '../services/session_manager.dart';
import '../services/UserService.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    final user = SessionManager.currentUser!;

    setState(() => _loading = true);

    try {
      // Obtener el usuario desde el backend
      final userFromServer = await UserService.verifyPassword();
      if (userFromServer.password != _currentCtrl.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña actual no coincide')),
        );
        return;
      }

      // Actualizar la contraseña
      final updated = User(
        id: user.id,
        name: user.name,
        email: user.email,
        age: user.age,
        password: _newCtrl.text.trim(),
      );

      final fromServer = await UserService.updateUser(user.id!, updated);
      SessionManager.currentUser = fromServer;
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar contraseña: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña actual'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Introduce tu contraseña actual' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newCtrl,
                decoration: const InputDecoration(labelText: 'Nueva contraseña'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return 'La nueva contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _changePassword,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Actualizar contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
