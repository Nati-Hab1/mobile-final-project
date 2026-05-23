import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class InvestorIntrosPage extends ConsumerStatefulWidget {
  const InvestorIntrosPage({super.key});

  @override
  ConsumerState<InvestorIntrosPage> createState() =>
      _InvestorIntrosPageState();
}

class _InvestorIntrosPageState
    extends ConsumerState<InvestorIntrosPage> {
  List<Map<String, dynamic>> _intros = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _startupId;
  String? _startupName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map?;
    if (extra != null) {
      _startupId = extra['startupId'];
      _startupName = extra['startupName'];
    }
    _loadIntros();
  }

  Future<void> _loadIntros() async {
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

      final response =
          await DioClient.get(ApiConstants.myIntros);

      if (response.data['success'] == true) {
        final intros =
            response.data['data']['intros'] as List;

        List<Map<String, dynamic>> filteredIntros = [];
        if (_startupId != null) {
          filteredIntros = intros
              .where((intro) =>
                  intro['startup_id'] == _startupId)
              .map((intro) => {
                    'id': intro['id'],
                    'startup_id': intro['startup_id'],
                    'startup_title': intro['startup_title'],
                    'startup_blurb': intro['startup_blurb'],
                    'startup_owner_name':
                        intro['startup_owner_name'],
                    'startup_owner_email':
                        intro['startup_owner_email'],
                    'intro_text': intro['intro_text'],
                    'status': intro['status'] ?? 'pending',
                    'created_at': intro['created_at'],
                  })
              .toList();
        } else {
          filteredIntros = intros
              .map((intro) => {
                    'id': intro['id'],
                    'startup_id': intro['startup_id'],
                    'startup_title': intro['startup_title'],
                    'startup_blurb': intro['startup_blurb'],
                    'startup_owner_name':
                        intro['startup_owner_name'],
                    'startup_owner_email':
                        intro['startup_owner_email'],
                    'intro_text': intro['intro_text'],
                    'status': intro['status'] ?? 'pending',
                    'created_at': intro['created_at'],
                  })
              .toList();
        }

        setState(() {
          _intros = filteredIntros;
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

  Future<void> _acceptIntro(int introId) async {
    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null)
        throw Exception('Not authenticated');

      final response = await DioClient.patch(
        '/intros/$introId/status',
        data: {'status': 'accepted'},
      );

      if (response.data['success'] == true) {
        setState(() {
          final index = _intros.indexWhere(
              (intro) => intro['id'] == introId);
          if (index != -1) {
            _intros[index]['status'] = 'accepted';
          }
        });

        if (mounted) {
          _showAcceptedDialog(context);
        }
      } else {
        throw Exception(response.data['message'] ??
            'Failed to accept intro');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to accept: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAcceptedDialog(BuildContext context) {
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
                      const Icon(Icons.check_circle,
                          color: Color(0xFF20C997),
                          size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        "Accepted",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You have accepted the intro from $_startupName",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () => context
                              .goNamed('investorStartups'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF3F48CC),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10)),
                          ),
                          child: const Text("Close",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
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

  String _formatDate(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
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
                      onPressed: _loadIntros,
                      child: const Text('Retry')),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_intros.isEmpty) {
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
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox_outlined,
                              color: Colors.white70,
                              size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            'No intros found',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _startupName != null
                                ? 'No intros from $_startupName yet'
                                : 'When startups send you intros, they will appear here',
                            style: const TextStyle(
                                color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () =>
                                context.goNamed(
                                    'investorStartups'),
                            child: const Text(
                                'Back to Startups'),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context
                              .goNamed('investorStartups'),
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white),
                          label: const Text("Back",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ),
                      Center(
                        child: Text(
                          _startupName != null
                              ? "Intros from $_startupName"
                              : "My Intros",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Review and respond to startup introductions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ..._intros.map((intro) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20),
                            child: _buildIntroCard(intro),
                          )),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(Map<String, dynamic> intro) {
    final isPending = intro['status'] == 'pending';
    final isAccepted = intro['status'] == 'accepted';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F0F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Startup Name: ${intro['startup_title']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                    "Founder: ${intro['startup_owner_name']}"),
                const SizedBox(height: 4),
                Text(
                    "Email: ${intro['startup_owner_email']}"),
                const SizedBox(height: 4),
                Text(
                    "Sent: ${_formatDate(intro['created_at'])}",
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    intro['intro_text'],
                    style: const TextStyle(
                        fontSize: 14, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),
                if (isAccepted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.green
                              .withOpacity(0.5)),
                    ),
                    child: const Center(
                      child: Text(
                        "Accepted ✓",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                else if (isPending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _acceptIntro(intro['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF0022BA),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Center(
                      child: Text(
                        "Declined",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
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
