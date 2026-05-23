import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';
import 'package:menesha/features/auth/presentation/providers/auth_provider.dart';
import 'package:menesha/core/utils/secure_storage.dart';

/// Role Selection screen shown after successful login/register.
/// Lets the user pick Investor or Startup. — route: /role-selection
class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Update local loading state
    _isLoading = authState.isLoading;

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
              child: _RoleCard(
                onInvestorPressed: _handleInvestor,
                onStartupPressed: _handleStartup,
                isLoading: _isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleInvestor() async {
    setState(() => _isLoading = true);
    
    try {
      // Add investor role
      await ref.read(authProvider.notifier).addRole('investor');
      
      // Get role-specific token
      final token = await ref.read(authProvider.notifier).getRoleToken('investor');
      
      // Save investor token
      await SecureStorage.saveInvestorToken(token);
      
      if (mounted) {
        context.goNamed('investorDashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add investor role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleStartup() async {
    setState(() => _isLoading = true);
    
    try {
      // Add startup role
      await ref.read(authProvider.notifier).addRole('startup');
      
      // Get role-specific token
      final token = await ref.read(authProvider.notifier).getRoleToken('startup');
      
      // Save startup token
      await SecureStorage.saveStartupToken(token);
      
      if (mounted) {
        context.goNamed('startupDashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add startup role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _RoleCard extends StatelessWidget {
  final VoidCallback onInvestorPressed;
  final VoidCallback onStartupPressed;
  final bool isLoading;

  const _RoleCard({
    required this.onInvestorPressed,
    required this.onStartupPressed,
    this.isLoading = false,
  });

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
              color: const Color(0xFF4A5FA8).withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
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
            isLoading: isLoading,
            onPressed: onInvestorPressed,
          ),
          const SizedBox(height: 14),

          // Startup button (filled)
          PrimaryButton(
            label: 'Startup',
            isLoading: isLoading,
            onPressed: onStartupPressed,
          ),
        ],
      ),
    );
  }
}