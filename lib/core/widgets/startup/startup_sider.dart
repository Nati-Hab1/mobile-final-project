import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartupSider extends StatelessWidget {
  final String role;
  final bool isRoleExpanded;

  const StartupSider({
    super.key,
    required this.role,
    this.isRoleExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: const Color(0xFF5A6A9A)
                    .withOpacity(0.2),
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
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          right: 16,
                          left: 16,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Navigation List
                    _buildNavTile(
                      context,
                      Icons.home_outlined,
                      'Home',
                      '/home',
                    ),

                    _buildNavTile(
                      context,
                      Icons.grid_view_rounded,
                      'Dashboard',
                      '/startup_dashboard/$role',
                    ),

                    _buildNavTile(
                      context,
                      Icons.info_outline,
                      'About Us',
                      '/about_us/$role',
                    ),

                    _buildNavTile(
                      context,
                      Icons.phone_outlined,
                      'Contact Us',
                      '/contact_us/$role',
                    ),

                    _buildNavTile(
                      context,
                      Icons.description_outlined,
                      'Terms Of Service',
                      '/terms/$role',
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Divider(
                        color: Colors.black12,
                        height: 30,
                      ),
                    ),

                    _buildExpandableRoleSection(context),

                    const Spacer(),

                    // Delete Button
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                        right: 20,
                      ),
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
    IconData icon,
    String label,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black87,
                size: 24,
              ),
              const SizedBox(width: 15),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableRoleSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.cached,
            color: Colors.black87,
          ),
          title: const Text(
            'Switch Role',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: Icon(
            isRoleExpanded
                ? Icons.expand_less
                : Icons.expand_more,
          ),
        ),
        if (isRoleExpanded) ...[
          _buildSubTile(
            context,
            'Startup',
            '/startup_dashboard',
          ),
          _buildSubTile(
            context,
            'Investor',
            '/investor_dashboard/$role',
          ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Colors.black12,
            height: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTile(
    BuildContext context,
    String label,
    String route,
  ) {
    return InkWell(
      onTap: () {
        context.go(route);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 70,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push('/investor_delete');
      },
      icon: const Icon(
        Icons.person,
        color: Colors.white,
      ),
      label: const Text(
        'Delete',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF3B3B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
