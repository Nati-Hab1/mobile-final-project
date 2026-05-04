import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/auth/auth_text_field.dart';
import 'package:menesha/core/widgets/common/primary_button.dart';

/// Login screen — route: /login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController =
      TextEditingController();
  final _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ??
        false) {
      context.go('/role-selection');
    }
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    // Logo
                    ClipOval(
                      child: Image.asset(
                        'assets/images/Menesha.jpg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'warm Introduction Assistant',
                      style: TextStyle(
                        color: Color(0xFFCDD5F3),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Username field
                    AuthTextField(
                      label: 'Username',
                      controller:
                          _usernameController,
                      keyboardType:
                          TextInputType.text,
                      validator: (v) => (v ==
                                  null ||
                              v.trim().isEmpty)
                          ? 'Username is required'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    // Password field
                    AuthTextField(
                      label: 'Password',
                      controller:
                          _passwordController,
                      isPassword: true,
                      validator: (v) => (v ==
                                  null ||
                              v.isEmpty)
                          ? 'Password is required'
                          : null,
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
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 24),

                    // Divider with label
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color:
                                Color(0xFF5A6A9A),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets
                              .symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'or sign in with email',
                            style: TextStyle(
                              color: Color(
                                  0xFF8B9BC8),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color:
                                Color(0xFF5A6A9A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
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
                              color: Color(
                                  0xFF2952FF),
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
          ),
        ],
      ),
    );
  }
}
