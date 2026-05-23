import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';

class ProfileSettings extends ConsumerStatefulWidget {
  const ProfileSettings({super.key, required this.role});
  final String role;

  @override
  ConsumerState<ProfileSettings> createState() =>
      _ProfileSettingsState();
}

class _ProfileSettingsState
    extends ConsumerState<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getMainToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response =
          await DioClient.get(ApiConstants.getMe);

      if (response.data['success'] == true) {
        final user = response.data['data']['user'];
        _fullNameController.text = user['full_name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone_number'] ?? '';

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception(response.data['message'] ??
            'Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final token = await SecureStorage.getMainToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Build update data (only include fields that have values)
      final Map<String, dynamic> updateData = {};

      if (_fullNameController.text.isNotEmpty) {
        updateData['full_name'] =
            _fullNameController.text.trim();
      }
      if (_emailController.text.isNotEmpty) {
        updateData['email'] = _emailController.text.trim();
      }
      if (_phoneController.text.isNotEmpty) {
        updateData['phone_number'] =
            _phoneController.text.trim();
      }
      if (_passwordController.text.isNotEmpty) {
        if (_passwordController.text.length < 6) {
          throw Exception(
              'Password must be at least 6 characters');
        }
        updateData['password'] = _passwordController.text;
      }

      if (updateData.isEmpty) {
        throw Exception('No changes to save');
      }

      final response = await DioClient.patch(
        ApiConstants.profile,
        data: updateData,
      );

      if (response.data['success'] == true) {
        // Clear password field after successful save
        _passwordController.clear();
        _showSuccessDialog(context);

        // Update stored user data if email changed
        if (updateData.containsKey('email')) {
          // Re-login might be needed, but for now just show message
        }
      } else {
        throw Exception(response.data['message'] ??
            'Failed to update profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
      _showErrorDialog(context, _errorMessage!);
    } finally {
      setState(() {
        _isSaving = false;
      });
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
                        "Saved",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Your profile has been updated",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Refresh profile data
                            _loadUserProfile();
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
                Header(role: widget.role),
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
                            "Settings",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Manage your profile and preferences",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 20),

                          // Tab indicator
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 45,
                                    vertical: 10),
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
                              "Personal Profile",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Form Card
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 30),
                            padding: const EdgeInsets.only(
                              bottom: 60,
                              left: 24,
                              right: 24,
                              top: 24,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Personal Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                const SizedBox(height: 25),
                                _buildInputField(
                                  "Full Name",
                                  controller:
                                      _fullNameController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Full name is required';
                                    }
                                    if (value.length < 2) {
                                      return 'Name must be at least 2 characters';
                                    }
                                    return null;
                                  },
                                ),
                                _buildInputField(
                                  "Email",
                                  controller:
                                      _emailController,
                                  keyboardType:
                                      TextInputType
                                          .emailAddress,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!value.contains(
                                            '@') ||
                                        !value.contains(
                                            '.')) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                _buildInputField(
                                  "Phone",
                                  controller:
                                      _phoneController,
                                  keyboardType:
                                      TextInputType.phone,
                                  validator: (value) {
                                    // Phone is optional
                                    return null;
                                  },
                                ),
                                _buildInputField(
                                  "Password",
                                  controller:
                                      _passwordController,
                                  isPassword: true,
                                  hintText:
                                      "Leave blank to keep current password",
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        value.length < 6) {
                                      return 'Password must be at least 6 characters';
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

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving
                                  ? null
                                  : _saveProfile,
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
                              child: _isSaving
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
                                      "Save Changes",
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
    TextInputType? keyboardType,
    bool isPassword = false,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    final obscureTextNotifier = ValueNotifier<bool>(true);

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
          ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return TextFormField(
                controller: controller,
                obscureText:
                    isPassword ? obscureText : false,
                keyboardType: keyboardType,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF0022BA))),
                  errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.red)),
                  suffixIcon: isPassword
                      ? GestureDetector(
                          onTap: () {
                            obscureTextNotifier.value =
                                !obscureText;
                          },
                          child: Icon(
                              obscureText
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                              color: Colors.grey),
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
