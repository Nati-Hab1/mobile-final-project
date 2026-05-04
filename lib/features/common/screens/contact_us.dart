import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/home/header.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GuestHeader(
        actions: [
          GestureDetector(
            onTap: () =>
                context.go('/role-selection'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Color(
                  0xFF2952FF,
                ),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/guest'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(
                  0xFF2952FF,
                )),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Text(
                'Log out',
                style: TextStyle(
                  color: Color(
                    0xFF2952FF,
                  ),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: const Text("data"),
      ),
    );
  }
}
