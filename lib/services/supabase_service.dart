import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  static Future<AuthResponse> verifyOtp(
    String email,
    String token,
    OtpType type,
  ) {
    return client.auth.verifyOTP(email: email, token: token, type: type);
  }

  static Future<ResendResponse> resendOtp(String email, OtpType type) {
    return client.auth.resend(email: email, type: type);
  }

  static Future<void> resetPasswordForEmail(String email) {
    return client.auth.resetPasswordForEmail(email);
  }

  static Future<UserResponse> updateUserPassword(String password) {
    return client.auth.updateUser(UserAttributes(password: password));
  }

  static Future<void> signOut() {
    return client.auth.signOut();
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
        .upsert({
          'user_id': userId,
          'role_actif': roleActif,
          'roles_disponibles': [roleActif],
          'onboarding_completed': true,
        }, onConflict: 'user_id')
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de modifier le rôle actif.');
    }

    return AppUser.fromJson(record);
  }

  static Future<WasteScanResult> createWasteScanResultFromClassification({
    required String userId,
    required String categorie,
    required int confiance,
    required String detail,
    required String recommendation,
    required String depositPoint,
    required double distanceKm,
    required int points,
    required int impactKg,
  }) async {
    final Map<String, dynamic>? record = await client
        .from('waste_scan_results')
        .insert({
          'user_id': userId,
          'categorie': categorie,
          'confiance': confiance,
          'detail': detail,
          'recommendation': recommendation,
          'deposit_point': depositPoint,
          'distance_km': distanceKm,
          'points': points,
          'impact_kg': impactKg,
        })
        .select()
        .maybeSingle();

    if (record == null) {
      throw Exception('Impossible de sauvegarder le résultat de scan.');
    }

    return WasteScanResult.fromJson(record);
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
    int totalFcfa,
    List<Map<String, dynamic>> lignesCommande,
  ) async {
    final Map<String, dynamic>? record = await client
        .from('commandes')
        .insert({
          'user_id': userId,
          'total_fcfa': totalFcfa,
          'statut': 'en_attente',
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
    String recompenseId,
  ) async {
    await client.from('echanges_points').insert({
      'user_id': userId,
      'recompense_id': recompenseId,
      'status': 'demande',
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
        .update({'lu': true})
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
