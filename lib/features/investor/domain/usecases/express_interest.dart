import '../entities/interest.dart';
import '../repositories/investor_repository.dart';

class ExpressInterestUseCase {
  final InvestorRepository _repository;

  ExpressInterestUseCase(this._repository);

  Future<InvestorInterest> execute(int startupId, {String? message}) async {
    return await _repository.expressInterest(startupId, message: message);
  }
}
