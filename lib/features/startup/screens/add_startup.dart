import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/startup_appbar.dart';

class AddStartup extends StatelessWidget {
  const AddStartup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StartupAppbar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A6FA8), Color(0xFF3F5C8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Add Startup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _input("Startup Name"),
                const SizedBox(height: 10),
                _input("Blurb"),
                const SizedBox(height: 10),
                _input("Pitch Link (optional)"),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text("Add Startup"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String hint) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}