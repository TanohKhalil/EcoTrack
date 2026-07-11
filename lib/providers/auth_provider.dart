import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

final authProvider = StreamProvider<User?>((ref) async* {
  yield SupabaseService.client.auth.currentUser;
  yield* SupabaseService.client.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
});

final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions();
});

class AuthActions {
  Future<AuthResponse> signIn(String email, String password) {
    return SupabaseService.signInWithEmail(email, password);
  }

  Future<AuthResponse> signUp(String email, String password) {
    return SupabaseService.signUpWithEmail(email, password);
  }

  Future<void> signOut() {
    return SupabaseService.signOut();
  }

  Future<void> resetPassword(String email) {
    return SupabaseService.resetPasswordForEmail(email);
  }
}
