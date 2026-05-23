import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/features/investor/presentation/providers/investor_provider.dart';

class InvestorDashboard extends ConsumerStatefulWidget {
  const InvestorDashboard({super.key});

  @override
  ConsumerState<InvestorDashboard> createState() =>
      _InvestorDashboardState();
}

class _InvestorDashboardState
    extends ConsumerState<InvestorDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(investorProvider.notifier).loadDashboard();
    });
  }

  String _formatTimeAgo(String? dateTimeStr) {
    if (dateTimeStr == null) return 'Recently';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      }
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(investorProvider);
    final stats = state.stats;

    if (state.isLoading && stats == null) {
      return Scaffold(
        appBar: const Header(role: 'investor'),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox.expand(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Scaffold(
        appBar: const Header(role: 'investor'),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: const TextStyle(
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(investorProvider.notifier)
                          .loadDashboard();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final latestIntros = state.intros.take(2).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const Header(role: 'investor'),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const _HeroSection(),
                        const SizedBox(height: 24),
                        _StatsSection(
                          totalIntros:
                              stats?.totalIntros ?? 0,
                          followUps: stats?.followUps ?? 0,
                          startupsCount:
                              stats?.startupsCount ?? 0,
                          completedIntros:
                              stats?.completedIntros ?? 0,
                        ),
                        const SizedBox(height: 24),
                        const _ActionsSection(),
                        const SizedBox(height: 24),
                        _LatestIntrosSection(
                          intros: latestIntros,
                          formatTimeAgo: _formatTimeAgo,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
            'Track startups outreach and manage investments',
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

class _StatsSection extends StatelessWidget {
  final int totalIntros;
  final int followUps;
  final int startupsCount;
  final int completedIntros;

  const _StatsSection({
    required this.totalIntros,
    required this.followUps,
    required this.startupsCount,
    required this.completedIntros,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.0,
        children: [
          _StatCard(
            label: 'Total Intros',
            value: totalIntros.toString(),
            icon: Icons.filter_list,
            iconColor: const Color(0xFF4A6CF7),
            iconBgColor: const Color(0xFFEAEDFC),
          ),
          _StatCard(
            label: 'Follow-ups',
            value: followUps.toString(),
            icon: Icons.access_time,
            iconColor: const Color(0xFFFF9500),
            iconBgColor: const Color(0xFFFFF3E0),
          ),
          _StatCard(
            label: 'Startups',
            value: startupsCount.toString(),
            icon: Icons.people_outline,
            iconColor: const Color(0xFF34C759),
            iconBgColor: const Color(0xFFE8F8ED),
            onTap: () =>
                context.pushNamed('investorStartups'),
          ),
          _StatCard(
            label: 'Completed',
            value: completedIntros.toString(),
            icon: Icons.trending_up,
            iconColor: const Color(0xFFAF52DE),
            iconBgColor: const Color(0xFFF5EEFB),
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

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.bookmark_outline,
            label: 'View Bookmarks',
            onTap: () => context.pushNamed('bookmarks'),
          ),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.add_circle_outline,
            label: 'Get in touch',
            onTap: () => context.pushNamed('contactUs'),
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

class _LatestIntrosSection extends StatelessWidget {
  final List<dynamic> intros;
  final String Function(String?) formatTimeAgo;

  const _LatestIntrosSection({
    required this.intros,
    required this.formatTimeAgo,
  });

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
          if (intros.isEmpty)
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No interests yet',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ...intros.map(
              (intro) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _IntroCard(
                  startupName: intro.startupTitle,
                  founderName: intro.startupOwnerName,
                  timeAgo: formatTimeAgo(
                      intro.createdAt.toIso8601String()),
                  message: intro.introText,
                  status: intro.status ?? 'pending',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final String startupName;
  final String founderName;
  final String timeAgo;
  final String message;
  final String status;

  const _IntroCard({
    required this.startupName,
    required this.founderName,
    required this.timeAgo,
    required this.message,
    required this.status,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color.fromARGB(255, 6, 180, 49);
      case 'declined':
        return const Color.fromARGB(255, 206, 40, 31);
      default:
        return const Color.fromARGB(255, 147, 114, 14);
    }
  }

  Color get _statusBgColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color.fromARGB(100, 112, 250, 156);
      case 'declined':
        return const Color.fromARGB(100, 254, 133, 127);
      default:
        return const Color.fromARGB(100, 233, 189, 87);
    }
  }

  String get _statusText {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Accepted';
      case 'declined':
        return 'Declined';
      default:
        return 'Pending';
    }
  }

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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  startupName,
                  style: const TextStyle(
                    color: Color(0xFF1A2151),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            founderName,
            style: const TextStyle(
              color: Color(0xFF1A2151),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: const TextStyle(
              color: Color(0xFF8A92A8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
