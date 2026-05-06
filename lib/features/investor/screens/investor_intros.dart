import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/investor_header.dart';

class InvestorIntrosPage extends StatefulWidget {
  const InvestorIntrosPage({super.key});

  @override
  State<InvestorIntrosPage> createState() =>
      _InvestorIntrosPageState();
}

class _InvestorIntrosPageState
    extends State<InvestorIntrosPage> {
  void _showAcceptedDialog() {
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
                        "Accepted",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () => context
                              .goNamed("investorStartups"),
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
          // Background
          Positioned.fill(
            child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                const InvestorHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context
                              .goNamed("investorStartups"),
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white),
                          label: const Text("Back",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Intros",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "A simple, three-step process to generate a\ncustomized intro.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Intro Card Container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            // Greyish Inner Content Area
                            Container(
                              padding:
                                  const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE9F0F4),
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    "Startup Name: Startup 1",
                                    style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const Text(
                                      "Founder: John smith"),
                                  const Text(
                                      "Email: johnsmith@gmail.com"),
                                  const SizedBox(
                                      height: 16),

                                  // White Message Bubble
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(16),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(12),
                                    ),
                                    child: const Text(
                                      "Hi Kebede,\n\nI wanted to introduce you to a fintech platform that's solving payment reconciliation for B2B companies. They've already seen 3x revenue growth in 6 months.\n\nCheck out their pitch: [ https://abc.com]\n\nBest,\nFounder",
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.4),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 20),

                                  // Accept Button inside the grey area
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          _showAcceptedDialog,
                                      style: ElevatedButton
                                          .styleFrom(
                                        backgroundColor:
                                            const Color(
                                                0xFF0022BA),
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                                vertical:
                                                    14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        10)),
                                      ),
                                      child: const Text(
                                        "Accept",
                                        style: TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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
}
