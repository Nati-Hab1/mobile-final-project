import '../entities/bookmark.dart';
import '../repositories/investor_repository.dart';

class UpdateBookmarkNoteUseCase {
  final InvestorRepository _repository;

  UpdateBookmarkNoteUseCase(this._repository);

  Future<Bookmark> execute(int bookmarkId, String note) async {
    return await _repository.updateBookmarkNote(bookmarkId, note);
  }
}
