import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/auth/auth_text_field.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';

/// Register / Sign Up screen — route: /register
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const AuthTextField(
                    label: 'Full Name',
                  ),
                  const SizedBox(height: 16),

                  // Email
                  const AuthTextField(
                    label: 'Email',
                    keyboardType:
                        TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  const AuthTextField(
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  const AuthTextField(
                    label: 'Create Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),

                  // Register button
                  PrimaryButton(
                    label: 'Register',
                    onPressed: () =>
                        context.goNamed('home'),
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
        ],
      ),
    );
  }
}
