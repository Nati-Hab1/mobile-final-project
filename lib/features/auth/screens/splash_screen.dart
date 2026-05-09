import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Initial splash / loading screen. Auto-navigates to /guest after 2.5 seconds.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to guest dashboard after splash
    Future.delayed(
        const Duration(milliseconds: 2500), () {
      if (context.mounted) {
        context.go('/guest');
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
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Menesha.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 36,
                  height: 36,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<
                            Color>(
                      Colors.white
                          .withOpacity(0.7),
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
