class InvestorStats {
  final int totalIntros;
  final int followUps;
  final int startupsCount;
  final int completedIntros;

  InvestorStats({
    required this.totalIntros,
    required this.followUps,
    required this.startupsCount,
    required this.completedIntros,
  });

  factory InvestorStats.fromJson(Map<String, dynamic> json) {
    return InvestorStats(
      totalIntros: json['total_intros'] ?? 0,
      followUps: json['follow_ups'] ?? 0,
      startupsCount: json['startups_count'] ?? 0,
      completedIntros: json['completed_intros'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_intros': totalIntros,
      'follow_ups': followUps,
      'startups_count': startupsCount,
      'completed_intros': completedIntros,
    };
  }
}
