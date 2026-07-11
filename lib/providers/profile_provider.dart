import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../services/supabase_service.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<AppUser?>>((ref) {
      return ProfileNotifier();
    });

class ProfileNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  ProfileNotifier() : super(const AsyncValue.loading());

  void clearProfile() {
    state = const AsyncValue.data(null);
  }

  Future<void> loadProfile(String userId) async {
    state = const AsyncValue.loading();
    try {
      final profile = await SupabaseService.fetchProfile(userId);
      state = AsyncValue.data(profile);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> updateProfile(AppUser profile) async {
    state = const AsyncValue.loading();
    try {
      final updated = await SupabaseService.updateProfile(profile);
      state = AsyncValue.data(updated);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> changeRoleActif(String userId, String roleActif) async {
    state = const AsyncValue.loading();
    try {
      final updated = await SupabaseService.changeRoleActif(userId, roleActif);
      state = AsyncValue.data(updated);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> addRoleDisponible(String userId, String roleName) async {
    state = const AsyncValue.loading();
    try {
      final updated = await SupabaseService.addRoleDisponible(userId, roleName);
      state = AsyncValue.data(updated);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
