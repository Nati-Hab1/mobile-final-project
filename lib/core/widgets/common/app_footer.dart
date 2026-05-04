import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/core/widgets/common/app_logo.dart';

/// Fixed footer — white background, compact height.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogo(
                  size: 28,
                  showLabel: false,
                  darkBackground: false),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menesha',
                      style: TextStyle(
                        color: AppColors.backgroundDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'The easiest way to manage investor introductions.',
                      style: TextStyle(
                        color: Color(0xFF5A6A9A),
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nav Links',
                    style: TextStyle(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _FooterLink(
                      label: 'Home',
                      onTap: () => context.go('/guest')),
                  _FooterLink(
                      label: 'About Us',
                      onTap: () {
                        context.pushNamed("aboutUs");
                      }),
                  _FooterLink(
                      label: 'Contact Us',
                      onTap: () {
                        context.pushNamed("contactUs");
                      }),
                  _FooterLink(
                      label: 'Terms of Service',
                      onTap: () {
                        context.pushNamed("terms");
                      }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
              color: Color(0xFFDDE3F5),
              thickness: 1,
              height: 1),
          const SizedBox(height: 8),
          const Text(
            '© 2026 Manesha Startup & Investor Connection Platform. All rights reserved.',
            style: TextStyle(
                color: Color(0xFF8B9BC8),
                fontSize: 9,
                height: 1.3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(
      {required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          style: const TextStyle(
              color: Color(0xFF5A6A9A), fontSize: 10),
        ),
      ),
    );
  }
}
