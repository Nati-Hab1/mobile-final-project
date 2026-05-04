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
);
