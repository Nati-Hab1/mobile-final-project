import '../entities/bookmark.dart';
import '../entities/intro.dart';
import '../entities/investor_stats.dart';
import '../entities/startup.dart';
import '../entities/interest.dart';

abstract class InvestorRepository {
  Future<InvestorStats> getDashboardStats(
      {bool forceRefresh = false});

  Future<List<InvestorStartup>> getAllStartups(
      {bool forceRefresh = false});

  Future<List<Bookmark>> getBookmarks(
      {bool forceRefresh = false});
  Future<Bookmark> addBookmark(int startupId,
      {String? note});
  Future<void> deleteBookmark(int bookmarkId);
  Future<Bookmark> updateBookmarkNote(
      int bookmarkId, String note);

  Future<List<InvestorInterest>> getInterests(
      {bool forceRefresh = false});
  Future<InvestorInterest> expressInterest(int startupId,
      {String? message});

  Future<List<InvestorIntro>> getIntros(
      {bool forceRefresh = false});
  Future<void> acceptIntro(int introId);
  Future<void> declineIntro(int introId);
}
