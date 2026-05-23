import '../repositories/auth_repository.dart';

class GetRoleTokenUseCase {
  final AuthRepository _repository;

  GetRoleTokenUseCase(this._repository);

  Future<String> execute(String role) async {
    return await _repository.getRoleToken(role);
  }
}
