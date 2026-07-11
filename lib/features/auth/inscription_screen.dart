import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/widgets/toast.dart';
import 'package:ecotrack/services/supabase_service.dart'; // Ensure SupabaseService is imported

import 'package:ecotrack/core/utils/trace.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  String _method = 'tel';
  bool _isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

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
                  "inscription_screen.dart:34:onTap",
                  () => context.pop(),
                ),
                icon: Icons.arrow_back_ios_new,
              ),
              const SizedBox(height: 26),
              const Eyebrow(text: 'Créer un compte'),
              const SizedBox(height: 8),
              Text(
                'Rejoindre EcoTrack',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Inscrivez-vous avec votre numéro ou une adresse email.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.5),
                  fontFamily: 'Space Grotesk',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: traceCallback(
                        "inscription_screen.dart:66:onTap",
                        () => setState(() => _method = 'tel'),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: _method == 'tel'
                              ? accentColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _method == 'tel'
                                ? accentColor
                                : accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Téléphone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _method == 'tel'
                                ? AppTheme.accentInk
                                : textColor.withValues(alpha: 0.6),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: traceCallback(
                        "inscription_screen.dart:98:onTap",
                        () => setState(() => _method = 'email'),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: _method == 'email'
                              ? accentColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _method == 'email'
                                ? accentColor
                                : accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _method == 'email'
                                ? AppTheme.accentInk
                                : textColor.withValues(alpha: 0.6),
                            fontFamily: 'Space Grotesk',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_method == 'tel') ...[
                const Eyebrow(text: 'NUMÉRO DE TÉLÉPHONE'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        '+225',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: '07 00 00 00 00',
                          hintStyle: TextStyle(
                            color: textColor.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: accentColor.withValues(alpha: 0.16),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: accentColor.withValues(alpha: 0.16),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: accentColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Phone sign-up not ready
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Inscription par téléphone — Bientôt disponible',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            showToast(context, 'Bientôt disponible'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ] else ...[
                const Eyebrow(text: 'ADRESSE EMAIL'),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'aya@exemple.ci',
                    hintStyle: TextStyle(
                      color: textColor.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(
                        color: accentColor.withValues(alpha: 0.16),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(
                        color: accentColor.withValues(alpha: 0.16),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Text(
                    'Un lien de confirmation vous sera envoyé à cette adresse après l\'inscription.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.6),
                      fontFamily: 'Space Grotesk',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
              const Eyebrow(text: 'MOT DE PASSE'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: accentColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final ctx = context;
                          if (_method == 'tel') {
                            showToast(
                              ctx,
                              'Inscription par téléphone bientôt disponible',
                            );
                            return;
                          }
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          debugPrint(
                            'Inscription: email=$email passwordSet=${password.isNotEmpty}',
                          );
                          if (email.isEmpty || password.isEmpty) {
                            showToast(
                              ctx,
                              'Veuillez renseigner email et mot de passe',
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          try {
                            await SupabaseService.sendSignUpOtp(email);
                            debugPrint('Supabase OTP envoyé pour $email');
                            if (ctx.mounted) {
                              ctx.push(
                                '/verification_email_otp',
                                extra: {'email': email},
                              );
                            }
                          } catch (e) {
                            debugPrint('Erreur sendSignUpOtp: $e');
                            if (ctx.mounted) {
                              showToast(
                                ctx,
                                'Erreur lors de l\'envoi du code : ${e.toString()}',
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Vérifier et continuer →'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà inscrit ? ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.5),
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  GestureDetector(
                    onTap: traceCallback(
                      "inscription_screen.dart:365:onTap",
                      () => context.push('/connexion'),
                    ),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // OTP box helper removed (unused)
}
