import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/features/common/screens/app_logo.dart';

/// Fixed top header for the authenticated User Home screen.
/// Shows logo on the left, Dashboard pill + Log out button on the right.
/// Used as [Scaffold.appBar] via [PreferredSizeWidget] so it stays pinned
/// while the body scrolls.
class UserHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const UserHeader({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3D4F8A),
            Color(0xFF2E3A6E)
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Brand logo
              const AppLogo(
                  size: 40, showLabel: false),
              const Spacer(),

              // Dashboard pill
              GestureDetector(
                onTap: () =>
                    context.go('/role-selection'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors
                        .accentBlueBright,
                    borderRadius:
                        BorderRadius.circular(20),
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

              // Log out button
              GestureDetector(
                onTap: () => context.go('/guest'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white60),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
