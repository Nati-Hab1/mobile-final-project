import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../data/datasources/startup_remote_datasource.dart';
import '../../domain/usecases/get_startup_stats_usecase.dart';
import '../../data/datasources/repositories/startup_repository_impl.dart';

final startupRemoteDatasourceProvider =
    Provider<StartupRemoteDatasource>((ref) {
  return StartupRemoteDatasource();
});

final getStartupStatsUseCaseProvider =
    Provider<GetStartupStatsUseCase>((ref) {
  final datasource =
      ref.read(startupRemoteDatasourceProvider);
  return GetStartupStatsUseCase(
      StartupRepositoryImpl(datasource));
});

class StartupStatsNotifier extends StateNotifier<
    AsyncValue<Map<String, dynamic>>> {
  final GetStartupStatsUseCase _getStatsUseCase;

  StartupStatsNotifier(this._getStatsUseCase)
      : super(const AsyncValue.loading()) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _getStatsUseCase.execute();
      state = AsyncValue.data(stats);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

final startupStatsProvider = StateNotifierProvider<
    StartupStatsNotifier,
    AsyncValue<Map<String, dynamic>>>((ref) {
  final useCase = ref.read(getStartupStatsUseCaseProvider);
  return StartupStatsNotifier(useCase);
});
