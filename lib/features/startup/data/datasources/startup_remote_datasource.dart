import 'dart:convert';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../domain/entities/startup.dart';

class StartupRemoteDatasource {
  
  // Get all startups (public)
  Future<List<Startup>> getAllStartups() async {
    final response = await DioClient.get(ApiConstants.startups);
    final startups = response.data['data']['startups'] as List;
    return startups.map((json) => Startup.fromJson(json)).toList();
  }
  
  // Get startup by ID
  Future<Startup> getStartupById(int id) async {
    final response = await DioClient.get(ApiConstants.startupById(id));
    return Startup.fromJson(response.data['data']['startup']);
  }
  
  // Create a new startup
  Future<Startup> createStartup(Map<String, dynamic> startupData) async {
    final response = await DioClient.post(
      ApiConstants.startups,
      data: startupData,
    );
    return Startup.fromJson(response.data['data']['startup']);
  }
  
  // Update an existing startup
  Future<Startup> updateStartup(int id, Map<String, dynamic> data) async {
    final response = await DioClient.put(
      ApiConstants.startupById(id),
      data: data,
    );
    return Startup.fromJson(response.data['data']['startup']);
  }
  
  // Delete a startup
  Future<void> deleteStartup(int id) async {
    await DioClient.delete(ApiConstants.startupById(id));
  }
  
  // Get dashboard stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await DioClient.get('/startups/dashboard-stats');
    return response.data['data'];
  }
  
  // Get interests for a specific startup
  Future<List<Map<String, dynamic>>> getStartupInterests(int startupId) async {
    final response = await DioClient.get(ApiConstants.startupInterests(startupId));
    final interests = response.data['data']['interests'] as List;
    return interests.map((interest) => {
      'id': interest['id'],
      'investor_id': interest['investor_id'],
      'investor_name': interest['investor_name'],
      'investor_email': interest['investor_email'],
      'investor_phone': interest['investor_phone'],
      'message': interest['message'],
      'status': interest['status'],
      'created_at': interest['created_at'],
    }).toList();
  }
}