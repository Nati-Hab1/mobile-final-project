import 'package:menesha/features/investor/domain/entities/interest.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/intro.dart';
import '../../domain/entities/investor_stats.dart';
import '../../domain/entities/startup.dart';
import '../models/startup_model.dart';

class InvestorRemoteDatasource {
  // Add these methods to InvestorRemoteDatasource class

  Future<List<InvestorInterest>> getInterests() async {
    final response = await DioClient.get(ApiConstants.investorInterests);
    final interests = response.data['data']['interests'] as List;
    return interests.map((json) => InvestorInterest.fromJson(json)).toList();
  }

  Future<InvestorInterest> expressInterest(int startupId,
      {String? message}) async {
    final response = await DioClient.post(
      ApiConstants.investorInterests,
      data: {
        'startup_id': startupId,
        'message': message,
      },
    );
    return InvestorInterest.fromJson(response.data['data']['interest']);
  }

  // Dashboard Stats - Return InvestorStats directly
  Future<InvestorStats> getDashboardStats() async {
    final response = await DioClient.get('/investor/dashboard-stats');
    return InvestorStats.fromJson(response.data['data']);
  }

  // Startups - Return InvestorStartup list
  Future<List<InvestorStartup>> getAllStartups() async {
    final response = await DioClient.get(ApiConstants.startups);
    final startups = response.data['data']['startups'] as List;
    return startups.map((json) => InvestorStartup.fromJson(json)).toList();
  }

  // Bookmarks
  Future<List<Bookmark>> getBookmarks() async {
    final response = await DioClient.get(ApiConstants.investorBookmarks);
    final bookmarks = response.data['data']['bookmarks'] as List;
    return bookmarks.map((json) => Bookmark.fromJson(json)).toList();
  }

  Future<Bookmark> addBookmark(int startupId, {String? note}) async {
    final response = await DioClient.post(
      ApiConstants.investorBookmarks,
      data: {
        'startup_id': startupId,
        'note': note,
      },
    );
    return Bookmark.fromJson(response.data['data']['bookmark']);
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    await DioClient.delete(ApiConstants.bookmarkById(bookmarkId));
  }

  Future<Bookmark> updateBookmarkNote(int bookmarkId, String note) async {
    final response = await DioClient.patch(
      ApiConstants.bookmarkById(bookmarkId),
      data: {'note': note},
    );
    return Bookmark.fromJson(response.data['data']['bookmark']);
  }

  // Intros - Return InvestorIntro list
  Future<List<InvestorIntro>> getIntros() async {
    final response = await DioClient.get(ApiConstants.myIntros);
    final intros = response.data['data']['intros'] as List;
    return intros.map((json) => InvestorIntro.fromJson(json)).toList();
  }

  Future<void> acceptIntro(int introId) async {
    await DioClient.patch(
      '/intros/$introId/status',
      data: {'status': 'accepted'},
    );
  }

  Future<void> declineIntro(int introId) async {
    await DioClient.patch(
      '/intros/$introId/status',
      data: {'status': 'declined'},
    );
  }
}
