import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import '../../../core/widgets/contact_us/accordion.dart';
import '../../../core/widgets/contact_us/success_popup.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key, required this.role});
  final String role;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (role == 'investor' || role == 'startup')
          ? Header(role: role)
          : AppBar(
              title: const Text("Contact Us"),
            ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          image: const DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (role == 'investor' || role == 'startup')
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => {
                            if (role == 'startup')
                              {
                                context.goNamed(
                                  "startupDashboard",
                                  pathParameters: {
                                    'role': role
                                  },
                                )
                              }
                            else
                              {
                                context.goNamed(
                                  "investorDashboard",
                                  pathParameters: {
                                    'role': role
                                  },
                                )
                              }
                          },
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white),
                          label: const Text("Back",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      )
                    : const SizedBox(),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Have Questions?\nWe’d Love To Hear From You",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // Full name
                const Text(
                  "Full name*",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Email
                const Text(
                  "Email*",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Phone
                const Text(
                  "Phone number*",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Message*",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:
                        "Tell us about your needs and preferences...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (val) {},
                    ),
                    const Text(
                      "I agree to receive messages via email",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Builder(
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const SuccessPopup();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1A3CC8),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Send Message",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue[800],
                    //     padding:
                    //         const EdgeInsets.symmetric(
                    //       vertical: 14,
                    //     ),
                    //   ),
                    // onPressed: () {
                    //   showDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     builder: (context) {
                    //       return const SuccessPopup();
                    //     },
                    //   );
                    // },
                    //   child: const Text("Send Message"),
                    // ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: 330,
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 9,
                    top: 35,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get In Touch",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 10),
                          Text(
                            "22 Kenya Avenue, Addis Ababa, Ethiopia",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 10),
                          Text("+11111111111"),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 10),
                          Text("menesha@gmail.com"),
                        ],
                      ),
                      SizedBox(height: 45),
                      Row(
                        children: [
                          Icon(Icons.facebook),
                          SizedBox(width: 10),
                          Icon(Icons.camera),
                          SizedBox(width: 10),
                          Icon(Icons.work),
                          SizedBox(width: 10),
                          Icon(Icons.alternate_email),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // FAQ Title
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Accordion(
                  title: "What am I agreeing to?",
                  text:
                      "By creating an account, you agree to our Terms of Service and Privacy Policy, which explain how we protect your data, what you can expect from our service, and your rights as a user.",
                ),
                const Accordion(
                  title:
                      "Why do I need to accept the Terms?",
                  text:
                      "Accepting the Terms of Service is required to use the app. It ensures you understand the rules, your responsibilities, and how the service operates.",
                ),
                const Accordion(
                  title: "How is my personal data used?",
                  text:
                      "We use your personal data to provide and improve our services, personalize your experience, and ensure account security. Your data is handled according to our Privacy Policy.",
                ),
                const Accordion(
                  title: "Can I delete my account later?",
                  text:
                      "Yes, you can delete your account at any time through the account settings. Once deleted, your data will be removed according to our data retention policy.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
