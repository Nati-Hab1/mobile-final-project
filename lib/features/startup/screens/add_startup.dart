import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class AddStartup extends ConsumerStatefulWidget {
  const AddStartup({super.key});

  @override
  ConsumerState<AddStartup> createState() =>
      _AddStartupState();
}

class _AddStartupState extends ConsumerState<AddStartup> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _blurbController = TextEditingController();
  final _pitchLinkController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _blurbController.dispose();
    _pitchLinkController.dispose();
    super.dispose();
  }

  Future<void> _createStartup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get startup token
      final token = await SecureStorage.getStartupToken();
      if (token == null) {
        throw Exception(
            'Not authenticated. Please login again.');
      }

      // Create startup
      final response = await DioClient.post(
        ApiConstants.startups,
        data: {
          'title': _titleController.text.trim(),
          'blurb': _blurbController.text.trim(),
          'pitch_link':
              _pitchLinkController.text.trim().isEmpty
                  ? null
                  : _pitchLinkController.text.trim(),
        },
      );

      if (response.data['success'] == true) {
        // Show success dialog
        _showSuccessDialog(context);

        // Clear form
        _titleController.clear();
        _blurbController.clear();
        _pitchLinkController.clear();
      } else {
        throw Exception(response.data['message'] ??
            'Failed to create startup');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
      _showErrorDialog(context, _errorMessage!);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(255, 232, 230, 230)
          .withOpacity(0.3),
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
                        "New Startup Added",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _titleController.text,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Optionally navigate back or refresh dashboard
                          },
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

  void _showErrorDialog(
      BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                const Header(role: 'startup'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () =>
                                  context.pop(),
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
                            "Add Startup",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Add a new startup",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 20),

                          // Tab indicator
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      Colors.grey.shade300,
                                  width: 4),
                            ),
                            child: const Text(
                              "Startup Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Form Card
                          Container(
                            padding:
                                const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildInputField(
                                  "Startup Name",
                                  controller:
                                      _titleController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Startup name is required';
                                    }
                                    if (value.length < 3) {
                                      return 'Name must be at least 3 characters';
                                    }
                                    return null;
                                  },
                                ),
                                _buildInputField(
                                  "Blurb",
                                  controller:
                                      _blurbController,
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Blurb is required';
                                    }
                                    if (value.length < 10) {
                                      return 'Blurb must be at least 10 characters';
                                    }
                                    return null;
                                  },
                                ),
                                _buildInputField(
                                  "Pitch Link (Optional)",
                                  controller:
                                      _pitchLinkController,
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty) {
                                      if (!value.startsWith(
                                          'http')) {
                                        return 'Enter a valid URL starting with http:// or https://';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(top: 16),
                                    child: Text(
                                      _errorMessage!,
                                      style:
                                          const TextStyle(
                                              color: Colors
                                                  .red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _createStartup,
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0022BA),
                                padding: const EdgeInsets
                                    .symmetric(
                                    vertical: 16),
                                shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<
                                                    Color>(
                                                Colors
                                                    .white),
                                      ),
                                    )
                                  : const Text(
                                      "Add Startup",
                                      style: TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight
                                                  .bold),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildInputField(
    String label, {
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF0022BA))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
