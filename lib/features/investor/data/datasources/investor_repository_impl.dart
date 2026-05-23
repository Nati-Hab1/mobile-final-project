import 'dart:convert';
import '../../../../../core/database/local_database.dart';
import '../../../../../core/utils/logger.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/interest.dart';
import '../../domain/entities/intro.dart';
import '../../domain/entities/investor_stats.dart';
import '../../domain/entities/startup.dart';
import '../../domain/repositories/investor_repository.dart';
import '../datasources/investor_remote_datasource.dart';

class InvestorRepositoryImpl implements InvestorRepository {
  final InvestorRemoteDatasource _datasource;

  InvestorRepositoryImpl(this._datasource);
  // Helper methods for cache
  Future<void> _invalidateCache(String cacheKey) async {
    await LocalDatabase.delete(
      'cached_investor',
      where: 'id = ?',
      whereArgs: [cacheKey],
    );
    AppLogger.debug('Investor cache invalidated for: $cacheKey');
  }

  Future<T> _getCachedData<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
    Future<T> Function() fetchFromApi, {
    Duration cacheDuration = const Duration(minutes: 5),
    bool forceRefresh = false,
  }) async {
    try {
      // Skip cache if force refresh
      if (!forceRefresh) {
        final cachedData = await LocalDatabase.query(
          'cached_investor',
          where: 'id = ? AND expires_at > ?',
          whereArgs: [cacheKey, DateTime.now().toIso8601String()],
        );

        if (cachedData.isNotEmpty) {
          AppLogger.debug('Returning cached data for: $cacheKey');
          final data = json.decode(cachedData.first['data']);
          return fromJson(data);
        }
      } else {
        AppLogger.debug('Force refresh - skipping cache for: $cacheKey');
        await _invalidateCache(cacheKey);
      }

      AppLogger.debug('Cache miss - fetching from API: $cacheKey');
      final freshData = await fetchFromApi();

      await LocalDatabase.insert('cached_investor', {
        'id': cacheKey,
        'data': json.encode(freshData),
        'cached_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now().add(cacheDuration).toIso8601String(),
      });

      return freshData;
    } catch (e) {
      AppLogger.error('Error in cache for $cacheKey', e);

      final expiredCache = await LocalDatabase.query(
        'cached_investor',
        where: 'id = ?',
        whereArgs: [cacheKey],
      );

      if (expiredCache.isNotEmpty) {
        AppLogger.warning('Using expired cache for: $cacheKey');
        final data = json.decode(expiredCache.first['data']);
        return fromJson(data);
      }

      rethrow;
    }
  }

  Future<List<T>> _getCachedListData<T>(
    String cacheKey,
    T Function(Map<String, dynamic>) fromJson,
    Future<List<T>> Function() fetchFromApi, {
    Duration cacheDuration = const Duration(minutes: 5),
    bool forceRefresh = false,
  }) async {
    try {
      // Skip cache if force refresh
      if (!forceRefresh) {
        final cachedData = await LocalDatabase.query(
          'cached_investor',
          where: 'id = ? AND expires_at > ?',
          whereArgs: [cacheKey, DateTime.now().toIso8601String()],
        );

        if (cachedData.isNotEmpty) {
          AppLogger.debug('Returning cached list for: $cacheKey');
          final list = json.decode(cachedData.first['data']) as List;
          return list.map((item) => fromJson(item)).toList();
        }
      } else {
        AppLogger.debug('Force refresh - skipping cache for: $cacheKey');
        await _invalidateCache(cacheKey);
      }

      AppLogger.debug('Cache miss - fetching list from API: $cacheKey');
      final freshData = await fetchFromApi();

      // Convert each item to JSON
      final jsonList = freshData.map((item) {
        if (item is Map) {
          return item;
        }
        try {
          return (item as dynamic).toJson();
        } catch (e) {
          return item;
        }
      }).toList();

      await LocalDatabase.insert('cached_investor', {
        'id': cacheKey,
        'data': json.encode(jsonList),
        'cached_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now().add(cacheDuration).toIso8601String(),
      });

      return freshData;
    } catch (e) {
      AppLogger.error('Error in cache for $cacheKey', e);

      final expiredCache = await LocalDatabase.query(
        'cached_investor',
        where: 'id = ?',
        whereArgs: [cacheKey],
      );

      if (expiredCache.isNotEmpty) {
        AppLogger.warning('Using expired cache for: $cacheKey');
        final list = json.decode(expiredCache.first['data']) as List;
        return list.map((item) => fromJson(item)).toList();
      }

      rethrow;
    }
  }

  @override
  Future<InvestorStats> getDashboardStats({bool forceRefresh = false}) async {
    return await _getCachedData(
      'dashboard_stats',
      (json) => InvestorStats.fromJson(json),
      () => _datasource.getDashboardStats(),
      cacheDuration: const Duration(minutes: 2),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<List<InvestorStartup>> getAllStartups(
      {bool forceRefresh = false}) async {
    return await _getCachedListData(
      'all_startups',
      (json) => InvestorStartup.fromJson(json),
      () => _datasource.getAllStartups(),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<List<Bookmark>> getBookmarks({bool forceRefresh = false}) async {
    return await _getCachedListData(
      'bookmarks',
      (json) => Bookmark.fromJson(json),
      () => _datasource.getBookmarks(),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<List<InvestorInterest>> getInterests(
      {bool forceRefresh = false}) async {
    return await _getCachedListData(
      'interests',
      (json) => InvestorInterest.fromJson(json),
      () => _datasource.getInterests(),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<List<InvestorIntro>> getIntros({bool forceRefresh = false}) async {
    return await _getCachedListData(
      'intros',
      (json) => InvestorIntro.fromJson(json),
      () => _datasource.getIntros(),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<Bookmark> addBookmark(int startupId, {String? note}) async {
    final bookmark = await _datasource.addBookmark(startupId, note: note);
    await _invalidateCache('bookmarks');
    await _invalidateCache('dashboard_stats');
    return bookmark;
  }

  @override
  Future<void> deleteBookmark(int bookmarkId) async {
    await _datasource.deleteBookmark(bookmarkId);
    await _invalidateCache('bookmarks');
    await _invalidateCache('dashboard_stats');
  }

  @override
  Future<Bookmark> updateBookmarkNote(int bookmarkId, String note) async {
    final bookmark = await _datasource.updateBookmarkNote(bookmarkId, note);
    await _invalidateCache('bookmarks');
    return bookmark;
  }

  @override
  Future<InvestorInterest> expressInterest(int startupId,
      {String? message}) async {
    final interest =
        await _datasource.expressInterest(startupId, message: message);
    await _invalidateCache('interests');
    await _invalidateCache('dashboard_stats');
    return interest;
  }

  @override
  Future<void> acceptIntro(int introId) async {
    await _datasource.acceptIntro(introId);
    await _invalidateCache('intros');
    await _invalidateCache('dashboard_stats');
  }

  @override
  Future<void> declineIntro(int introId) async {
    await _datasource.declineIntro(introId);
    await _invalidateCache('intros');
    await _invalidateCache('dashboard_stats');
  }
}
