import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/features/startup/presentation/providers/startup_provider.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class StartupDashboard extends ConsumerStatefulWidget {
  const StartupDashboard({super.key});

  @override
  ConsumerState<StartupDashboard> createState() => _StartupDashboardState();
}

class _StartupDashboardState extends ConsumerState<StartupDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(startupStatsProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(startupStatsProvider);

    return Scaffold(
      appBar: const Header(role: 'startup'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _HeroSection(),
                        const SizedBox(height: 24),
                        statsAsync.when(
                          loading: () => const _LoadingStatsSection(),
                          error: (error, stack) =>
                              _ErrorStatsSection(error: error),
                          data: (stats) => _StatsSection(stats: stats),
                        ),
                        const SizedBox(height: 24),
                        const _ActionsSection(),
                        const SizedBox(height: 24),
                        const _LatestInterestsSection(),
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

// Hero Section

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
            'Track your startup outreach and manage investments',
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

// Loading Stats Section

class _LoadingStatsSection extends StatelessWidget {
  const _LoadingStatsSection();

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
        children: const [
          _StatCardLoading(),
          _StatCardLoading(),
          _StatCardLoading(),
          _StatCardLoading(),
        ],
      ),
    );
  }
}

class _StatCardLoading extends StatelessWidget {
  const _StatCardLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 12,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey[300],
              ),
            ],
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

// Error Stats Section

class _ErrorStatsSection extends ConsumerWidget {
  final Object error;

  const _ErrorStatsSection({
    required this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load stats: ${error.toString()}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read(startupStatsProvider.notifier).loadStats();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Stats Grid with Dynamic Data

class _StatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _StatsSection({required this.stats});

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
            value: stats['total_intros']?.toString() ?? '0',
            icon: Icons.filter_list,
            iconColor: const Color(0xFF4A6CF7),
            iconBgColor: const Color(0xFFEAEDFC),
          ),
          _StatCard(
            label: 'Completed',
            value: stats['completed_intros']?.toString() ?? '0',
            icon: Icons.trending_up,
            iconColor: const Color(0xFFAF52DE),
            iconBgColor: const Color(0xFFF5EEFB),
          ),
          _StatCard(
            label: 'Investors',
            value: stats['investors_count']?.toString() ?? '0',
            icon: Icons.people_outline,
            iconColor: const Color(0xFF34C759),
            iconBgColor: const Color(0xFFE8F8ED),
            onTap: () => context.pushNamed('myInvestors'),
          ),
          _StatCard(
            label: 'Startups',
            value: stats['startups_count']?.toString() ?? '0',
            icon: Icons.start,
            iconColor: const Color(0xFFFF9500),
            iconBgColor: const Color(0xFFFFF3E0),
            onTap: () => context.pushNamed('myStartups'),
          ),
        ],
      ),
    );
  }
}

// Stat Card Widget

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

// Action Tiles

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
            onTap: () => context.pushNamed('createIntro'),
          ),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.add_circle_outline,
            label: 'Add Startup',
            onTap: () => context.pushNamed('addStartup'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            const Icon(Icons.arrow_forward, color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }
}

// Latest Interests Section

class _LatestInterestsSection extends ConsumerStatefulWidget {
  const _LatestInterestsSection();

  @override
  ConsumerState<_LatestInterestsSection> createState() =>
      _LatestInterestsSectionState();
}

class _LatestInterestsSectionState
    extends ConsumerState<_LatestInterestsSection> {
  List<Map<String, dynamic>> _latestInterests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestInterests();
  }

  Future<void> _loadLatestInterests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      print('Token: ${token?.substring(0, 20)}...'); // DEBUG

      if (token == null) {
        print('No token found!'); // DEBUG
        setState(() => _isLoading = false);
        return;
      }

      final response = await DioClient.get('/startups/latest-interests');

      print('STATUS CODE: ${response.statusCode}'); // DEBUG
      print('FULL RESPONSE: ${response.data}'); // DEBUG

      if (response.data['success'] == true) {
        final interests = response.data['data']['interests'] as List;
        print('INTERESTS COUNT: ${interests.length}'); // DEBUG

        setState(() {
          _latestInterests = interests
              .map((interest) => {
                    'investor_name': interest['investor_name'] ?? 'Unknown',
                    'investor_email': interest['investor_email'] ?? '',
                    'startup_title': interest['startup_title'] ?? '',
                    'status': interest['status'] ?? 'pending',
                    'created_at': interest['created_at'],
                    'message': interest['message'] ?? '',
                  })
              .toList();
          _isLoading = false;
        });

        print('MAPPED INTERESTS: $_latestInterests'); // DEBUG
      } else {
        print('API ERROR: ${response.data['message']}'); // DEBUG
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('EXCEPTION: $e'); // DEBUG
      setState(() => _isLoading = false);
    }
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
          if (_isLoading)
            const SizedBox(
              height: 80,
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_latestInterests.isEmpty)
            const SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'No interests yet',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ..._latestInterests.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InterestCard(
                  name: item['investor_name'],
                  startupName: item['startup_title'],
                  timeAgo: _formatTimeAgo(item['created_at']),
                  status: item['status'],
                  message: item['message'],
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  final String name;
  final String startupName;
  final String timeAgo;
  final String status;
  final String message; // Kept for data but not displayed

  const _InterestCard({
    required this.name,
    required this.startupName,
    required this.timeAgo,
    required this.status,
    required this.message,
  });

  Color get _statusColor => switch (status.toLowerCase()) {
        'accepted' => const Color(0xFF34C759),
        'declined' => const Color(0xFFFF3B30),
        _ => const Color(0xFF8A92A8),
      };

  Color get _statusBgColor => switch (status.toLowerCase()) {
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
            name,
            style: const TextStyle(
              color: Color(0xFF1A2151),
              fontSize: 15,
              fontWeight: FontWeight.w600,
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

          const SizedBox(height: 14),

          // Status badge below
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _statusBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
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
