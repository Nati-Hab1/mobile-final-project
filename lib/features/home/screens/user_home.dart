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
      backgroundColor: const Color(0xFF2E3A6E),
      appBar: GuestHeader(
        actions: [
          GestureDetector(
            onTap: () => context.go('/role-selection'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2952FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/guest'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF2952FF)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xFF2952FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: const IntrinsicHeight(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                _HeroBody(),
                SizedBox(height: 24),
                _FeatureSection(),
                SizedBox(height: 24),
                Spacer(), // pushes footer to bottom when content is short
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
          padding:
              const EdgeInsets.fromLTRB(24, 40, 24, 52),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
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
