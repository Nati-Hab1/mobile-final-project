import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/header.dart';

class MyInvestors extends StatelessWidget {
  MyInvestors({super.key, required this.role});
  final String role;

  final List<Map<String, String>> investors = [
    {
      "name": "John smith",
      "startup": "startup 1",
      "email": "johnsmith@gmail.com",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(role: role),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A6FA8), Color(0xFF3F5C8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Title
              const SizedBox(height: 9),

              const Text(
                "My Investors",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage your investor list",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search my investors...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Investor List
              Expanded(
                child: ListView.builder(
                  itemCount: investors.length,
                  itemBuilder: (context, index) {
                    final investor = investors[index];
                    return InvestorCard(
                      name: investor["name"]!,
                      startup: investor["startup"]!,
                      email: investor["email"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvestorCard extends StatelessWidget {
  final String name;
  final String startup;
  final String email;

  const InvestorCard({
    required this.name,
    required this.startup,
    required this.email,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline,
              size: 50, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: $name",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text("Invested in: $startup"),
              const SizedBox(height: 4),
              Text(email),
            ],
          ),
        ],
      ),
    );
  }
}
