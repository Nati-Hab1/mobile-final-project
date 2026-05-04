import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/theme/app_theme.dart';
import 'package:menesha/core/widgets/common/app_logo.dart';
import 'package:menesha/core/widgets/auth/auth_text_field.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';
import 'package:menesha/core/widgets/common/wavy_background.dart';

/// Login screen — route: /login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to role selection (no state management — UI only)
      context.go('/role-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WavyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 32,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  // Logo
                  const AppLogo(size: 56),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'warm Introduction Assistant',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Username field
                  AuthTextField(
                    label: 'Username',
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Username is required'
                            : null,
                  ),
                  const SizedBox(height: 18),

                  // Password field
                  AuthTextField(
                    label: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (v) =>
                        (v == null || v.isEmpty)
                            ? 'Password is required'
                            : null,
                  ),
                  const SizedBox(height: 10),

                  // Forget password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        // Placeholder — no backend
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                          color: AppColors.accentBlueBright,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login button
                  PrimaryButton(
                    label: 'Log in',
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),

                  // Divider with label
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(
                            0xFF5A6A9A,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          'or sign in with email',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(
                            0xFF5A6A9A,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(
                          '/register',
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color:
                                AppColors.accentBlueBright,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
