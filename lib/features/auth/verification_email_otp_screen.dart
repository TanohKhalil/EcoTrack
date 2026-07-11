import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/toast.dart';
import '../../core/widgets/widgets.dart';
import '../../providers/auth_controller.dart';

class VerificationEmailOtpScreen extends ConsumerStatefulWidget {
  const VerificationEmailOtpScreen({super.key});

  @override
  ConsumerState<VerificationEmailOtpScreen> createState() =>
      _VerificationEmailOtpScreenState();
}

class _VerificationEmailOtpScreenState
    extends ConsumerState<VerificationEmailOtpScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _email;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map && extra['email'] is String) {
      _email = extra['email'] as String;
    }
  }

  Future<void> _verify() async {
    final email =
        _email ?? ref.read(authControllerProvider.notifier).pendingEmail;
    final code = _codeController.text.trim();
    if (email == null || code.isEmpty) {
      showToast(context, 'Veuillez entrer le code reçu par email');
      return;
    }
    final success = await ref
        .read(authControllerProvider.notifier)
        .verifySignUpOtp(email, code);
    if (!mounted) return;
    if (success) {
      showToast(context, 'Compte vérifié');
      context.go('/onboarding');
      return;
    }
    final message = ref.read(authControllerProvider).message;
    if (message != null) {
      showToast(context, message);
    }
  }

  Future<void> _resendOtp() async {
    final email =
        _email ?? ref.read(authControllerProvider.notifier).pendingEmail;
    if (email == null) {
      showToast(context, 'Email manquant pour renvoyer le code');
      return;
    }
    final success = await ref
        .read(authControllerProvider.notifier)
        .resendSignUpOtp(email);
    if (!mounted) return;
    final message = ref.read(authControllerProvider).message;
    if (!success && message != null) {
      showToast(context, message);
      return;
    }
    showToast(context, message ?? 'Code renvoyé.');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final email =
        _email ?? ref.read(authControllerProvider.notifier).pendingEmail;
    final resendRemaining = authState.resendSecondsRemaining;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Entrez le code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Un code a été envoyé à ${email ?? 'votre email'}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 18),
              OtpInput(
                controller: _codeController,
                label: 'CODE DE VÉRIFICATION',
                hintText: '123456',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _verify,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Vérifier'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: authState.canResend ? _resendOtp : null,
                child: authState.isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        resendRemaining > 0
                            ? 'Renvoyer dans ${resendRemaining}s'
                            : 'Renvoyer le code',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
