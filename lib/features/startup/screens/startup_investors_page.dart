import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/startup_appbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyInvestorsPage(),
    );
  }
}

class MyInvestorsPage extends StatelessWidget {
  MyInvestorsPage({super.key});

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
      appBar: StartupAppbar(),
      body: Container(
        decoration: BoxDecoration(
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
              SizedBox(height: 9),

              Text(
                "My Investors",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Manage your investor list",
                style: TextStyle(color: Colors.white70),
              ),

              SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search my investors...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: 50, color: Colors.grey),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: $name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text("Invested in: $startup"),
              SizedBox(height: 4),
              Text(email),
            ],
          ),
        ],
      ),
    );
  }
}
