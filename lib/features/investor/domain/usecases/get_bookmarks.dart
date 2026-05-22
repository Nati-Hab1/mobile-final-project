import '../entities/bookmark.dart';
import '../repositories/investor_repository.dart';

class GetBookmarksUseCase {
  final InvestorRepository _repository;

  GetBookmarksUseCase(this._repository);

  Future<List<Bookmark>> execute() async {
    return await _repository.getBookmarks();
  }
}
