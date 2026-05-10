import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';

/// Role Selection screen shown after successful login/register.
/// Lets the user pick Investor or Startup. — route: /role-selection
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: _RoleCard(),
            ),
          ),
        ],
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
              color: Color(0xFF4A5FA8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: const Icon(
              Icons.people_outline,
              size: 32,
              color: Color(0xFF2E3A6E),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Choose Role',
            style: TextStyle(
              color: Color(0xFF2E3A6E),
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
              context.pushNamed('investorDashboard',
                  pathParameters: {'role': 'investor'});
            },
          ),
          const SizedBox(height: 14),

          // Startup button (filled)
          PrimaryButton(
            label: 'Startup',
            onPressed: () {
              context.pushNamed('startupDashboard',
                  pathParameters: {'role': 'startup'});
            },
          ),
        ],
      ),
    );
  }
}
