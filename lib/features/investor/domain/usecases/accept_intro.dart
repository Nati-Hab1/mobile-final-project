import '../repositories/investor_repository.dart';

class AcceptIntroUseCase {
  final InvestorRepository _repository;

  AcceptIntroUseCase(this._repository);

  Future<void> execute(int introId) async {
    await _repository.acceptIntro(introId);
  }
}
