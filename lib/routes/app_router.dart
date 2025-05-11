// lib/routes/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:seminari_flutter/screens/auth/login_screen.dart';
import 'package:seminari_flutter/screens/borrar_screen.dart';
import 'package:seminari_flutter/screens/details_screen.dart';
import 'package:seminari_flutter/screens/editar_screen.dart';
import 'package:seminari_flutter/screens/imprimir_screen.dart';
import 'package:seminari_flutter/screens/home_screen.dart';
import 'package:seminari_flutter/screens/perfil_screen.dart';
// import 'package:seminari_flutter/screens/editar_screen.dart';
import 'package:seminari_flutter/screens/passwordchg_screen.dart';
import 'package:seminari_flutter/services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AuthService().isLoggedIn ? '/' : '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) => const DetailsScreen(),
          routes: [
            GoRoute(
              path: 'imprimir',
              builder: (context, state) => const ImprimirScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'editar',            // ya existente
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: 'borrar',
          builder: (context, state) => const BorrarScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const PerfilScreen(),
        ),
        // → Nuevas rutas:
        GoRoute(
          path: 'editarPerfil',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: 'cambiarContrasena',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
      ],
    ),
  ],

  // Protege las rutas según el estado de login
  redirect: (context, state) {
    final loggedIn = AuthService().isLoggedIn;
    final goingToLogin = state.uri.toString() == '/login';

    if (!loggedIn && !goingToLogin) return '/login';
    if (loggedIn && goingToLogin) return '/';
    return null;
  },
);
