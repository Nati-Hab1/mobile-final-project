import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';

class InvestorBookmarks extends StatelessWidget {
  const InvestorBookmarks({super.key, required this.role});
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
                          onPressed: () => context.goNamed(
                            "investorDashboard",
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
                        "Bookmarks",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Manage your bookmarked startups",
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

class StartupCard extends StatelessWidget {
  final String name;
  final String format;

  const StartupCard(
      {super.key,
      required this.name,
      required this.format});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC4CEDD).withOpacity(
            0.9), // Matching the light grey/blue in image
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name:  $name",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            "Preferred Format:   $format",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.star,
                  color: Colors.yellow, size: 28),
              Row(
                children: [
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () {
                      context.pushNamed(
                        "investorNotes",
                        pathParameters: {
                          'role': 'investor'
                        },
                      );
                    },
                    icon: const Icon(Icons.edit,
                        color: Colors.black),
                    label: const Text("Add Note",
                        style:
                            TextStyle(color: Colors.black)),
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
