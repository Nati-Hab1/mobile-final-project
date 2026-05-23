import '../../domain/entities/bookmark.dart';
import '../../domain/entities/interest.dart';
import '../../domain/entities/intro.dart';
import '../../domain/entities/investor_stats.dart';
import '../../domain/entities/startup.dart';

class InvestorDashboardState {
  final bool isLoading;
  final String? error;
  final InvestorStats? stats;
  final List<InvestorStartup>
      startups; // Changed from Startup to InvestorStartup
  final List<Bookmark> bookmarks;
  final List<InvestorInterest> interests;
  final List<InvestorIntro> intros;

  InvestorDashboardState({
    required this.isLoading,
    this.error,
    this.stats,
    required this.startups,
    required this.bookmarks,
    required this.interests,
    required this.intros,
  });

  factory InvestorDashboardState.initial() {
    return InvestorDashboardState(
      isLoading: false,
      error: null,
      stats: null,
      startups: [],
      bookmarks: [],
      interests: [],
      intros: [],
    );
  }

  InvestorDashboardState copyWith({
    bool? isLoading,
    String? error,
    InvestorStats? stats,
    List<InvestorStartup>? startups, // Changed from Startup to InvestorStartup
    List<Bookmark>? bookmarks,
    List<InvestorInterest>? interests,
    List<InvestorIntro>? intros,
  }) {
    return InvestorDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      stats: stats ?? this.stats,
      startups: startups ?? this.startups,
      bookmarks: bookmarks ?? this.bookmarks,
      interests: interests ?? this.interests,
      intros: intros ?? this.intros,
    );
  }
}
