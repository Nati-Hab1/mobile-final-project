import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';

class AddStartup extends StatelessWidget {
  const AddStartup({super.key, required this.role});
  final String role;

  void _showSavedDialog(BuildContext context) {
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
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () => {
                            context.goNamed("myStartups",
                                pathParameters: {
                                  'role': 'startup'
                                })
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
                Header(
                  role: role,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => context.pop(),
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
                          "Add an new startup",
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
                                color: Colors.grey.shade300,
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
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              _buildInputField(
                                  "Startup Name"),
                              _buildInputField("BLurb"),
                              _buildInputField(
                                  "Pitch Link (Optional)"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showSavedDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF0022BA),
                              padding: const EdgeInsets
                                  .symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12)),
                            ),
                            child: const Text(
                              "Add Startup",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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

  Widget _buildInputField(String label,
      {bool isPassword = false,
      bool obscureText = false,
      VoidCallback? onSuffixTap}) {
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
          TextField(
            obscureText: obscureText,
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
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                          obscureText
                              ? Icons.visibility_outlined
                              : Icons
                                  .visibility_off_outlined,
                          color: Colors.grey),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
