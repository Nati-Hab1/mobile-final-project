import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/home/feature_card.dart';
import 'package:menesha/core/widgets/common/app_footer.dart';
import 'package:menesha/core/widgets/common/app_header.dart';

/// Authenticated user home — route: /home
class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GuestHeader(
        actions: [
          ElevatedButton(
            onPressed: () =>
                context.go('/role-selection'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2952FF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Dashboard'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => context.go('/guest'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF2E3A6E),
              side: const BorderSide(
                  color: Color(0xFF2E3A6E),
                  width: 1.2),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Log out'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context)
                .size
                .height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: const [
                _HeroBody(),
                SizedBox(height: 24),
                _FeatureSection(),
                SizedBox(height: 24),
                Spacer(),
                AppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────

class _HeroBody extends StatelessWidget {
  const _HeroBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              24, 40, 24, 52),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/Menesha.jpg',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Warm Introduction Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Streamline your investor outreach.\nGenerate tailored introductions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFCDD5F3),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Feature cards ─────────────────────────────────────────────────────────────

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20),
      child: Column(
        children: const [
          FeatureCard(
            icon: Icons.people_outline,
            title: 'Investor Queue',
            description:
                'Organize and track all your investor introduction in one place',
          ),
          SizedBox(height: 14),
          FeatureCard(
            icon: Icons.access_time_outlined,
            title: 'Startup Showcase',
            description:
                'Present your startup ideas, goals, and funding needs to potential investors',
          ),
          SizedBox(height: 14),
          FeatureCard(
            icon: Icons.bar_chart,
            title: 'Investor Engagement',
            description:
                'Track your outreach performance and completion rates',
          ),
        ],
      ),
    );
  }
}
