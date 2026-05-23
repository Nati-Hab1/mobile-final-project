import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/services/emailjs_service.dart';
import 'package:menesha/features/auth/presentation/providers/auth_provider.dart';
import '../../../core/widgets/contact_us/accordion.dart';
import '../../../core/widgets/contact_us/success_popup.dart';

class ContactUs extends ConsumerStatefulWidget {
  final String role;

  const ContactUs({super.key, required this.role});

  @override
  ConsumerState<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends ConsumerState<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to receive messages'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Send email via EmailJS
      await EmailJSService.sendContactEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        message: _messageController.text.trim(),
        role: widget.role,
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SuccessPopup(
              message: "Your message has been\nsent successfully!",
              buttonText: "Back to Dashboard",
              onClose: () {
                if (widget.role == 'startup') {
                  context.goNamed('startupDashboard');
                } else if (widget.role == 'investor') {
                  context.goNamed('investorDashboard');
                } else {
                  context.goNamed('home');
                }
              },
            );
          },
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        setState(() {
          _agreeToTerms = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _navigateBack() {
    if (widget.role == 'startup') {
      context.goNamed('startupDashboard');
    } else if (widget.role == 'investor') {
      context.goNamed('investorDashboard');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showHeader = widget.role == 'investor' || widget.role == 'startup';

    return Scaffold(
      appBar: showHeader
          ? Header(role: widget.role)
          : AppBar(
              title: const Text("Contact Us"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _navigateBack,
                        icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                        label: const Text("Back", style: TextStyle(color: Colors.white)),
                      ),
                    ),
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
                    "Have Questions?\nWe'd Love To Hear From You",
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter your full name",
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Email
                  const Text(
                    "Email*",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "your@email.com",
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Phone
                  const Text(
                    "Phone number*",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "+251XXXXXXXXX",
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Message
                  const Text(
                    "Message*",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Tell us about your needs and preferences...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      if (value.length < 10) {
                        return 'Message must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                          });
                        },
                        activeColor: const Color(0xFF1A3CC8),
                      ),
                      const Text(
                        "I agree to receive messages via email",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3CC8),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              "Send Message",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Contact Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get In Touch",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 10),
                            Text("22 Kenya Avenue, Addis Ababa, Ethiopia"),
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
                            Icon(Icons.camera_alt),
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
                  const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Accordion(
                    title: "What am I agreeing to?",
                    text: "By creating an account, you agree to our Terms of Service and Privacy Policy, which explain how we protect your data, what you can expect from our service, and your rights as a user.",
                  ),
                  const Accordion(
                    title: "Why do I need to accept the Terms?",
                    text: "Accepting the Terms of Service is required to use the app. It ensures you understand the rules, your responsibilities, and how the service operates.",
                  ),
                  const Accordion(
                    title: "How is my personal data used?",
                    text: "We use your personal data to provide and improve our services, personalize your experience, and ensure account security. Your data is handled according to our Privacy Policy.",
                  ),
                  const Accordion(
                    title: "Can I delete my account later?",
                    text: "Yes, you can delete your account at any time through the account settings. Once deleted, your data will be removed according to our data retention policy.",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}