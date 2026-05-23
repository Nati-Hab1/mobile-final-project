import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';
import 'dart:ui';

class InvestorStartups extends ConsumerStatefulWidget {
  const InvestorStartups({super.key});

  @override
  ConsumerState<InvestorStartups> createState() =>
      _InvestorStartupsState();
}

class _InvestorStartupsState
    extends ConsumerState<InvestorStartups> {
  List<Map<String, dynamic>> _startups = [];
  List<Map<String, dynamic>> _filteredStartups = [];
  Set<int> _bookmarkedStartupIds = {};
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterStartups);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStartups);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStartups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStartups = List.from(_startups);
      } else {
        _filteredStartups = _startups.where((startup) {
          return startup['title']
                  .toLowerCase()
                  .contains(query) ||
              startup['owner_name']
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null) {
        throw Exception(
            'Not authenticated. Please login again.');
      }

      // Get only intros received by this investor (startups that sent intros)
      final introsResponse =
          await DioClient.get(ApiConstants.myIntros);

      if (introsResponse.data['success'] == true) {
        final intros =
            introsResponse.data['data']['intros'] as List;

        // Extract unique startups from intros
        final uniqueStartups =
            <int, Map<String, dynamic>>{};

        for (var intro in intros) {
          final startupId = intro['startup_id'];
          if (!uniqueStartups.containsKey(startupId)) {
            uniqueStartups[startupId] = {
              'id': startupId,
              'title': intro['startup_title'],
              'blurb': intro['startup_blurb'],
              'owner_name': intro['startup_owner_name'],
              'owner_email': intro['startup_owner_email'],
              'intro_id': intro['id'],
              'intro_text': intro['intro_text'],
              'status': intro['status'] ?? 'pending',
              'created_at': intro['created_at'],
            };
          }
        }

        // Get user's bookmarks to show which startups are bookmarked
        final bookmarksResponse = await DioClient.get(
            ApiConstants.investorBookmarks);
        Set<int> bookmarkedIds = {};

        if (bookmarksResponse.data['success'] == true) {
          final bookmarks = bookmarksResponse.data['data']
              ['bookmarks'] as List;
          for (var bookmark in bookmarks) {
            bookmarkedIds.add(bookmark['startup_id']);
          }
        }

        setState(() {
          _startups = uniqueStartups.values
              .map((s) => ({
                    ...s,
                    'is_bookmarked':
                        bookmarkedIds.contains(s['id']),
                  }))
              .toList();
          _filteredStartups = List.from(_startups);
          _bookmarkedStartupIds = bookmarkedIds;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load intros');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBookmark(
      Map<String, dynamic> startup, int index) async {
    final startupId = startup['id'];
    final wasBookmarked = startup['is_bookmarked'];

    // Optimistic update
    setState(() {
      _startups[index]['is_bookmarked'] = !wasBookmarked;
      final filteredIndex = _filteredStartups
          .indexWhere((s) => s['id'] == startupId);
      if (filteredIndex != -1) {
        _filteredStartups[filteredIndex]['is_bookmarked'] =
            !wasBookmarked;
      }
      if (!wasBookmarked) {
        _bookmarkedStartupIds.add(startupId);
      } else {
        _bookmarkedStartupIds.remove(startupId);
      }
    });

    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null)
        throw Exception('Not authenticated');

      if (!wasBookmarked) {
        // Add bookmark
        await DioClient.post(
          ApiConstants.investorBookmarks,
          data: {'startup_id': startupId},
        );
      } else {
        // Remove bookmark - need to get bookmark ID first
        final bookmarksResponse = await DioClient.get(
            ApiConstants.investorBookmarks);
        if (bookmarksResponse.data['success'] == true) {
          final bookmarks = bookmarksResponse.data['data']
              ['bookmarks'] as List;
          final bookmark = bookmarks.firstWhere(
            (b) => b['startup_id'] == startupId,
            orElse: () => null,
          );
          if (bookmark != null) {
            await DioClient.delete(
                ApiConstants.bookmarkById(bookmark['id']));
          }
        }
      }
    } catch (e) {
      // Revert on error
      setState(() {
        _startups[index]['is_bookmarked'] = wasBookmarked;
        final filteredIndex = _filteredStartups
            .indexWhere((s) => s['id'] == startupId);
        if (filteredIndex != -1) {
          _filteredStartups[filteredIndex]
              ['is_bookmarked'] = wasBookmarked;
        }
        if (wasBookmarked) {
          _bookmarkedStartupIds.add(startupId);
        } else {
          _bookmarkedStartupIds.remove(startupId);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to ${wasBookmarked ? "remove bookmark" : "bookmark"}')),
        );
      }
    }
  }

  Future<void> _declineStartup(
      int startupId, int index) async {
    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null)
        throw Exception('Not authenticated');

      // Find the intro ID for this startup
      final startup =
          _startups.firstWhere((s) => s['id'] == startupId);
      final introId = startup['intro_id'];

      // Update intro status to 'declined'
      final response = await DioClient.patch(
        '/intros/$introId/status',
        data: {'status': 'declined'},
      );

      if (response.data['success'] == true) {
        setState(() {
          _startups.removeAt(index);
          _filteredStartups = List.from(_startups);
        });
      } else {
        throw Exception(response.data['message'] ??
            'Failed to decline');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to decline: ${e.toString().replaceFirst('Exception: ', '')}')),
        );
      }
    }
  }

  void _showDeclineDialog(
      BuildContext context, int startupId, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                      color: Color(0xFF0022BA), width: 2),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        "Delete Startup?",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Are you sure you want to remove this startup from your list?",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              style:
                                  OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color:
                                        Color(0xFF3F48CC)),
                                shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10)),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _declineStartup(
                                    startupId, index);
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10)),
                              ),
                              child: const Text("Delete"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover),
            ),
            const Center(
                child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
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
                  Text(_errorMessage!,
                      style: const TextStyle(
                          color: Colors.white),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry')),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                const Header(role: 'investor'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context
                              .goNamed('investorDashboard'),
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white),
                          label: const Text("Back",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ),
                      const Text(
                        "Startups",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Startups that have sent you intros",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search startups....",
                          prefixIcon:
                              const Icon(Icons.search),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_searchController.text.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Found ${_filteredStartups.length} startups',
                            style: const TextStyle(
                                color: Colors.white70),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _filteredStartups.isEmpty
                      ? const Center(
                          child: Text(
                            'No startup intros yet',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16),
                          itemCount:
                              _filteredStartups.length,
                          itemBuilder: (context, index) {
                            final startup =
                                _filteredStartups[index];
                            return StartupCard(
                              id: startup['id'],
                              name: startup['title'],
                              founderName:
                                  startup['owner_name'],
                              isBookmarked:
                                  startup['is_bookmarked'],
                              onBookmarkToggle: () =>
                                  _toggleBookmark(
                                      startup,
                                      _startups.indexWhere(
                                          (s) =>
                                              s['id'] ==
                                              startup[
                                                  'id'])),
                              onViewIntro: () {
                                context.pushNamed(
                                    'investorIntros',
                                    extra: {
                                      'startupId':
                                          startup['id'],
                                      'startupName':
                                          startup['title'],
                                      'introText': startup[
                                          'intro_text'],
                                    });
                              },
                              onDelete: () =>
                                  _showDeclineDialog(
                                      context,
                                      startup['id'],
                                      _startups.indexWhere(
                                          (s) =>
                                              s['id'] ==
                                              startup[
                                                  'id'])),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StartupCard extends StatelessWidget {
  final int id;
  final String name;
  final String founderName;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onViewIntro;
  final VoidCallback onDelete;

  const StartupCard({
    super.key,
    required this.id,
    required this.name,
    required this.founderName,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onViewIntro,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC4CEDD).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name: $name",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            "Founder: $founderName",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBookmarkToggle,
                child: Icon(
                  isBookmarked
                      ? Icons.star
                      : Icons.star_border,
                  color: isBookmarked
                      ? Colors.amber
                      : Colors.grey[600],
                  size: 28,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onViewIntro,
                    icon: const Icon(Icons.visibility,
                        color: Colors.black),
                    label: const Text("View Intro",
                        style:
                            TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    label: const Text("Delete",
                        style:
                            TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
