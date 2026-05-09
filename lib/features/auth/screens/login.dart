import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/auth/auth_text_field.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';

/// Login screen — route: /login
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                vertical: 32,
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
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Welcome back',
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
                  const SizedBox(height: 36),

                  // Username field
                  const AuthTextField(
                    label: 'Username',
                    keyboardType:
                        TextInputType.text,
                  ),
                  const SizedBox(height: 18),

                  // Password field
                  const AuthTextField(
                    label: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),

                  // Forget password
                  Align(
                    alignment:
                        Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                          color:
                              Color(0xFF2952FF),
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login button
                  PrimaryButton(
                    label: 'Log in',
                    onPressed: () => context
                        .go('/role-selection'),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                            color: Color(
                                0xFF5A6A9A)),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(
                                horizontal: 12),
                        child: Text(
                          'or sign in with email',
                          style: TextStyle(
                            color:
                                Color(0xFF8B9BC8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                            color: Color(
                                0xFF5A6A9A)),
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
                          color:
                              Color(0xFFCDD5F3),
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context
                            .go('/register'),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color:
                                Color(0xFF2952FF),
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
