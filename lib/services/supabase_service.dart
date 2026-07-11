import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/gotrue.dart';

import '../models/app_user.dart';
import '../models/collect_point.dart';
import '../models/collecteur.dart';
import '../models/dashboard_mairie.dart';
import '../models/impact_carbone.dart';
import '../models/itineraire_arret.dart';
import '../models/produit_marketplace.dart';
import '../models/signalement.dart';
import '../models/signalement_etape.dart';
import '../models/waste_scan_result.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final env = await _loadEnv();
    await Supabase.initialize(
      url: env['supabaseUrl']!,
      publishableKey: env['supabaseAnonKey']!,
      headers: const {},
    );
  }

  static Future<Map<String, String>> _loadEnv() async {
    final raw = await rootBundle.loadString('assets/env.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return json.map((key, value) => MapEntry(key, value.toString()));
  }

  // Auth
  static Future<AuthResponse> signInWithEmail(String email, String password) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUpWithEmail(String email, String password) {
    return client.auth.signUp(email: email, password: password);
  }

  static Future<void> sendSignUpOtp(String email) {
    return client.auth.signInWithOtp(email: email, shouldCreateUser: true);
  }

  static Future<AuthResponse> verifyEmailOtp(String email, String token) {
    return client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
  }

  static Future<void> signOut() {
    return client.auth.signOut();
  }

  static Future<void> resetPassword(String email) {
    return client.auth.resetPasswordForEmail(email);
  }

  // Profils
  static Future<AppUser?> fetchProfile(String userId) async {
    final Map<String, dynamic>? record = await client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (record == null) {
      return null;
    }

    return AppUser.fromJson(record);
  }

  static Future<AppUser> updateProfile(AppUser profile) async {
    final Map<String, dynamic>? record = await client
        .from('profiles')
        .upsert(profile.toJson(), onConflict: 'user_id')
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de mettre à jour le profil.');
    }

    return AppUser.fromJson(record);
  }

  static Future<AppUser> changeRoleActif(
    String userId,
    String roleActif,
  ) async {
    final Map<String, dynamic>? record = await client
        .from('profiles')
        .update({'role_actif': roleActif})
        .eq('user_id', userId)
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de modifier le rôle actif.');
    }

    return AppUser.fromJson(record);
  }

  static Future<AppUser> addRoleDisponible(
    String userId,
    String roleName,
  ) async {
    final existing = await fetchProfile(userId);
    final roles =
        existing?.rolesDisponibles.toSet().union({roleName}).toList() ??
        [roleName];

    final Map<String, dynamic>? record = await client
        .from('profiles')
        .update({'roles_disponibles': roles})
        .eq('user_id', userId)
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible d\'ajouter le rôle disponible.');
    }

    return AppUser.fromJson(record);
  }

  // Signalements
  static Future<String> uploadSignalementPhoto(
    Uint8List data,
    String fileName,
  ) async {
    final uploadedPath = await client.storage
        .from('signalements')
        .uploadBinary(
          fileName,
          data,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    return client.storage.from('signalements').getPublicUrl(uploadedPath);
  }

  static Future<Signalement> createSignalement(Signalement signalement) async {
    final Map<String, dynamic>? record = await client
        .from('signalements')
        .insert(signalement.toJson())
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de créer le signalement.');
    }

    return Signalement.fromJson(record);
  }

  static Future<List<Signalement>> fetchSignalements(String userId) async {
    final List<dynamic> data = await client
        .from('signalements')
        .select()
        .eq('user_id', userId);

    return data
        .map((item) => Signalement.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<SignalementEtape>> fetchSignalementTimeline(
    String signalementId,
  ) async {
    final List<dynamic> data = await client
        .from('signalement_etapes')
        .select()
        .eq('signalement_id', signalementId);

    return data
        .map((item) => SignalementEtape.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Scanner
  static Future<WasteScanResult> createWasteScanResult(
    WasteScanResult scan,
  ) async {
    final Map<String, dynamic>? record = await client
        .from('waste_scan_results')
        .insert(scan.toJson())
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de sauvegarder le résultat de scan.');
    }

    return WasteScanResult.fromJson(record);
  }

  // Carte
  static Future<List<CollectPoint>> fetchCollectPoints({
    String? categorie,
  }) async {
    final query = client.from('collect_points').select();
    if (categorie != null && categorie.isNotEmpty) {
      query.eq('categorie', categorie);
    }

    final List<dynamic> data = await query;
    return data
        .map((item) => CollectPoint.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Collecteur
  static Future<Collecteur?> fetchCollecteurStats(String userId) async {
    final Map<String, dynamic>? record = await client
        .from('collecteur_stats')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (record == null) return null;
    return Collecteur.fromJson(record);
  }

  static Future<List<ItineraireArret>> fetchItineraireArrets(
    String collecteurId,
  ) async {
    final List<dynamic> data = await client
        .from('itineraire_arrets')
        .select()
        .eq('collecteur_id', collecteurId)
        .order('ordre', ascending: true);

    return data
        .map((item) => ItineraireArret.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Marketplace
  static Future<List<ProduitMarketplace>> fetchProduitsMarketplace() async {
    final List<dynamic> data = await client
        .from('produits_marketplace')
        .select();
    return data
        .map(
          (item) => ProduitMarketplace.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<void> createCommande(
    String userId,
    int totalPoints,
    List<Map<String, dynamic>> lignesCommande,
  ) async {
    final Map<String, dynamic>? record = await client
        .from('commandes')
        .insert({
          'user_id': userId,
          'total_points': totalPoints,
          'statut': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .maybeSingle();

    final commandeId = record?['id']?.toString();
    if (commandeId == null || commandeId.isEmpty) {
      throw Exception('La commande n\'a pas pu être créée.');
    }

    final lignes = lignesCommande
        .map((item) => {...item, 'commande_id': commandeId})
        .toList();

    await client.from('lignes_commande').insert(lignes);
  }

  // Récompenses
  static Future<List<Map<String, dynamic>>> fetchRecompenses() async {
    final List<dynamic> data = await client
        .from('recompenses')
        .select()
        .eq('disponible', true);

    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> createEchangePoints(
    String userId,
    String rewardId,
  ) async {
    await client.from('echanges_points').insert({
      'user_id': userId,
      'reward_id': rewardId,
      'statut': 'demandé',
      'requested_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Notifications
  static Future<List<Map<String, dynamic>>> fetchNotifications(
    String userId,
  ) async {
    final List<dynamic> data = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> markAllRead(String userId) async {
    await client
        .from('notifications')
        .update({'read': true})
        .eq('user_id', userId);
  }

  // Votes
  static Future<void> submitVote(
    String userId,
    String signalementId,
    int score,
  ) async {
    await client.from('votes_communautaires').insert({
      'user_id': userId,
      'signalement_id': signalementId,
      'score': score,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
