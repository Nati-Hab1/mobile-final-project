import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class MyStartups extends ConsumerStatefulWidget {
  const MyStartups({super.key});

  @override
  ConsumerState<MyStartups> createState() => _MyStartupsState();
}

class _MyStartupsState extends ConsumerState<MyStartups> {
  List<Map<String, dynamic>> _startups = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadStartups();
  }

  Future<void> _loadStartups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception('Not authenticated. Please login again.');
      }

      final response = await DioClient.get(ApiConstants.myStartups);

      if (response.data['success'] == true) {
        final startupsData = response.data['data']['startups'] as List;

        // Fetch stats for each startup (intros and investors count)
        List<Map<String, dynamic>> enrichedStartups = [];
        for (var startup in startupsData) {
          final startupId = startup['id'];

          // Get intros count for this startup
          int introsCount = 0;
          int investorsCount = 0;

          try {
            final introsResponse = await DioClient.get(
              ApiConstants.startupInterests(startupId),
            );
            if (introsResponse.data['success'] == true) {
              final intros = introsResponse.data['data']['interests'] as List;
              introsCount = intros.length;

              // Count unique investors
              final uniqueInvestors =
                  intros.map((i) => i['investor_id']).toSet();
              investorsCount = uniqueInvestors.length;
            }
          } catch (e) {
            // No intros yet for this startup
          }

          enrichedStartups.add({
            'id': startupId,
            'name': startup['title'],
            'desc': startup['blurb'],
            'pitch_link': startup['pitch_link'],
            'intros': introsCount,
            'investors': investorsCount,
          });
        }

        setState(() {
          _startups = enrichedStartups;
          _isLoading = false;
        });
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load startups');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteStartup(int startupId, int index) async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await DioClient.delete(
        ApiConstants.startupById(startupId),
      );

      if (response.data['success'] == true) {
        // Remove from local list
        setState(() {
          _startups.removeAt(index);
          _isDeleting = false;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Startup deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete startup');
      }
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, int startupId, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.blue.shade900,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Confirm delete: Are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _startups[index]['name'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(75, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: _isDeleting
                          ? null
                          : () async {
                              Navigator.pop(context);
                              await _deleteStartup(startupId, index);
                            },
                      child: _isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text("Yes"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(75, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text("No"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(role: 'startup'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.goNamed('startupDashboard'),
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 16, color: Colors.white),
                  label:
                      const Text("Back", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "My Startups",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage your startup profiles",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // New Startup Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(61, 61, 180, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed('addStartup');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("New Startup"),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading your startups...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStartups,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_startups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_center_outlined,
                color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No startups yet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add your first startup',
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _startups.length,
      itemBuilder: (context, index) {
        final item = _startups[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(item["desc"]),
                    if (item["pitch_link"] != null &&
                        item["pitch_link"].isNotEmpty) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Open pitch link
                        },
                        child: Text(
                          'View Pitch',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Intros Sent"),
                            Text(
                              item["intros"].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 80),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Investors"),
                            Text(
                              item["investors"].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: _isDeleting
                      ? null
                      : () {
                          _showDeleteDialog(context, item['id'], index);
                        },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
