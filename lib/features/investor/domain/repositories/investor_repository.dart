import '../entities/bookmark.dart';
import '../entities/intro.dart';
import '../entities/investor_stats.dart';
import '../entities/startup.dart';
import '../entities/interest.dart';

abstract class InvestorRepository {
  Future<InvestorStats> getDashboardStats();
  Future<List<InvestorStartup>> getAllStartups();

  Future<List<Bookmark>> getBookmarks();
  Future<Bookmark> addBookmark(int startupId,
      {String? note});
  Future<void> deleteBookmark(int bookmarkId);
  Future<Bookmark> updateBookmarkNote(
      int bookmarkId, String note);

  Future<List<InvestorInterest>> getInterests();
  Future<InvestorInterest> expressInterest(int startupId,
      {String? message});

  Future<List<InvestorIntro>> getIntros();
  Future<void> acceptIntro(int introId);
  Future<void> declineIntro(int introId);
}
