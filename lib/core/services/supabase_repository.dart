import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/supabase_models.dart';

class SupabaseRepository {
  SupabaseRepository(this._client);

  final SupabaseClient _client;

  Future<Profile?> fetchProfile(String userId) async {
    final Map<String, dynamic>? record = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (record == null) {
      return null;
    }

    return Profile.fromMap(record);
  }

  Future<Profile> upsertProfile(Profile profile) async {
    final Map<String, dynamic>? record = await _client
        .from('profiles')
        .upsert(profile.toJson(), onConflict: 'user_id')
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de créer ou mettre à jour le profil.');
    }

    return Profile.fromMap(record);
  }

  Future<List<Report>> fetchReportsForUser(String userId) async {
    final List<dynamic> data = await _client
        .from('reports')
        .select()
        .eq('user_id', userId);

    return data
        .map((item) => Report.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<Report> createReport(Report report) async {
    final Map<String, dynamic>? record = await _client
        .from('reports')
        .insert(report.toJson())
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de créer le rapport.');
    }

    return Report.fromMap(record);
  }

  Future<List<CollectionAssignment>> fetchCollectionsForCollector(
    String collectorId,
  ) async {
    final List<dynamic> data = await _client
        .from('collections')
        .select()
        .eq('collector_id', collectorId);

    return data
        .map(
          (item) => CollectionAssignment.fromMap(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Reward>> fetchAvailableRewards() async {
    final List<dynamic> data = await _client
        .from('rewards')
        .select()
        .eq('available', true);

    return data
        .map((item) => Reward.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<Redemption> createRedemption(Redemption redemption) async {
    final Map<String, dynamic>? record = await _client
        .from('redemptions')
        .insert(redemption.toJson())
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de créer le remboursement.');
    }

    return Redemption.fromMap(record);
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    await _client.from('reports').update({'status': status}).eq('id', reportId);
  }
}
