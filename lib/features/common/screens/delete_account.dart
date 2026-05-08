import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() =>
      _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String? _selectedReason = "I Have A Privacy Concern";

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
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
                    borderRadius:
                        BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Are You Sure You Want To\nDelete Your Account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Icon(
                          Icons.person_remove_outlined,
                          size: 60,
                          color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        "By Deleting Your Account You Will Lose Your Data Permanently.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              style:
                                  OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.black),
                                shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10)),
                                padding: const EdgeInsets
                                    .symmetric(
                                    vertical: 12),
                              ),
                              child: const Text("Back",
                                  style: TextStyle(
                                      color: Colors.black)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .pop(); // Close first dialog
                                _showSuccessDialog(); // Show success
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0022BA),
                                shape:
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10)),
                                padding: const EdgeInsets
                                    .symmetric(
                                    vertical: 12),
                              ),
                              child: const Text("Delete",
                                  style: TextStyle(
                                      color: Colors.white)),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
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
                    borderRadius:
                        BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Successfully!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.check_circle,
                          size: 60, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        "Your Account Has Been Successfully Deleted, We're Sorry To See You Go",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              {context.goNamed("guest")},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF0022BA),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10)),
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15),
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Background
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 18),
                      label: const Text("Back",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18)),
                    ),
                  ),
                ),

                // Warmly Logo Placeholder
                const Text("WARMLY",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                const SizedBox(height: 30),

                const Text(
                  "Delete Account",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.person_outline,
                    size: 80, color: Colors.white),
                const SizedBox(height: 30),

                // Reason Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Tell Us The Reason For Closing Your Account ?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedReason,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12)),
                        ),
                        items: [
                          "I Have A Privacy Concern",
                          "Other"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.grey)),
                          );
                        }).toList(),
                        onChanged: (val) => setState(
                            () => _selectedReason = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  "Things To Check When Deleting Your Account:",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 15),

                // Info Box
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildCheckItem(
                            "You Can't Log In To Application With This Account After Deleting It."),
                        _buildCheckItem(
                            "You Can't Register A New Account Using The Email Address Linked To This Account."),
                        _buildCheckItem(
                            "Your Requests And Other Related Data Will Be Deleted Permanently"),
                        _buildCheckItem(
                            "Your Account Will Be Permanently Deleted In 14 Days."),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                // Final Delete Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF3F51B5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                      ),
                      child: const Text("Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(". ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14))),
        ],
      ),
    );
  }
}
