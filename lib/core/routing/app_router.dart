<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/features/guest/screens/guest_dashboard.dart';
import 'package:menesha/features/auth/screens/login.dart';
import 'package:menesha/features/auth/screens/signup.dart';
import 'package:menesha/features/home/screens/user_home.dart';
import 'package:menesha/features/auth/screens/splash_screen.dart';
import 'package:menesha/features/auth/screens/role_selection.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: '/guest',
      name: 'guest',
      builder: (context, state) =>
          const GuestDashboard(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) =>
          const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) =>
          const UserHome(),
    ),
    GoRoute(
      path: '/role-selection',
      name: 'role-selection',
      builder: (context, state) =>
          const RoleSelectionScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF2E3A6E),
    body: Center(
      child: Text(
        'Page not found: ${state.uri}',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ),
=======
import 'package:go_router/go_router.dart';
import '../../features/common/screens/terms.dart';
import '../../features/common/screens/about_us.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/terms',
  routes: [
    GoRoute(
      path: '/about_us',
      name: 'aboutUs',
      builder: (context, state) => const AboutUs(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const Terms(),
    ),
  ],
>>>>>>> f9f33221df7662cff6bce9de1aa4783b85884f20
);
