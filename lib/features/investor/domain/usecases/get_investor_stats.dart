import '../entities/investor_stats.dart';
import '../repositories/investor_repository.dart';

class GetInvestorStatsUseCase {
  final InvestorRepository _repository;

  GetInvestorStatsUseCase(this._repository);

  Future<InvestorStats> execute(
      {bool forceRefresh = false}) async {
    return await _repository.getDashboardStats(
        forceRefresh: forceRefresh);
  }
}
