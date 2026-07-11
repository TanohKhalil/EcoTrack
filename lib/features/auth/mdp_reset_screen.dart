import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import '../../providers/auth_controller.dart';

import 'package:ecotrack/core/utils/trace.dart';

class MdpResetScreen extends ConsumerStatefulWidget {
  const MdpResetScreen({super.key});

  @override
  ConsumerState<MdpResetScreen> createState() => _MdpResetScreenState();
}

class _MdpResetScreenState extends ConsumerState<MdpResetScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    final email = ref.read(authControllerProvider.notifier).pendingEmail;

    if (email == null) {
      showToast(
        context,
        'Aucune adresse email connue pour la réinitialisation.',
      );
      return;
    }
    if (code.isEmpty) {
      showToast(context, 'Veuillez entrer le code de vérification.');
      return;
    }
    if (password.isEmpty || confirm.isEmpty) {
      showToast(
        context,
        'Veuillez saisir et confirmer votre nouveau mot de passe.',
      );
      return;
    }
    if (password != confirm) {
      showToast(context, 'Les mots de passe ne correspondent pas.');
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .resetPasswordWithOtp(email, code, password);
    if (!mounted) return;
    final localContext = context;
    if (success) {
      showToast(localContext, 'Mot de passe mis à jour.');
      localContext.push('/mdp_confirmation');
    } else {
      final message = ref.read(authControllerProvider).message;
      showToast(
        localContext,
        message ?? 'Impossible de réinitialiser le mot de passe.',
      );
    }
  }

  Future<void> _resend() async {
    final email = ref.read(authControllerProvider.notifier).pendingEmail;
    if (email == null) {
      showToast(
        context,
        'Aucune adresse email connue pour la réinitialisation.',
      );
      return;
    }
    final success = await ref
        .read(authControllerProvider.notifier)
        .resendRecoveryOtp(email);
    if (!mounted) return;
    final localContext = context;
    final message = ref.read(authControllerProvider).message;
    if (success) {
      showToast(localContext, message ?? 'Code renvoyé.');
    } else {
      showToast(localContext, message ?? 'Impossible de renvoyer le code.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;
    final email = ref.read(authControllerProvider.notifier).pendingEmail;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                onTap: traceCallback(
                  "mdp_reset_screen.dart:27:onTap",
                  () => context.pop(),
                ),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Vérification'),
              const SizedBox(height: 8),
              Text(
                'Réinitialiser le mot de passe',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                email != null
                    ? 'Un code de récupération a été envoyé à $email.'
                    : 'Un code de récupération a été envoyé à votre adresse email.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              OtpInput(
                controller: _codeController,
                label: 'CODE DE VÉRIFICATION',
                hintText: '123456',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Code envoyé · ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.4),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: authState.canResend ? _resend : null,
                    child: Text(
                      authState.canResend
                          ? 'Renvoyer'
                          : 'Renvoyer dans ${authState.resendSecondsRemaining}s',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: authState.canResend
                            ? accentColor
                            : textColor.withValues(alpha: 0.4),
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Eyebrow(text: 'NOUVEAU MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration(context, '••••••••'),
                style: _inputStyle(context),
              ),
              const SizedBox(height: 15),
              const Eyebrow(text: 'CONFIRMER LE MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: _inputDecoration(context, '••••••••'),
                style: _inputStyle(context),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _submit,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Réinitialiser le mot de passe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.text.withValues(alpha: 0.5)),
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor.withValues(alpha: 0.16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: accentColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    );
  }

  TextStyle _inputStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;

    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
      fontFamily: 'Space Grotesk',
    );
  }
}
