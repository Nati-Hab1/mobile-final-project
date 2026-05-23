import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class InvestorBookmarks extends ConsumerStatefulWidget {
  const InvestorBookmarks({super.key});

  @override
  ConsumerState<InvestorBookmarks> createState() =>
      _InvestorBookmarksState();
}

class _InvestorBookmarksState
    extends ConsumerState<InvestorBookmarks> {
  List<Map<String, dynamic>> _bookmarks = [];
  List<Map<String, dynamic>> _filteredBookmarks = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_filterBookmarks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBookmarks);
    _searchController.dispose();
    super.dispose();
  }

  void _filterBookmarks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBookmarks = List.from(_bookmarks);
      } else {
        _filteredBookmarks = _bookmarks.where((bookmark) {
          return bookmark['startup_title']
                  .toLowerCase()
                  .contains(query) ||
              bookmark['owner_name']
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await DioClient.get(
          ApiConstants.investorBookmarks);

      if (response.data['success'] == true) {
        final bookmarks =
            response.data['data']['bookmarks'] as List;

        setState(() {
          _bookmarks = bookmarks
              .map((b) => {
                    'id': b['id'],
                    'startup_id': b['startup_id'],
                    'startup_title': b['startup_title'],
                    'startup_blurb': b['startup_blurb'],
                    'owner_name': b['startup_owner_name'],
                    'note': b['note'],
                    'created_at': b['created_at'],
                  })
              .toList();
          _filteredBookmarks = List.from(_bookmarks);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(
      int bookmarkId, int index) async {
    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null)
        throw Exception('Not authenticated');

      final response = await DioClient.delete(
          ApiConstants.bookmarkById(bookmarkId));

      if (response.data['success'] == true) {
        setState(() {
          _bookmarks.removeAt(index);
          _filteredBookmarks = List.from(_bookmarks);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Bookmark removed'),
                backgroundColor: Colors.green),
          );
        }
      } else {
        throw Exception('Failed to delete bookmark');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${e.toString().replaceFirst('Exception: ', '')}'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showDeleteDialog(
      BuildContext context, int bookmarkId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text(
            'Are you sure you want to remove this bookmark?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBookmark(bookmarkId, index);
            },
            style: TextButton.styleFrom(
                foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
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
                        "Bookmarks",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Manage your bookmarked startups",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search bookmarks...",
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _filteredBookmarks.isEmpty
                      ? const Center(
                          child: Text(
                            'No bookmarks yet',
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
                              _filteredBookmarks.length,
                          itemBuilder: (context, index) {
                            final bookmark =
                                _filteredBookmarks[index];
                            return StartupCard(
                              id: bookmark['id'],
                              name:
                                  bookmark['startup_title'],
                              ownerName:
                                  bookmark['owner_name'],
                              note: bookmark['note'],
                              onDelete: () =>
                                  _showDeleteDialog(
                                      context,
                                      bookmark['id'],
                                      _bookmarks
                                          .indexWhere((b) =>
                                              b['id'] ==
                                              bookmark[
                                                  'id'])),
                              onAddNote: () =>
                                  context.pushNamed(
                                'investorNotes',
                                extra: {
                                  'bookmarkId':
                                      bookmark['id'],
                                  'startupName': bookmark[
                                      'startup_title'],
                                  'currentNote':
                                      bookmark['note'],
                                },
                              ),
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
  final String ownerName;
  final String? note;
  final VoidCallback onDelete;
  final VoidCallback onAddNote;

  const StartupCard({
    super.key,
    required this.id,
    required this.name,
    required this.ownerName,
    this.note,
    required this.onDelete,
    required this.onAddNote,
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
            name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            "Founder: $ownerName",
            style: const TextStyle(
                fontSize: 13, color: Colors.grey),
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFC4CEDD)
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Note: $note',
                style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.star,
                    color: Colors.yellow, size: 28),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onAddNote,
                    icon: const Icon(Icons.edit,
                        color: Colors.black),
                    label: const Text("Add Note",
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
