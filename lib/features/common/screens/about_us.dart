import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.1),
          child: SingleChildScrollView(
            child: Center(
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    const Text(
                      "About Us",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: const Text(
                        "We are a platform built to make meaningful connections simple, secure, and effortless. Our focus is on creating a smooth experience that helps people interact, collaborate, and get things done without unnecessary complexity. Every feature we design aims to save time, reduce friction, and empower users with tools that feel reliable and intuitive.",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Our Purpose",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: const Text(
                        "Our purpose is to bridge gaps—between people, ideas, and opportunities. We exist to make communication easier by providing a trusted space where users can connect confidently and achieve what matters to them. Everything we do centers on improving clarity, convenience, and accessibility in everyday interactions.",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "What We Stand For",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/lock.png",
                              width: 40,
                              height: 40,
                            ),
                            // Icon(Icons.lock, color: Colors.blue),
                            const Text(
                              "Privacy",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "Your data is always handled with respect and responsibility.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/handshake.png",
                            ),
                            const Text(
                              "Reliablility",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "A platform you can depend on, anytime.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/simplicity.png",
                              width: 40,
                              height: 40,
                            ),
                            // Icon(Icons.lock, color: Colors.blue),
                            const Text(
                              "implicity",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "Clean, intuitive experiences without the clutter.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/integrity.png",
                            ),
                            const Text(
                              "Integrity",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "Clear policies, honest communication, and ethical practices.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    const Text("data"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
