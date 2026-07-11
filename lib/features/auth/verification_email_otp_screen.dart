import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/toast.dart';
import '../../services/supabase_service.dart';

class VerificationEmailOtpScreen extends StatefulWidget {
  const VerificationEmailOtpScreen({super.key});

  @override
  State<VerificationEmailOtpScreen> createState() =>
      _VerificationEmailOtpScreenState();
}

class _VerificationEmailOtpScreenState
    extends State<VerificationEmailOtpScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
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
    debugPrint('VerificationEmailOtpScreen extras: $extra');
    if (extra is Map && extra['email'] is String) {
      _email = extra['email'] as String;
      debugPrint('VerificationEmailOtpScreen email: $_email');
    }
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (_email == null || code.isEmpty) {
      showToast(context, 'Veuillez entrer le code reçu par email');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await SupabaseService.verifyEmailOtp(_email!, code);
      if (!mounted) return;
      showToast(context, 'Compte vérifié');
      context.go('/onboarding');
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Code invalide ou erreur : ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_email == null) {
      showToast(context, 'Email manquant pour renvoyer le code');
      return;
    }
    setState(() => _isResending = true);
    try {
      await SupabaseService.sendSignUpOtp(_email!);
      if (!mounted) return;
      showToast(context, 'Code renvoyé à $_email');
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Erreur lors du renvoi : ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;

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
                'Un code a été envoyé à ${_email ?? 'votre email'}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(hintText: '123456'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verify,
                  child: _isLoading
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
                onPressed: _isResending ? null : _resendOtp,
                child: _isResending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Renvoyer le code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
