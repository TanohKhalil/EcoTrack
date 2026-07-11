import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/splash_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../features/auth/inscription_screen.dart';
import '../../features/auth/infos_perso_screen.dart';
import '../../features/auth/connexion_screen.dart';
import '../../features/auth/mdp_oublie_screen.dart';
import '../../features/auth/mdp_reset_screen.dart';
import '../../features/auth/mdp_confirmation_screen.dart';
import '../../features/auth/verification_email_screen.dart';
import '../../features/auth/verification_email_otp_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/tutoriel_screen.dart';
import '../../features/menage/accueil_menage_screen.dart';
import '../../features/menage/scanner_screen.dart';
import '../../features/menage/analyse_screen.dart';
import '../../features/menage/resultat_screen.dart';
import '../../features/menage/signalement_screen.dart';
import '../../features/menage/confirmation_signalement_screen.dart';
import '../../features/menage/signalement_doublon_screen.dart';
import '../../features/menage/vote_communautaire_screen.dart';
import '../../features/menage/suivi_signalement_screen.dart';
import '../../features/collecteur/accueil_collecteur_screen.dart';
import '../../features/collecteur/retrait_collecteur_screen.dart';
import '../../features/collecteur/notation_collecteur_screen.dart';
import '../../features/filiere/accueil_filiere_screen.dart';
import '../../features/mairie/dashboard_mairie_screen.dart';
import '../../features/carte/carte_screen.dart';
import '../../features/carte/fiche_point_screen.dart';
import '../../features/marketplace/marketplace_screen.dart';
import '../../features/marketplace/panier_screen.dart';
import '../../features/marketplace/paiement_commande_screen.dart';
import '../../features/marketplace/confirmation_commande_screen.dart';
import '../../features/impact/impact_carbone_screen.dart';
import '../../features/impact/historique_screen.dart';
import '../../features/assistant_vocal/assistant_vocal_screen.dart';
import '../../features/commun/profil_screen.dart';
import '../../features/commun/notifications_screen.dart';
import '../../features/commun/parametres_screen.dart';
import '../../features/commun/langue_screen.dart';
import '../../features/commun/aide_screen.dart';
import '../../features/commun/cgu_screen.dart';
import '../../features/commun/erreur_camera_screen.dart';
import '../../features/commun/erreur_reseau_screen.dart';
import '../services/ai_analysis_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  return GoRouter(
    refreshListenable: refreshNotifier,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.watch(authProvider);
      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final publicRoutes = <String>{
        '/',
        '/connexion',
        '/inscription',
        '/infos_perso',
        '/mdp_oublie',
        '/mdp_reset',
        '/mdp_confirmation',
        '/verification_email',
        '/verification_email_otp',
      };

      final currentPath = state.uri.path;
      if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
        return '/';
      }

      if (isLoggedIn) {
        final profileState = ref.watch(profileProvider);
        return profileState.when(
          data: (profile) {
            final roleActif = profile?.roleActif ?? '';
            if (roleActif.isEmpty && currentPath != '/onboarding') {
              return '/onboarding';
            }
            if (roleActif.isNotEmpty &&
                (publicRoutes.contains(currentPath) ||
                    currentPath == '/onboarding')) {
              if (roleActif == 'collecteur') {
                return '/accueil_collecteur';
              }
              if (roleActif == 'filiere') {
                return '/accueil_filiere';
              }
              if (roleActif == 'mairie') {
                return '/dashboard_mairie';
              }
              return '/accueil_menage';
            }
            return null;
          },
          loading: () => null,
          error: (_, __) => null,
        );
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/inscription',
        name: 'inscription',
        builder: (context, state) => const InscriptionScreen(),
      ),
      GoRoute(
        path: '/infos_perso',
        name: 'infos_perso',
        builder: (context, state) => const InfosPersoScreen(),
      ),
      GoRoute(
        path: '/connexion',
        name: 'connexion',
        builder: (context, state) => const ConnexionScreen(),
      ),
      GoRoute(
        path: '/mdp_oublie',
        name: 'mdp_oublie',
        builder: (context, state) => const MdpOublieScreen(),
      ),
      GoRoute(
        path: '/mdp_reset',
        name: 'mdp_reset',
        builder: (context, state) => const MdpResetScreen(),
      ),
      GoRoute(
        path: '/mdp_confirmation',
        name: 'mdp_confirmation',
        builder: (context, state) => const MdpConfirmationScreen(),
      ),
      GoRoute(
        path: '/verification_email',
        name: 'verification_email',
        builder: (context, state) => const VerificationEmailScreen(),
      ),
      GoRoute(
        path: '/verification_email_otp',
        name: 'verification_email_otp',
        builder: (context, state) => const VerificationEmailOtpScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/tutoriel',
        name: 'tutoriel',
        builder: (context, state) => const TutorielScreen(),
      ),
      GoRoute(
        path: '/accueil_menage',
        name: 'accueil_menage',
        builder: (context, state) => const AccueilMenageScreen(),
      ),
      GoRoute(
        path: '/scanner',
        name: 'scanner',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/analyse',
        name: 'analyse',
        builder: (context, state) => AnalyseScreen(
          key: state.pageKey,
          // state.extra may contain an image path from the scanner
          // pass it to the screen if available
          imagePath: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/resultat',
        name: 'resultat',
        builder: (context, state) => ResultatScreen(
          result: state.extra is AiClassificationResult
              ? state.extra as AiClassificationResult
              : null,
        ),
      ),
      GoRoute(
        path: '/signalement',
        name: 'signalement',
        builder: (context, state) => const SignalementScreen(),
      ),
      GoRoute(
        path: '/confirmation_signalement',
        name: 'confirmation_signalement',
        builder: (context, state) => const ConfirmationSignalementScreen(),
      ),
      GoRoute(
        path: '/signalement_doublon',
        name: 'signalement_doublon',
        builder: (context, state) => const SignalementDoublonScreen(),
      ),
      GoRoute(
        path: '/vote_communautaire',
        name: 'vote_communautaire',
        builder: (context, state) => const VoteCommunautaireScreen(),
      ),
      GoRoute(
        path: '/suivi_signalement',
        name: 'suivi_signalement',
        builder: (context, state) => const SuiviSignalementScreen(),
      ),
      GoRoute(
        path: '/accueil_collecteur',
        name: 'accueil_collecteur',
        builder: (context, state) => const AccueilCollecteurScreen(),
      ),
      GoRoute(
        path: '/retrait_collecteur',
        name: 'retrait_collecteur',
        builder: (context, state) => const RetraitCollecteurScreen(),
      ),
      GoRoute(
        path: '/notation_collecteur',
        name: 'notation_collecteur',
        builder: (context, state) => const NotationCollecteurScreen(),
      ),
      GoRoute(
        path: '/accueil_filiere',
        name: 'accueil_filiere',
        builder: (context, state) => const AccueilFiliereScreen(),
      ),
      GoRoute(
        path: '/dashboard_mairie',
        name: 'dashboard_mairie',
        builder: (context, state) => const DashboardMairieScreen(),
      ),
      GoRoute(
        path: '/carte',
        name: 'carte',
        builder: (context, state) => const CarteScreen(),
      ),
      GoRoute(
        path: '/fiche_point',
        name: 'fiche_point',
        builder: (context, state) => const FichePointScreen(),
      ),
      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/panier',
        name: 'panier',
        builder: (context, state) => const PanierScreen(),
      ),
      GoRoute(
        path: '/paiement_commande',
        name: 'paiement_commande',
        builder: (context, state) => const PaiementCommandeScreen(),
      ),
      GoRoute(
        path: '/confirmation_commande',
        name: 'confirmation_commande',
        builder: (context, state) => const ConfirmationCommandeScreen(),
      ),
      GoRoute(
        path: '/impact_carbone',
        name: 'impact_carbone',
        builder: (context, state) => const ImpactCarboneScreen(),
      ),
      GoRoute(
        path: '/historique',
        name: 'historique',
        builder: (context, state) => const HistoriqueScreen(),
      ),
      GoRoute(
        path: '/assistant_vocal',
        name: 'assistant_vocal',
        builder: (context, state) => const AssistantVocalScreen(),
      ),
      GoRoute(
        path: '/profil',
        name: 'profil',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/parametres',
        name: 'parametres',
        builder: (context, state) => const ParametresScreen(),
      ),
      GoRoute(
        path: '/langue',
        name: 'langue',
        builder: (context, state) => const LangueScreen(),
      ),
      GoRoute(
        path: '/aide',
        name: 'aide',
        builder: (context, state) => const AideScreen(),
      ),
      GoRoute(
        path: '/cgu',
        name: 'cgu',
        builder: (context, state) => const CguScreen(),
      ),
      GoRoute(
        path: '/erreur_camera',
        name: 'erreur_camera',
        builder: (context, state) => const ErreurCameraScreen(),
      ),
      GoRoute(
        path: '/erreur_reseau',
        name: 'erreur_reseau',
        builder: (context, state) => const ErreurReseauScreen(),
      ),
    ],
  );
});

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._ref) {
    _subscription = _ref.watch(authProvider.stream).listen((_) {
      notifyListeners();
    });
  }

  final Ref _ref;
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
