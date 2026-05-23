import 'dart:convert';
import '../../../../../core/database/local_database.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/entities/startup.dart';
import '../../../data/datasources/repositories/startup_repository.dart';
import '../startup_remote_datasource.dart';

class StartupRepositoryImpl implements StartupRepository {
  final StartupRemoteDatasource _datasource;

  StartupRepositoryImpl(this._datasource);

  // Helper method to invalidate cache
  Future<void> _invalidateCache(String cacheKey) async {
    await LocalDatabase.delete(
      'cached_startups',
      where: 'id = ?',
      whereArgs: [cacheKey],
    );
    AppLogger.debug('Cache invalidated for: $cacheKey');
  }

  @override
  Future<List<Startup>> getAllStartups({bool forceRefresh = false}) async {
    const cacheKey = 'all_startups';

    // Skip cache if force refresh
    if (forceRefresh) {
      AppLogger.debug('Force refresh - skipping cache for: $cacheKey');
      await _invalidateCache(cacheKey);
    }

    try {
      // 1. Try to get from cache first (skip if force refresh)
      if (!forceRefresh) {
        final cachedData = await LocalDatabase.query(
          'cached_startups',
          where: 'id = ? AND expires_at > ?',
          whereArgs: [cacheKey, DateTime.now().toIso8601String()],
        );

        if (cachedData.isNotEmpty) {
          AppLogger.debug('Returning cached startups');
          final startupsJson = json.decode(cachedData.first['data']) as List;
          return startupsJson.map((json) => Startup.fromJson(json)).toList();
        }
      }

      // 2. Cache miss or force refresh - fetch from API
      AppLogger.debug('Cache miss - fetching startups from API');
      final startups = await _datasource.getAllStartups();

      // 3. Save to cache
      await LocalDatabase.insert('cached_startups', {
        'id': cacheKey,
        'data': json.encode(startups.map((s) => s.toJson()).toList()),
        'cached_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
      });

      return startups;
    } catch (e) {
      AppLogger.error('Error in getAllStartups with cache', e);

      // Fallback to cache even if expired
      final expiredCache = await LocalDatabase.query(
        'cached_startups',
        where: 'id = ?',
        whereArgs: [cacheKey],
      );

      if (expiredCache.isNotEmpty) {
        AppLogger.warning('Using expired cache due to API error');
        final startupsJson = json.decode(expiredCache.first['data']) as List;
        return startupsJson.map((json) => Startup.fromJson(json)).toList();
      }

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats(
      {bool forceRefresh = false}) async {
    const cacheKey = 'dashboard_stats';

    // Skip cache if force refresh
    if (forceRefresh) {
      AppLogger.debug('Force refresh - skipping cache for: $cacheKey');
      await _invalidateCache(cacheKey);
    }

    try {
      // 1. Try cache (skip if force refresh)
      if (!forceRefresh) {
        final cachedData = await LocalDatabase.query(
          'cached_startups',
          where: 'id = ? AND expires_at > ?',
          whereArgs: [cacheKey, DateTime.now().toIso8601String()],
        );

        if (cachedData.isNotEmpty) {
          AppLogger.debug('Returning cached dashboard stats');
          return json.decode(cachedData.first['data']);
        }
      }

      // 2. Fetch from API
      AppLogger.debug('Fetching dashboard stats from API');
      final stats = await _datasource.getDashboardStats();

      // 3. Save to cache
      await LocalDatabase.insert('cached_startups', {
        'id': cacheKey,
        'data': json.encode(stats),
        'cached_at': DateTime.now().toIso8601String(),
        'expires_at':
            DateTime.now().add(Duration(minutes: 2)).toIso8601String(),
      });

      return stats;
    } catch (e) {
      AppLogger.error('Error fetching dashboard stats', e);

      // Fallback to expired cache
      final expiredCache = await LocalDatabase.query(
        'cached_startups',
        where: 'id = ?',
        whereArgs: [cacheKey],
      );

      if (expiredCache.isNotEmpty) {
        AppLogger.warning('Using expired cache due to API error');
        return json.decode(expiredCache.first['data']);
      }

      rethrow;
    }
  }

  @override
  Future<Startup> createStartup(Map<String, dynamic> startupData) async {
    final startup = await _datasource.createStartup(startupData);

    // Invalidate related caches
    await _invalidateCache('all_startups');
    await _invalidateCache('dashboard_stats');

    return startup;
  }

  @override
  Future<Startup> updateStartup(int id, Map<String, dynamic> data) async {
    final startup = await _datasource.updateStartup(id, data);

    // Invalidate caches
    await _invalidateCache('all_startups');
    await _invalidateCache('dashboard_stats');

    return startup;
  }

  @override
  Future<void> deleteStartup(int id) async {
    await _datasource.deleteStartup(id);

    // Invalidate caches
    await _invalidateCache('all_startups');
    await _invalidateCache('dashboard_stats');
  }

  @override
  Future<Startup> getStartupById(int id) async {
    // Implement if needed
    throw UnimplementedError();
  }
}
