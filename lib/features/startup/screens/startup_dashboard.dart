import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';

class StartupDashboard extends StatelessWidget {
  const StartupDashboard({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        role: role,
      ),
      body: Stack(
        children: [
          // Background Image - covers entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          const SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _HeroSection(),
                  SizedBox(height: 24),
                  _StatsSection(),
                  SizedBox(height: 24),
                  _ActionsSection(),
                  SizedBox(height: 24),
                  _LatestInterestsSection(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero — WavyBackground with title ─────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Track Startups outreach and manage investments',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap:
            true, // Add this to prevent infinite height
        physics:
            const NeverScrollableScrollPhysics(), // Add this to disable scrolling
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.0,
        children: [
          const _StatCard(
            label: 'Total Intros',
            value: '27',
            icon: Icons.filter_list,
            iconColor: Color(0xFF4A6CF7),
            iconBgColor: Color(0xFFEAEDFC),
          ),
          const _StatCard(
            label: 'Completed',
            value: '12',
            icon: Icons.trending_up,
            iconColor: Color(0xFFAF52DE),
            iconBgColor: Color(0xFFF5EEFB),
          ),
          _StatCard(
            label: 'Investors',
            value: '16',
            icon: Icons.people_outline,
            iconColor: Color(0xFF34C759),
            iconBgColor: Color(0xFFE8F8ED),
            onTap: () => context.pushNamed(
              'myInvestors',
              pathParameters: {'role': 'startup'},
            ),
          ),
          _StatCard(
            label: 'Startups',
            value: '14',
            icon: Icons.start,
            iconColor: Color(0xFFFF9500),
            iconBgColor: Color(0xFFFFF3E0),
            onTap: () => context.pushNamed('myStartups',
                pathParameters: {'role': 'startup'}),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8A92A8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1A2151),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Tiles ──────────────────────────────────────────────────────────────

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.edit,
            label: 'Create Intro',
            onTap: () => context.pushNamed(
              'createIntro',
              pathParameters: {'role': 'startup'},
            ),
          ),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.add_circle_outline,
            label: 'Add Startup',
            onTap: () => context.pushNamed(
              'addStartup',
              pathParameters: {'role': 'startup'},
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward,
                color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Latest Interests ──────────────────────────────────────────────────────────

class _LatestInterestsSection extends StatelessWidget {
  const _LatestInterestsSection();

  static const _items = [
    _InterestItem(
        name: 'Kebede Chala',
        timeAgo: '1 day ago',
        status: 'Accepted'),
    _InterestItem(
        name: 'Almaz Tesfaye',
        timeAgo: '2 days ago',
        status: 'Declined'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Interests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InterestCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestItem {
  final String name;
  final String timeAgo;
  final String status;

  const _InterestItem({
    required this.name,
    required this.timeAgo,
    required this.status,
  });
}

class _InterestCard extends StatelessWidget {
  final _InterestItem item;

  const _InterestCard({super.key, required this.item});

  Color get _statusColor =>
      switch (item.status.toLowerCase()) {
        'accepted' => const Color(0xFF34C759),
        'declined' => const Color(0xFFFF3B30),
        _ => const Color(0xFF8A92A8),
      };

  Color get _statusBgColor =>
      switch (item.status.toLowerCase()) {
        'accepted' => const Color(0xFFE8F8ED),
        'declined' => const Color(0xFFFFEEED),
        _ => const Color(0xFFF0F1F3),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: Color(0xFF1A2151),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.timeAgo,
            style: const TextStyle(
              color: Color(0xFF8A92A8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status,
              style: TextStyle(
                color: _statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
