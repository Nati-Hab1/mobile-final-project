import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class CreateIntro extends ConsumerStatefulWidget {
  const CreateIntro({super.key});

  @override
  ConsumerState<CreateIntro> createState() =>
      _CreateIntroState();
}

class _CreateIntroState extends ConsumerState<CreateIntro> {
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _messageController =
      TextEditingController();

  List<Map<String, dynamic>> _startups = [];
  String? _selectedStartupId;
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStartups();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadStartups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Get ONLY the user's own startups
      final response =
          await DioClient.get(ApiConstants.myStartups);

      if (response.data['success'] == true) {
        final startups =
            response.data['data']['startups'] as List;

        setState(() {
          _startups = startups
              .map((s) => {
                    'id': s['id'],
                    'title': s['title'],
                  })
              .toList();

          if (_startups.isNotEmpty) {
            _selectedStartupId =
                _startups.first['id'].toString();
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load your startups');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _sendIntro() async {
    if (_selectedStartupId == null) {
      _showErrorDialog('Please select a startup');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter investor email');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showErrorDialog('Please enter an intro message');
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // First, find the investor by email
      final usersResponse = await DioClient.get(
          '/auth/users/all?search=${_emailController.text.trim()}');
      int? investorId;

      if (usersResponse.data['success'] == true) {
        final users =
            usersResponse.data['data']['users'] as List;
        final investor = users.firstWhere(
          (user) =>
              user['email'].toLowerCase() ==
              _emailController.text.trim().toLowerCase(),
          orElse: () => null,
        );

        if (investor == null) {
          throw Exception(
              'No user found with email: ${_emailController.text}');
        }

        investorId = investor['id'];
      } else {
        throw Exception('Failed to search for user');
      }

      // Send intro
      final response = await DioClient.post(
        ApiConstants.intros,
        data: {
          'startup_id': int.parse(_selectedStartupId!),
          'investor_id': investorId,
          'intro_text': _messageController.text.trim(),
        },
      );

      if (response.data['success'] == true) {
        _emailController.clear();
        _messageController.clear();
        _showSuccessDialog();
      } else {
        throw Exception(response.data['message'] ??
            'Failed to send intro');
      }
    } catch (e) {
      _showErrorDialog(
          e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
                color: Colors.blue.shade900, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Intro Sent",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your intro has been sent to ${_emailController.text}",
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.goNamed('startupDashboard');
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const Header(role: 'startup'),
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
      appBar: const Header(role: 'startup'),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        context.goNamed('startupDashboard'),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 16, color: Colors.white),
                    label: const Text("Back",
                        style:
                            TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Create Intro Drafts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create and customize your investor introductions before sending.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Card 1: Select Startup Dropdown
                buildStartupCard(),

                // Card 2: Investor Email Input
                buildEmailCard(),

                // Card 3: Intro Message Input
                buildMessageCard(),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 30),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue.shade900,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10)),
                          ),
                          onPressed: _isSending
                              ? null
                              : _sendIntro,
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:
                                              Colors.white),
                                )
                              : const Text("Send"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10)),
                          ),
                          onPressed: () {
                            context.goNamed(
                                'startupDashboard');
                          },
                          child: const Text("Back"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStartupCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Your Startup",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedStartupId,
              underline: const SizedBox(),
              items: _startups.map((startup) {
                return DropdownMenuItem(
                  value: startup['id'].toString(),
                  child: Text(startup['title']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStartupId = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Investor Email",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "investor@example.com",
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Intro Message",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _messageController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText:
                    "Write your intro message here...\n\nExample:\nHi [Investor Name],\n\nI wanted to introduce you to [Startup Name]...",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  // Copy message to clipboard
                  // Clipboard.setData(ClipboardData(text: _messageController.text));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                        content: Text('Message copied!')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(58, 26),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5)),
                ),
                child: const Text("Copy"),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  // Edit functionality - clear or set template
                  _messageController.clear();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(58, 26),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5)),
                ),
                child: const Text("Clear"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
