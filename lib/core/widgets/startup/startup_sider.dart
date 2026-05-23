import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/features/auth/presentation/providers/auth_provider.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class StartupSider extends ConsumerStatefulWidget {
  final String role;
  final bool isRoleExpanded;

  const StartupSider({
    super.key,
    required this.role,
    this.isRoleExpanded = true,
  });

  @override
  ConsumerState<StartupSider> createState() => _StartupSiderState();
}

class _StartupSiderState extends ConsumerState<StartupSider> {
  bool _isLoading = false;
  late bool _isRoleExpanded;

  @override
  void initState() {
    super.initState();
    _isRoleExpanded = widget.isRoleExpanded;
  }

  String _currentPath(BuildContext context) {
    final config = GoRouter.of(context).routerDelegate.currentConfiguration;
    return config.matches.last.matchedLocation;
  }

  @override
  Widget build(BuildContext context) {
    final currentRole = widget.role;
    final activePath = _currentPath(context);

    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      child: Row(
        children: [
          // LEFT SIDE
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: const Color(0xFF5A6A9A).withOpacity(0.2),
              ),
            ),
          ),

          // RIGHT SIDE
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
                        child: IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.black, size: 30),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Navigation List
                    _buildNavTile(context, activePath,
                        Icons.home_outlined, 'Home', '/home'),
                    _buildNavTile(context, activePath,
                        Icons.grid_view_rounded, 'Dashboard', '/startup-dashboard'),
                    _buildNavTile(context, activePath,
                        Icons.info_outline, 'About Us', '/about-us',
                        extra: {'role': currentRole}),
                    _buildNavTile(context, activePath,
                        Icons.phone_outlined, 'Contact Us', '/contact-us',
                        extra: {'role': currentRole}),
                    _buildNavTile(context, activePath,
                        Icons.description_outlined, 'Terms Of Service', '/terms',
                        extra: {'role': currentRole}),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(color: Colors.black12, height: 30),
                    ),

                    _buildExpandableRoleSection(context, currentRole),

                    const Spacer(),

                    // Delete Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, right: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: _buildDeleteButton(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context,
    String activePath,
    IconData icon,
    String label,
    String route, {
    Map<String, dynamic>? extra,
  }) {
    final isActive = activePath == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pop();
          if (extra != null) {
            context.go(route, extra: extra);
          } else {
            context.go(route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2952FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isActive ? Colors.white : Colors.black87, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableRoleSection(BuildContext context, String currentRole) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isRoleExpanded = !_isRoleExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.cached, color: Colors.black87),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Switch Role',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Icon(
                  _isRoleExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),
        ),
        if (_isRoleExpanded) ...[
          _buildSubTile(context, 'Startup', '/startup-dashboard', 'startup', currentRole),
          _buildSubTile(context, 'Investor', '/investor-dashboard', 'investor', currentRole),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Colors.black12, height: 30),
        ),
      ],
    );
  }

  Widget _buildSubTile(
    BuildContext context,
    String label,
    String route,
    String targetRole,
    String currentRole,
  ) {
    final isActive = targetRole == currentRole;

    return InkWell(
      onTap: () async {
        if (isActive) {
          context.pop();
          return;
        }
        setState(() => _isLoading = true);
        try {
          final token = await ref.read(authProvider.notifier).getRoleToken(targetRole);
          if (targetRole == 'startup') {
            await SecureStorage.saveStartupToken(token);
          } else {
            await SecureStorage.saveInvestorToken(token);
          }
          if (mounted) context.go(route);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to switch to $targetRole role: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 70),
        child: Row(
          children: [
            if (_isLoading && !isActive)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2952FF) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF2952FF) : Colors.black54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : () => context.pushNamed('deleteAccount'),
      icon: const Icon(Icons.person, color: Colors.white),
      label: const Text(
        'Delete',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF3B3B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}