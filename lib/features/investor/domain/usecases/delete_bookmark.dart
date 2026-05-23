import '../repositories/investor_repository.dart';

class DeleteBookmarkUseCase {
  final InvestorRepository _repository;

  DeleteBookmarkUseCase(this._repository);

  Future<void> execute(int bookmarkId) async {
    await _repository.deleteBookmark(bookmarkId);
  }
}
