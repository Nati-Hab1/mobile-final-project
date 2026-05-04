import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/core/widgets/common/app_logo.dart';
import 'package:menesha/core/widgets/home/feature_card.dart';
import 'package:menesha/core/widgets/common/app_footer.dart';
import 'package:menesha/core/widgets/home/guest_header.dart';
import 'package:menesha/core/widgets/common/wavy_background.dart';

/// Authenticated user home — route: /home
class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: GuestHeader(
        actions: [
          GestureDetector(
            onTap: () => context.go('/role-selection'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentBlueBright,
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
                    color: AppColors.accentBlueBright),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Log out',
                style: TextStyle(
                  color: AppColors.accentBlueBright,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _HeroBody(),
            SizedBox(height: 24),
            _FeatureSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}

// ── Hero — uses WavyBackground ────────────────────────────────────────────────

class _HeroBody extends StatelessWidget {
  const _HeroBody();

  @override
  Widget build(BuildContext context) {
    return WavyBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 52),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            AppLogo(size: 52),
            SizedBox(height: 20),
            Text(
              'Warm Introduction Assistant',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Streamline your investor outreach.\nGenerate tailored introductions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Feature cards ─────────────────────────────────────────────────────────────

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
