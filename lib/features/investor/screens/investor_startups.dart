import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'dart:ui';

class InvestorStartups extends StatelessWidget {
  const InvestorStartups({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                Header(
                  role: role,
                ),

                // Back Button & Title Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => {
                            context.goNamed(
                              "investorDashboard",
                              pathParameters: {
                                'role': 'investor'
                              },
                            )
                          },
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
                        "Startups",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Manage your startup list",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search startups....",
                          prefixIcon:
                              const Icon(Icons.search),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Startup List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    itemCount: 3, // Mock count
                    itemBuilder: (context, index) {
                      return const StartupCard(
                          name: "John Smith",
                          format: "3-Bullet");
                    },
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

class StartupCard extends StatefulWidget {
  final String name;
  final String format;

  const StartupCard(
      {super.key,
      required this.name,
      required this.format});

  @override
  State<StartupCard> createState() => _StartupCardState();
}

class _StartupCardState extends State<StartupCard> {
  bool _isStarred = false;

  // Added the custom blur dialog method here
  void _showDeletedDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(255, 232, 230, 230)
          .withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            // 🔹 Blur Background
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.transparent),
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
                        Icons.error_outline,
                        color: Color.fromARGB(
                            255, 201, 32, 32),
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Confirm delete: Are you sure?", // Changed to Deleted to match the action
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          // 🔹 Yes Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.pop();
                                // add your YES logic here
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF3F48CC),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          10),
                                ),
                              ),
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 🔹 No Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.pop();
                              },
                              style:
                                  OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color:
                                        Color(0xFF3F48CC)),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          10),
                                ),
                              ),
                              child: const Text(
                                "No",
                                style: TextStyle(
                                    color:
                                        Color(0xFF3F48CC)),
                              ),
                            ),
                          ),
                        ],
                      )
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC4CEDD).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name:  ${widget.name}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            "Preferred Format:   ${widget.format}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isStarred = !_isStarred;
                  });
                },
                child: Icon(
                  _isStarred
                      ? Icons.star
                      : Icons.star_border,
                  color: _isStarred
                      ? Colors.yellow
                      : Colors.grey[600],
                  size: 32,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      context.goNamed(
                        "investorIntros",
                        pathParameters: {
                          'role': 'investor'
                        },
                      );
                    },
                    icon: const Icon(Icons.visibility,
                        color: Colors.black),
                    label: const Text("View Intro",
                        style:
                            TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed:
                        _showDeletedDialog, // 🔹 Call the dialog here
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    label: const Text("Delete",
                        style:
                            TextStyle(color: Colors.red)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
