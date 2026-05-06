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
import 'package:menesha/features/investor/screens/investor_profile.dart';
import 'package:menesha/features/investor/screens/investor_delete.dart';
import 'package:menesha/features/investor/screens/investor_intros.dart';
import 'package:menesha/features/profile/screens/profile_setting.dart';
import 'package:menesha/features/startup/screens/create_intro.dart';
import 'package:menesha/features/startup/screens/my_investors.dart';
import 'package:menesha/features/startup/screens/my_startup.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/my_investors',
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
      path: '/about_us',
      name: 'aboutUs',
      builder: (context, state) => const AboutUs(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const Terms(),
    ),
    GoRoute(
      path: '/contact_us',
      name: 'contactUs',
      builder: (context, state) => const ContactUs(),
    ),
    GoRoute(
      path: '/profile_settings',
      name: 'profileSettings',
      builder: (context, state) => const ProfileSetting(),
    ),
    GoRoute(
      path: '/investor_dashboard',
      name: 'investorDashboard',
      builder: (context, state) =>
          const InvestorDashboard(),
    ),
    GoRoute(
        path: '/investor_sider',
        name: 'investor_sider',
        builder: (context, state) => const InvestorSider()),
    GoRoute(
        path: '/investor_startups',
        name: 'investorStartups',
        builder: (context, state) =>
            const InvestorStartups()),
    GoRoute(
        path: '/bookmarks',
        name: 'bookmarks',
        builder: (context, state) =>
            const InvestorBookmarks()),
    GoRoute(
        path: '/investor_notes',
        name: 'investorNotes',
        builder: (context, state) => const InvestorNotes()),
    GoRoute(
        path: '/investor_profile',
        name: 'investorProfile',
        builder: (context, state) =>
            const InvestorProfile()),
    GoRoute(
        path: '/investor_delete',
        name: 'investorDelete',
        builder: (context, state) =>
            const InvestorDelete()),
    GoRoute(
        path: '/investor_intros',
        name: 'investorIntros',
        builder: (context, state) =>
            const InvestorIntrosPage()),
    GoRoute(
        path: '/my_startups',
        name: 'myStartups',
        builder: (context, state) => const MyStartups()),
    GoRoute(
        path: '/create_intro',
        name: 'createIntro',
        builder: (context, state) => const CreateIntro()),
    GoRoute(
        path: '/my_investors',
        name: 'myInvestors',
        builder: (context, state) => MyInvestors()),
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
