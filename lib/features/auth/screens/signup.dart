import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/auth/auth_text_field.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';
import 'package:menesha/features/auth/presentation/providers/auth_provider.dart';

/// Register / Sign Up screen — route: /register
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isRegistering = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Update local loading state
    _isRegistering = authState.isLoading;
    
    // Listen for registration completion
    ref.listen(authProvider, (previous, next) {
      // Registration completed successfully (user exists but no token)
      if (!next.isLoading && next.user != null && !next.isAuthenticated) {
        // Navigate to role selection
        context.goNamed('home');
      }
      
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 28,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Menesha.jpg',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Warm Introduction Assistant',
                      style: TextStyle(
                        color: Color(0xFFCDD5F3),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Full Name
                    AuthTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AuthTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    AuthTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        // Phone is optional
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthTextField(
                      label: 'Create Password',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Register button
                    PrimaryButton(
                      label: 'Register',
                      isLoading: _isRegistering,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                              color: Color(0xFF5A6A9A)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12),
                          child: Text(
                            'or sign up with email',
                            style: TextStyle(
                              color: Color(0xFF8B9BC8),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                              color: Color(0xFF5A6A9A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Login link
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFFCDD5F3),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.goNamed('login'),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Color(0xFF2952FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          
          // Loading overlay
          if (_isRegistering)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
      );
    }
  }
}