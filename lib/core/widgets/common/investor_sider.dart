import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvestorSider extends StatefulWidget {
  const InvestorSider({super.key});

  @override
  State<InvestorSider> createState() =>
      _InvestorSiderState();
}

class _InvestorSiderState extends State<InvestorSider> {
  // Track active route internally only for UI highlighting
  String _currentRoute = '/dashboard';
  bool _isRoleExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Ensure the drawer covers the full screen or specific width as needed
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      child: Row(
        children: [
          // 1. LEFT SIDE: Background Image/Gradient
          Expanded(
            flex:
                4, // Adjust this ratio to match the blue area in your image
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: const Color(0xFF5A6A9A)
                    .withOpacity(0.2),
              ),
            ),
          ),

          // 2. RIGHT SIDE: White Content Area
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
                              size: 30),
                          onPressed: () => {
                            // context.goNamed(
                            //   "investorDashboard",
                            //   pathParameters: {
                            //     'role': 'investor'
                            //   },
                            // )
                            context.pop()
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Navigation List
                    _buildNavTile(Icons.home_outlined,
                        'Home', '/home'),
                    _buildNavTile(Icons.grid_view_rounded,
                        'Dashboard', '/dashboard'),
                    _buildNavTile(Icons.info_outline,
                        'About Us', '/about'),
                    _buildNavTile(Icons.phone_outlined,
                        'Contact Us', '/contact'),
                    _buildNavTile(
                        Icons.description_outlined,
                        'Terms Of Service',
                        '/terms'),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Divider(
                          color: Colors.black12,
                          height: 30),
                    ),

                    // Expandable Switch Role
                    _buildExpandableRoleSection(),

                    const Spacer(),

                    // Delete Button
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, right: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: _buildDeleteButton(),
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
      IconData icon, String label, String route) {
    final bool isActive = _currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentRoute = route; // Only updates UI state
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF3D41AC)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isActive
                      ? Colors.white
                      : Colors.black87,
                  size: 24),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 18,
                  fontWeight: isActive
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableRoleSection() {
    return Column(
      children: [
        ListTile(
          onTap: () => setState(
              () => _isRoleExpanded = !_isRoleExpanded),
          leading: const Icon(Icons.cached,
              color: Colors.black87),
          title: const Text(
            'Switch Role',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16),
          ),
          trailing: Icon(_isRoleExpanded
              ? Icons.expand_less
              : Icons.expand_more),
        ),
        if (_isRoleExpanded) ...[
          _buildSubTile('Startup', '/startup'),
          _buildSubTile('Investor', '/investor'),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Colors.black12, height: 30),
        ),
      ],
    );
  }

  Widget _buildSubTile(String label, String route) {
    final bool isActive = _currentRoute == route;
    return InkWell(
      onTap: () => setState(() => _currentRoute = route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 70),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? const Color(0xFF3D41AC)
                : Colors.black54,
            fontWeight: isActive
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton.icon(
      onPressed: () {
        context.pushNamed("investorDelete");
      },
      icon: const Icon(Icons.person, color: Colors.white),
      label: const Text('Delete',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF3B3B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
