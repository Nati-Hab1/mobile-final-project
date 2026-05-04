import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/features/common/screens/primary_button.dart';
import 'package:menesha/features/common/screens/wavy_background.dart';

/// Role Selection screen shown after successful login/register.
/// Lets the user pick Investor or Startup. — route: /role-selection
class RoleSelectionScreen
    extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WavyBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: _RoleCard(),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: const Icon(
              Icons.people_outline,
              size: 32,
              color: AppColors.backgroundDark,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Choose Role',
            style: TextStyle(
              color: AppColors.backgroundDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'By Selecting One You Will Be Redirected To Your Desired Role',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5A6A9A),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Investor button (outlined)
          PrimaryButton(
            label: 'Investor',
            isOutlined: true,
            onPressed: () {
              // Navigate to investor dashboard (handled by teammate)
              context.go('/home');
            },
          ),
          const SizedBox(height: 14),

          // Startup button (filled)
          PrimaryButton(
            label: 'Startup',
            onPressed: () {
              // Navigate to startup dashboard (handled by teammate)
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}
