import '../entities/intro.dart';
import '../repositories/investor_repository.dart';

class GetIntrosUseCase {
  final InvestorRepository _repository;

  GetIntrosUseCase(this._repository);

  Future<List<InvestorIntro>> execute({bool forceRefresh = false}) async {
    return await _repository.getIntros(forceRefresh: forceRefresh);
  }
}
