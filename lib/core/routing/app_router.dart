import 'package:go_router/go_router.dart';
import '../../features/common/screens/about_us.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/about_us',
  routes: [
    GoRoute(
      path: '/about_us',
      name: 'aboutUs',
      builder: (context, state) => const AboutUs(),
    ),
  ],
);
