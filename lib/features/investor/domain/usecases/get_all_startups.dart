import '../entities/startup.dart';
import '../repositories/investor_repository.dart';

class GetAllStartupsUseCase {
  final InvestorRepository _repository;

  GetAllStartupsUseCase(this._repository);

  Future<List<InvestorStartup>> execute(
      {bool forceRefresh = false}) async {
    return await _repository.getAllStartups(
        forceRefresh: forceRefresh);
  }
}
