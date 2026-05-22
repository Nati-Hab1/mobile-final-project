import '../entities/bookmark.dart';
import '../repositories/investor_repository.dart';

class AddBookmarkUseCase {
  final InvestorRepository _repository;

  AddBookmarkUseCase(this._repository);

  Future<Bookmark> execute(int startupId,
      {String? note}) async {
    return await _repository.addBookmark(startupId,
        note: note);
  }
}
