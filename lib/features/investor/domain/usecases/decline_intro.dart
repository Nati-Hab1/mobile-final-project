import '../repositories/investor_repository.dart';

class DeclineIntroUseCase {
  final InvestorRepository _repository;

  DeclineIntroUseCase(this._repository);

  Future<void> execute(int introId) async {
    await _repository.declineIntro(introId);
  }
}
