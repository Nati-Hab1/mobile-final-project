import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailJSService {
  static const String serviceId = 'service_5sa136n';
  static const String templateId = 'template_0wfyn5b';
  static const String publicKey = '12FpPeVcSfqt42r8S'; // This is your public key
  
  static Future<bool> sendContactEmail({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String role,
  }) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'name': name,
            'email': email,
            'phone': phone,
            'message': message,
            'role': role,
            'sent_at': DateTime.now().toIso8601String(),
          },
        }),
      );
      
      if (response.statusCode == 200) {
        print('Email sent successfully');
        return true;
      } else {
        print('Failed to send email: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}