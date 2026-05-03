import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/features/common/screens/app_logo.dart';
import 'package:menesha/features/common/screens/feature_card.dart';
import 'package:menesha/features/common/screens/app_footer.dart';
import 'package:menesha/features/common/screens/guest_header.dart';
import 'package:menesha/features/common/screens/wavy_background.dart';

/// Guest / unauthenticated home screen — route: /guest
class GuestDashboard extends StatelessWidget {
  const GuestDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const GuestHeader(), // fixed header
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: const [
            _HeroBody(),
            SizedBox(height: 24),
            _FeatureSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar:
          const AppFooter(), // fixed footer
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
        padding: const EdgeInsets.fromLTRB(
            24, 40, 24, 52),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            const AppLogo(size: 52),
            const SizedBox(height: 20),
            const Text(
              'Warm Introduction Assistant',
              style: TextStyle(
                color: AppColors.textPrimary,
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
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // ── Sign Up + Log In buttons centered in hero ──
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go('/register'),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: AppColors
                          .accentBlueBright,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.go('/login'),
                    style:
                        OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors.white70,
                          width: 1.5),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
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
