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
  initialLocation: '/',
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
      name: 'roleSelection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    // Common pages - no role parameter needed, use extra
    GoRoute(
      path: '/about-us',
      name: 'aboutUs',
      builder: (context, state) {
        final extra = state.extra as Map?;
        final role = extra?['role'] ?? 'investor';
        return AboutUs(role: role);
      },
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) {
        final extra = state.extra as Map?;
        final role = extra?['role'] ?? 'investor';
        return Terms(role: role);
      },
    ),
    GoRoute(
      path: '/contact-us',
      name: 'contactUs',
      builder: (context, state) {
        final extra = state.extra as Map?;
        final role = extra?['role'] ?? 'investor';
        return ContactUs(role: role);
      },
    ),
    GoRoute(
      path: '/profile-settings',
      name: 'profileSettings',
      builder: (context, state) {
        final extra = state.extra as Map?;
        final role = extra?['role'] ?? 'investor';
        return ProfileSettings(role: role);
      },
    ),
    // Investor routes
    GoRoute(
      path: '/investor-dashboard',
      name: 'investorDashboard',
      builder: (context, state) => const InvestorDashboard(),
    ),
    GoRoute(
      path: '/investor-sider',
      name: 'investorSider',
      builder: (context, state) => const InvestorSider(role: 'investor'),
    ),
    GoRoute(
      path: '/investor-startups',
      name: 'investorStartups',
      builder: (context, state) => const InvestorStartups(),
    ),
    GoRoute(
      path: '/bookmarks',
      name: 'bookmarks',
      builder: (context, state) => const InvestorBookmarks(),
    ),
    GoRoute(
      path: '/investor-notes',
      name: 'investorNotes',
      builder: (context, state) => const InvestorNotes(role: 'investor'),
    ),
    GoRoute(
      path: '/investor-intros',
      name: 'investorIntros',
      builder: (context, state) => const InvestorIntrosPage(),
    ),
    // Startup routes
    GoRoute(
      path: '/startup-dashboard',
      name: 'startupDashboard',
      builder: (context, state) => const StartupDashboard(),
    ),
    GoRoute(
      path: '/startup-sider',
      name: 'startupSider',
      builder: (context, state) => const StartupSider(role: 'startup'),
    ),
    GoRoute(
      path: '/my-startups',
      name: 'myStartups',
      builder: (context, state) => const MyStartups(),
    ),
    GoRoute(
      path: '/my-investors',
      name: 'myInvestors',
      builder: (context, state) => const MyInvestors(),
    ),
    GoRoute(
      path: '/add-startup',
      name: 'addStartup',
      builder: (context, state) => const AddStartup(),
    ),
    GoRoute(
      path: '/create-intro',
      name: 'createIntro',
      builder: (context, state) => const CreateIntro(),
    ),
    // Delete account
    GoRoute(
      path: '/delete-account',
      name: 'deleteAccount',
      builder: (context, state) => const DeleteAccount(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF2E3A6E),
    body: Center(
      child: Text(
        'Page not found: ${state.uri}',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  ),
);
