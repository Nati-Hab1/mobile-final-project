import '../entities/interest.dart';
import '../repositories/investor_repository.dart';

class GetInterestsUseCase {
  final InvestorRepository _repository;

  GetInterestsUseCase(this._repository);

  Future<List<InvestorInterest>> execute(
      {bool forceRefresh = false}) async {
    return await _repository.getInterests(
        forceRefresh: forceRefresh);
  }
}
