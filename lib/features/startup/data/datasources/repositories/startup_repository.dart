import '../../../domain/entities/startup.dart';

abstract class StartupRepository {
  Future<List<Startup>> getAllStartups({bool forceRefresh = false});
  Future<Startup> getStartupById(int id);
  Future<Startup> createStartup(Map<String, dynamic> startupData);
  Future<Startup> updateStartup(int id, Map<String, dynamic> data);
  Future<void> deleteStartup(int id);
  Future<Map<String, dynamic>> getDashboardStats({bool forceRefresh = false});
}
