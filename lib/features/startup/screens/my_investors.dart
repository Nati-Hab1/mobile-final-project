import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class MyInvestors extends ConsumerStatefulWidget {
  const MyInvestors({super.key});

  @override
  ConsumerState<MyInvestors> createState() => _MyInvestorsState();
}

class _MyInvestorsState extends ConsumerState<MyInvestors> {
  List<Map<String, dynamic>> _investors = [];
  List<Map<String, dynamic>> _filteredInvestors = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInvestors();
    _searchController.addListener(_filterInvestors);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInvestors);
    _searchController.dispose();
    super.dispose();
  }

  void _filterInvestors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredInvestors = List.from(_investors);
      } else {
        _filteredInvestors = _investors.where((investor) {
          return investor['name'].toLowerCase().contains(query) ||
              investor['email'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadInvestors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception('Not authenticated. Please login again.');
      }

      final response = await DioClient.get('/startups/accepted-investors');
      
      if (response.data['success'] == true) {
        final investors = response.data['data']['investors'] as List;
        
        setState(() {
          _investors = investors.map((investor) => {
            'id': investor['id'],
            'name': investor['name'] ?? 'Unknown',
            'email': investor['email'] ?? '',
            'startup_title': investor['startup_title'] ?? '',
          }).toList();
          _filteredInvestors = List.from(_investors);
          _isLoading = false;
        });
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load investors');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
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
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                  label: const Text("Back", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                "My Investors",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage your investor list",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search my investors...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Investors: ${_investors.length}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (_searchController.text.isNotEmpty)
                      Text(
                        'Showing: ${_filteredInvestors.length}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
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
            Text('Loading your investors...', style: TextStyle(color: Colors.white70)),
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
            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadInvestors, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_filteredInvestors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No investors yet',
              style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Investors will appear here when they accept your intros',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredInvestors.length,
      itemBuilder: (context, index) {
        final investor = _filteredInvestors[index];
        return InvestorCard(
          name: investor['name'],
          startup: investor['startup_title'],
          email: investor['email'],
        );
      },
    );
  }
}

class InvestorCard extends StatelessWidget {
  final String name;
  final String startup;
  final String email;

  const InvestorCard({
    required this.name,
    required this.startup,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 70, color: Colors.grey),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: $name",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "Invested in: $startup",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}