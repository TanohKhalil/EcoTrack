import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final int resendSecondsRemaining;

  const AuthState({
    this.status = AuthStatus.idle,
    this.message,
    this.resendSecondsRemaining = 0,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get canResend => resendSecondsRemaining == 0;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    int? resendSecondsRemaining,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
    );
  }
}

class AuthSignInResult {
  final bool success;
  final bool emailNotConfirmed;
  final String? message;

  const AuthSignInResult({
    required this.success,
    this.emailNotConfirmed = false,
    this.message,
  });
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());

  final Ref _ref;
  String? pendingEmail;
  Timer? _resendTimer;

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void reset() {
    state = const AuthState();
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void _setLoading([String? message]) {
    state = state.copyWith(status: AuthStatus.loading, message: message);
  }

  void _setError(String message) {
    state = state.copyWith(status: AuthStatus.error, message: message);
  }

  void _setSuccess([String? message]) {
    state = state.copyWith(status: AuthStatus.success, message: message);
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading();
    try {
      await SupabaseService.signUpWithEmail(email, password);
      pendingEmail = email;
      _startResendCountdown();
      _setSuccess('Un code de confirmation a été envoyé à $email.');
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Une erreur est survenue lors de la création du compte.');
      return false;
    }
  }

  Future<bool> verifySignUpOtp(String email, String token) async {
    _setLoading();
    try {
      await SupabaseService.verifyOtp(email, token, OtpType.signup);
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Code invalide ou expiré.');
      return false;
    }
  }

  Future<bool> resendSignUpOtp(String email) async {
    if (!state.canResend) {
      return false;
    }
    _setLoading();
    try {
      await SupabaseService.resendOtp(email, OtpType.signup);
      _startResendCountdown();
      _setSuccess('Code renvoyé.');
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Impossible de renvoyer le code.');
      return false;
    }
  }

  Future<bool> resendRecoveryOtp(String email) async {
    if (!state.canResend) {
      return false;
    }
    _setLoading();
    try {
      await SupabaseService.resendOtp(email, OtpType.recovery);
      _startResendCountdown();
      _setSuccess('Code de récupération renvoyé.');
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Impossible de renvoyer le code de récupération.');
      return false;
    }
  }

  void startResendCountdown([int seconds = 60]) {
    if (!state.canResend) {
      return;
    }
    _startResendCountdown(seconds);
  }

  void _startResendCountdown([int seconds = 60]) {
    _resendTimer?.cancel();
    state = state.copyWith(resendSecondsRemaining: seconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendSecondsRemaining - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(resendSecondsRemaining: 0);
        return;
      }
      state = state.copyWith(resendSecondsRemaining: remaining);
    });
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading();
    try {
      await SupabaseService.resetPasswordForEmail(email);
      pendingEmail = email;
      _startResendCountdown();
      _setSuccess('Code de récupération envoyé.');
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Impossible d\'envoyer le code de réinitialisation.');
      return false;
    }
  }

  Future<bool> resetPasswordWithOtp(
    String email,
    String token,
    String password,
  ) async {
    _setLoading();
    try {
      await SupabaseService.verifyOtp(email, token, OtpType.recovery);
      await SupabaseService.updateUserPassword(password);
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Impossible de réinitialiser le mot de passe.');
      return false;
    }
  }

  Future<AuthSignInResult> signIn(String email, String password) async {
    _setLoading();
    try {
      final response = await SupabaseService.signInWithEmail(email, password);
      if (response.session == null) {
        const message = 'Échec de la connexion. Vérifiez vos identifiants.';
        _setError(message);
        return const AuthSignInResult(success: false, message: message);
      }
      _setSuccess();
      return const AuthSignInResult(success: true);
    } on AuthException catch (e) {
      final lower = e.message.toLowerCase();
      final emailNotConfirmed =
          lower.contains('confirm') ||
          lower.contains('verified') ||
          lower.contains('verify') ||
          lower.contains('verification');
      _setError(e.message);
      return AuthSignInResult(
        success: false,
        emailNotConfirmed: emailNotConfirmed,
        message: e.message,
      );
    } catch (e) {
      const errorMessage = 'Échec de la connexion. Vérifiez vos identifiants.';
      _setError(errorMessage);
      return const AuthSignInResult(success: false, message: errorMessage);
    }
  }
}
