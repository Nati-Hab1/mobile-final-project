import '../repositories/auth_repository.dart';

class AddRoleUseCase {
  final AuthRepository _repository;
  
  AddRoleUseCase(this._repository);
  
  Future<void> execute(String role) async {
    await _repository.addRole(role);
  }
}