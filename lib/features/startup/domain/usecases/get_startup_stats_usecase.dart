import '../../../startup/data/datasources/repositories/startup_repository.dart';

class GetStartupStatsUseCase {
  final StartupRepository _repository;

  GetStartupStatsUseCase(this._repository);

  Future<Map<String, dynamic>> execute({bool forceRefresh = false}) async {
    return await _repository.getDashboardStats(forceRefresh: forceRefresh);
  }
}
