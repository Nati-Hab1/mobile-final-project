import '../entities/bookmark.dart';
import '../repositories/investor_repository.dart';

class GetBookmarksUseCase {
  final InvestorRepository _repository;

  GetBookmarksUseCase(this._repository);

  Future<List<Bookmark>> execute(
      {bool forceRefresh = false}) async {
    return await _repository.getBookmarks(
        forceRefresh: forceRefresh);
  }
}
