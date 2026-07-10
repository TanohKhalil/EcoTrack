# Rapport : Callbacks des boutons

Date: 2026-07-10

Résumé : 240 occurrences trouvées dans 43 fichiers (recherche : onPressed|onTap|GestureDetector|InkWell|ElevatedButton|TextButton|IconButton|FloatingActionButton|RawMaterialButton|RaisedButton)

Extraits par fichier (sélection des lignes pertinentes trouvées) :

- lib/core/theme/app_theme.dart
  - lignes avec `elevatedButtonTheme` / `ElevatedButton.styleFrom`

- lib/core/widgets/botton_nav.dart
  - `final Function(int) onTap;`
  - `return GestureDetector(...)`

- lib/core/widgets/widgets.dart
  - plusieurs `GestureDetector` avec `onTap`

- lib/features/assistant_vocal/assistant_vocal_screen.dart
  - `onTap: () => context.pop(),`
  - `onPressed: () => context.push('/signalement'),`

- lib/features/auth/connexion_screen.dart
  - `onTap: () => context.pop(),`
  - `onTap: () => context.push('/mdp_oublie'),`
  - `onPressed: () => context.push('/accueil_menage'),`

- lib/features/auth/infos_perso_screen.dart
  - `onTap: () => context.pop(),`
  - `ElevatedButton` avec `onPressed` (plusieurs)

- lib/features/auth/inscription_screen.dart
  - `onTap: () => context.pop(),`
  - `onTap: () => setState(() => _method = 'tel'),`
  - `onPressed: () => context.push('/infos_perso'),`

- lib/features/auth/mdp_confirmation_screen.dart
  - `onPressed: () => context.push('/connexion'),`

- lib/features/auth/mdp_oublie_screen.dart
  - `onTap: () => context.pop(),`
  - `ElevatedButton` avec `onPressed` (callbacks inline)

- lib/features/auth/mdp_reset_screen.dart
  - `onTap: () => context.pop(),` et `GestureDetector` usages

- lib/features/auth/splash_screen.dart
  - `ElevatedButton` -> `onPressed: () => context.push('/inscription')`

- lib/features/auth/verification_email_screen.dart
  - `ElevatedButton` avec `onPressed`

- lib/features/carte/carte_screen.dart
  - `onTap: () => context.pop(),`
  - `ElevatedButton.icon` `onPressed: () => context.push('/signalement')`
  - nombreux `GestureDetector(onTap: ...)`

- lib/features/carte/fiche_point_screen.dart
  - `onTap: () => context.pop(),` et `onPressed` pour navigation

- lib/features/collecteur/\*
  - divers `onTap` / `ElevatedButton.onPressed`

- lib/features/commun/\*
  - `aide_screen`, `erreur_camera_screen`, `erreur_reseau_screen`, `langue_screen`, `notifications_screen`, `parametres_screen`, `profil_screen` contiennent des callbacks

- lib/features/marketplace/\*
  - `panier`, `paiement_commande_screen`, `marketplace_screen` etc. avec `onTap`/`onPressed`

- lib/features/menage/\*
  - nombreux `GestureDetector` et `ElevatedButton.onPressed` (scanner, signalement, résultat, etc.)

- lib/features/onboarding/\*
  - `onTap` pour navigation entre pages et `ElevatedButton.onPressed`

Remarques :

- Beaucoup de callbacks sont des closures inline (`() => context.push('/route')`) ou des `GestureDetector(onTap: onTap)` passés depuis des widgets réutilisables.
- Instrumenter automatiquement tous les callbacks en modifiant 240 emplacements est risqué sans revue (peut casser la logique ou le formatage).

Propositions d'actions suivantes :

- Option 1 (sûre) : ajouter des `print`/logs uniquement aux fichiers écran les plus critiques (ex : `connexion_screen.dart`, `splash_screen.dart`, `carte_screen.dart`, `scanner_screen.dart`) afin de reproduire le bug.
- Option 2 (automatisée) : générer et appliquer un patch qui enveloppe tous les `onPressed/onTap` simples avec un wrapper `traceCallback(name, cb)` — plus rapide mais nécessite tests.
- Option 3 : je crée des tests manuels/steps pour reproduire le problème et vous guide pour exécuter l'app et capturer les logs.

Dites quelle option vous préférez (1/2/3) ou précisez quels écrans vous voulez d'abord tracer.
