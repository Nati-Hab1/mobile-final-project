import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'dart:ui';

class InvestorNotes extends StatelessWidget {
  const InvestorNotes({super.key, required this.role});
  final String role;

  void _showSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(255, 232, 230, 230)
          .withOpacity(0.3), // slight dark overlay
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 🔹 Blur Background
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),

            // 🔹 Dialog
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
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF20C997),
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Saved",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () => context.goNamed(
                            "bookmarks",
                            pathParameters: {
                              'role': 'investor'
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF3F48CC),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.white),
                          ),
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
    final TextEditingController _noteController =
        TextEditingController(
      text:
          "I wanted to check this idea later as it caught my attention and i think its a good idea.\n\ndate: 12/01/2025",
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image referencing image_0357dd.png
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Header(
                  role: role,
                ),

                // Back and Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context.goNamed(
                            "bookmarks",
                            pathParameters: {
                              'role': 'investor'
                            },
                          ),
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
                        "Notes",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add a note on your bookmarked startup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Note Card referencing image_0357dd.png
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "John Smith",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                            height: 30, thickness: 1),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Colors.grey.shade300),
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                controller: _noteController,
                                maxLines: 10,
                                decoration:
                                    const InputDecoration(
                                        border: InputBorder
                                            .none),
                              ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                    Icons.drag_handle,
                                    size: 16,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildMiniAction(context,
                                Icons.copy_outlined, "Copy"),
                            const SizedBox(width: 10),
                            _buildMiniAction(
                                context, null, "Edit"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom Navigation
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => _showSavedDialog(context), // Triggers image_0350fb.png popup
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF0022BA),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12)),
                          ),
                          child: const Text("Save",
                              style:
                                  TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12)),
                          ),
                          child: const Text("Back",
                              style:
                                  TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAction(BuildContext context, IconData? icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
          ],
          Text(label,
              style:
                  TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}