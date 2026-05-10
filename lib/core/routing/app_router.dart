import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/features/guest/screens/guest_dashboard.dart';
import 'package:menesha/features/auth/screens/login.dart';
import 'package:menesha/features/auth/screens/signup.dart';
import 'package:menesha/features/home/screens/user_home.dart';
import 'package:menesha/features/auth/screens/splash_screen.dart';
import 'package:menesha/features/auth/screens/role_selection.dart';
import 'package:menesha/features/common/screens/about_us.dart';
import 'package:menesha/features/common/screens/terms.dart';
import 'package:menesha/features/common/screens/contact_us.dart';
import 'package:menesha/features/investor/screens/investor_dashboard.dart';
import 'package:menesha/core/widgets/common/investor_sider.dart';
import 'package:menesha/features/investor/screens/investor_startups.dart';
import 'package:menesha/features/investor/screens/investor_bookmarks.dart';
import 'package:menesha/features/investor/screens/investor_notes.dart';
import 'package:menesha/features/profile/screens/profile_settings.dart';
import 'package:menesha/features/common/screens/delete_account.dart';
import 'package:menesha/features/investor/screens/investor_intros.dart';
import 'package:menesha/features/startup/screens/add_startup.dart';
import 'package:menesha/features/startup/screens/create_intro.dart';
import 'package:menesha/features/startup/screens/my_investors.dart';
import 'package:menesha/features/startup/screens/my_startup.dart';
import 'package:menesha/features/startup/screens/startup_dashboard.dart';
import 'package:menesha/core/widgets/startup/startup_sider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/add_startup/startup',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/guest',
      name: 'guest',
      builder: (context, state) => const GuestDashboard(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const UserHome(),
    ),
    GoRoute(
      path: '/role-selection',
      name: 'role-selection',
      builder: (context, state) =>
          const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/about_us/:role',
      name: 'aboutUs',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return AboutUs(role: role);
      },
    ),
    GoRoute(
      path: '/terms/:role',
      name: 'terms',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return Terms(role: role);
      },
    ),
    GoRoute(
        path: '/contact_us/:role',
        name: 'contactUs',
        builder: (context, state) {
          final role = state.pathParameters['role']!;
          return ContactUs(role: role);
        }),
    GoRoute(
      path: '/profile_settings/:role',
      name: 'profileSettings',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return ProfileSettings(role: role);
      },
    ),
    GoRoute(
      path: '/investor_dashboard/:role',
      name: 'investorDashboard',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return InvestorDashboard(role: role);
      },
    ),
    GoRoute(
        path: '/investor_sider/:role',
        name: 'investorSider',
        builder: (context, state) {
          final role = state.pathParameters['role']!;
          return InvestorSider(role: role);
        }),
    GoRoute(
      path: '/investor_startups/:role',
      name: 'investorStartups',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return InvestorStartups(role: role);
      },
    ),
    GoRoute(
      path: '/bookmarks/:role',
      name: 'bookmarks',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return InvestorBookmarks(role: role);
      },
    ),
    GoRoute(
      path: '/investor_notes/:role',
      name: 'investorNotes',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return InvestorNotes(role: role);
      },
    ),
    GoRoute(
        path: '/delete_account',
        name: 'deleteAccount',
        builder: (context, state) => const DeleteAccount()),
    GoRoute(
      path: '/investor_intros/:role',
      name: 'investorIntros',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return InvestorIntrosPage(role: role);
      },
    ),
    GoRoute(
      path: '/startup_dashboard/:role',
      name: 'startupDashboard',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return StartupDashboard(role: role);
      },
    ),
    GoRoute(
      path: '/add_startup/:role',
      name: 'addStartup',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return AddStartup(role: role);
      },
    ),
    GoRoute(
      path: '/startup_sider/:role',
      name: 'startupSider',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return StartupSider(role: role);
      },
    ),
    GoRoute(
      path: '/my_startups/:role',
      name: 'myStartups',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return MyStartups(role: role);
      },
    ),
    GoRoute(
      path: '/create_intro/:role',
      name: 'createIntro',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return CreateIntro(role: role);
      },
    ),
    GoRoute(
      path: '/my_investors/:role',
      name: 'myInvestors',
      builder: (context, state) {
        final role = state.pathParameters['role']!;
        return MyInvestors(role: role);
      },
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
);
