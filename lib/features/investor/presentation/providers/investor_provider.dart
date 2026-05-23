import 'package:riverpod/riverpod.dart';
import '../../data/datasources/investor_remote_datasource.dart';
import '../../data/datasources/investor_repository_impl.dart';
import '../../domain/repositories/investor_repository.dart';
import '../../domain/usecases/accept_intro.dart';
import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/decline_intro.dart';
import '../../domain/usecases/delete_bookmark.dart';
import '../../domain/usecases/express_interest.dart';
import '../../domain/usecases/get_all_startups.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/get_interests.dart';
import '../../domain/usecases/get_intros.dart';
import '../../domain/usecases/get_investor_stats.dart';
import '../../domain/usecases/update_bookmark_note.dart';
import 'investor_state.dart';

// Datasource provider
final investorRemoteDatasourceProvider =
    Provider<InvestorRemoteDatasource>((ref) {
  return InvestorRemoteDatasource();
});

// Repository provider
final investorRepositoryProvider = Provider<InvestorRepository>((ref) {
  final datasource = ref.read(investorRemoteDatasourceProvider);
  return InvestorRepositoryImpl(datasource);
});

// Use Cases
final getInvestorStatsUseCaseProvider =
    Provider<GetInvestorStatsUseCase>((ref) {
  return GetInvestorStatsUseCase(ref.read(investorRepositoryProvider));
});

final getAllStartupsUseCaseProvider = Provider<GetAllStartupsUseCase>((ref) {
  return GetAllStartupsUseCase(ref.read(investorRepositoryProvider));
});

final getBookmarksUseCaseProvider = Provider<GetBookmarksUseCase>((ref) {
  return GetBookmarksUseCase(ref.read(investorRepositoryProvider));
});

final addBookmarkUseCaseProvider = Provider<AddBookmarkUseCase>((ref) {
  return AddBookmarkUseCase(ref.read(investorRepositoryProvider));
});

final deleteBookmarkUseCaseProvider = Provider<DeleteBookmarkUseCase>((ref) {
  return DeleteBookmarkUseCase(ref.read(investorRepositoryProvider));
});

final updateBookmarkNoteUseCaseProvider =
    Provider<UpdateBookmarkNoteUseCase>((ref) {
  return UpdateBookmarkNoteUseCase(ref.read(investorRepositoryProvider));
});

final expressInterestUseCaseProvider = Provider<ExpressInterestUseCase>((ref) {
  return ExpressInterestUseCase(ref.read(investorRepositoryProvider));
});

final getInterestsUseCaseProvider = Provider<GetInterestsUseCase>((ref) {
  return GetInterestsUseCase(ref.read(investorRepositoryProvider));
});

final getIntrosUseCaseProvider = Provider<GetIntrosUseCase>((ref) {
  return GetIntrosUseCase(ref.read(investorRepositoryProvider));
});

final acceptIntroUseCaseProvider = Provider<AcceptIntroUseCase>((ref) {
  return AcceptIntroUseCase(ref.read(investorRepositoryProvider));
});

final declineIntroUseCaseProvider = Provider<DeclineIntroUseCase>((ref) {
  return DeclineIntroUseCase(ref.read(investorRepositoryProvider));
});

// StateNotifier
class InvestorNotifier extends StateNotifier<InvestorDashboardState> {
  final GetInvestorStatsUseCase _getStatsUseCase;
  final GetAllStartupsUseCase _getAllStartupsUseCase;
  final GetBookmarksUseCase _getBookmarksUseCase;
  final GetInterestsUseCase _getInterestsUseCase;
  final GetIntrosUseCase _getIntrosUseCase;

  InvestorNotifier({
    required GetInvestorStatsUseCase getStatsUseCase,
    required GetAllStartupsUseCase getAllStartupsUseCase,
    required GetBookmarksUseCase getBookmarksUseCase,
    required GetInterestsUseCase getInterestsUseCase,
    required GetIntrosUseCase getIntrosUseCase,
  })  : _getStatsUseCase = getStatsUseCase,
        _getAllStartupsUseCase = getAllStartupsUseCase,
        _getBookmarksUseCase = getBookmarksUseCase,
        _getInterestsUseCase = getInterestsUseCase,
        _getIntrosUseCase = getIntrosUseCase,
        super(InvestorDashboardState.initial());

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final stats = await _getStatsUseCase.execute();
      final startups = await _getAllStartupsUseCase.execute();
      final bookmarks = await _getBookmarksUseCase.execute();
      final interests = await _getInterestsUseCase.execute();
      final intros = await _getIntrosUseCase.execute();

      state = state.copyWith(
        isLoading: false,
        stats: stats,
        startups: startups,
        bookmarks: bookmarks,
        interests: interests,
        intros: intros,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final investorProvider =
    StateNotifierProvider<InvestorNotifier, InvestorDashboardState>((ref) {
  return InvestorNotifier(
    getStatsUseCase: ref.read(getInvestorStatsUseCaseProvider),
    getAllStartupsUseCase: ref.read(getAllStartupsUseCaseProvider),
    getBookmarksUseCase: ref.read(getBookmarksUseCaseProvider),
    getInterestsUseCase: ref.read(getInterestsUseCaseProvider),
    getIntrosUseCase: ref.read(getIntrosUseCaseProvider),
  );
});
