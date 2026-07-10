# EcoTrack — Cahier des charges de développement Flutter
## Document de référence unique pour l'agent IA de développement

**Source :** Maquette interactive HTML/JS finale (`EcoTrack_Maquette_Interactive.html`), 41 écrans, entièrement analysée et retranscrite ci-dessous.
**Objectif de ce document :** permettre à un agent IA de coder l'application Flutter en reproduisant **fidèlement et intégralement** la maquette — aucun écran, aucun texte, aucune interaction ne doit être omis, simplifié ou deviné.

---

## 0. Instructions impératives pour l'agent IA

1. **Reproduire les 41 écrans listés en section 5, sans exception.** Si un écran semble redondant, le coder quand même : chaque `data-screen` de la maquette correspond à une route Flutter distincte.
2. **Respecter le texte exact** de chaque écran (labels, boutons, messages). Ne pas reformuler, paraphraser ou raccourcir les textes fournis entre guillemets.
3. **Respecter le graphe de navigation exact** fourni en section 4 — chaque bouton doit naviguer vers l'écran précisé, pas vers un écran "logique" supposé.
4. **Respecter le design system** (couleurs, typographies, rayons d'arrondi) fourni en section 2, y compris le **mode sombre par défaut avec bascule vers un mode clair**.
5. **Ne pas ajouter de fonctionnalités non spécifiées ici.** Si quelque chose manque en section 5, considérer que ce n'est pas encore fonctionnel dans le prototype (ex. IoT, IA distante) et le simuler avec des données statiques (mock).
6. En cas d'ambiguïté entre ce document et une intuition de "bonne pratique UX", **ce document fait autorité**, car il retranscrit une maquette déjà validée.

---

## 1. Vue d'ensemble du produit

**Nom de l'application :** EcoTrack
**Positionnement :** Plateforme IA + IoT de gestion intelligente des déchets, pensée pour la Côte d'Ivoire (Abidjan et au-delà).
**Cycle fonctionnel central :** Signalement → tri → collecte → valorisation → revenu.
**Quatre profils utilisateurs distincts, dans une seule et même application :**
1. **Ménage / Commerce** — trie, signale, gagne des points.
2. **Collecteur informel** — charrette, moto ou à pied ; suit un itinéraire optimisé par IA, retire ses revenus.
3. **Filière de valorisation** — recycleur, compost, biogaz, e-waste ; consulte les volumes disponibles, réserve des lots.
4. **Mairie / Collectivité** — dashboard B2G de pilotage territorial.

Chaque profil possède son propre écran d'accueil, mais partage le même système d'authentification, de profil, de paramètres et d'aide.

---

## 2. Design system (à respecter strictement)

### 2.1 Palette — Mode sombre (thème par défaut)

```
--bg:        #0E1912   (fond principal)
--deep:      #0A140E   (fond profond, ex. header de carte)
--surface:   #152318   (surfaces, barre de navigation)
--card:      #1B2B1F   (cartes)
--text:      #EAF3EC   (texte principal)
--accent:    #34D399   (vert accent principal — CTA, éléments actifs)
--accent-ink:#052017   (texte sur fond accent)
--soft:      #7FDDB4   (vert secondaire)
--organic:   #D98A4A   (orange — catégorie organique)
--plastic:   #3FB6E8   (bleu — catégorie plastique)
--danger:    #F26B5E   (rouge — alertes, dépôts sauvages)
--gold:      #F6C453   (or — récompenses, points)
--blue:      #5B8CFF   (bleu secondaire)
```

### 2.2 Palette — Mode clair (bascule via `toggleTheme()`)

```
--bg:        #F1F7EF
--deep:      #E6EFE2
--surface:   #FFFFFF
--card:      #FFFFFF
--text:      #122C1B
--accent:    #189A63
--accent-ink:#F3FBF4
--soft:      #0E7A4D
--organic:   #B2661F
--plastic:   #1C7FAE
--danger:    #D14538
--gold:      #B4820E
--blue:      #3559C9
```
→ En Flutter : implémenter via `ThemeData` clair/sombre avec `ThemeMode` piloté par un `Provider`/`Notifier`, bascule accessible depuis un bouton icône présent en haut de la plupart des écrans (`toggleTheme()`).

### 2.3 Typographie
- **Police d'interface :** `Space Grotesk` (poids 400, 500, 600, 700) — tous les textes UI, boutons, labels.
- **Police d'accent/display :** `Fraunces` (italique, poids 500) — réservée aux moments d'emphase visuelle (à utiliser avec parcimonie, ex. citations ou titres marquants si repérés dans la maquette).
- En Flutter : charger ces deux polices via `google_fonts` (`GoogleFonts.spaceGrotesk()`, `GoogleFonts.fraunces()`).

### 2.4 Style des composants
- **Rayon d'arrondi :** cartes et boutons largement arrondis (16–22px équivalent).
- **Cartes :** fond `--card`, bordure fine semi-transparente teintée accent (`rgba(accent, .14)`).
- **Boutons primaires :** fond `--accent`, texte `--accent-ink`.
- **Boutons secondaires/fantômes :** fond transparent, bordure `--accent` à 35-40% d'opacité.
- **Icônes :** style trait fin (stroke), pas de remplissage plein, cohérent avec des icônes de type Lucide/Feather (`stroke-width` ~1.8-2.2).
- **Animations à reproduire (valeur d'ambiance, non bloquantes) :** pulsation douce autour du bouton scanner (effet "ping"), indicateur "live" clignotant (collecteur en approche), transitions douces d'apparition (`fade-in`/`rise`).
- **Emoji utilisés tels quels dans le texte source** (ex. 🇨🇮, 🔥, 🌳, 🚗, 🌿) — à conserver, pas à remplacer par des icônes vectorielles.

---

## 3. Architecture Flutter recommandée

```
lib/
├── main.dart
├── app.dart                         # MaterialApp.router + ThemeMode dynamique
├── core/
│   ├── router/app_router.dart       # go_router, une route par écran (section 5)
│   ├── theme/app_theme.dart         # thèmes clair/sombre section 2
│   ├── constants/mock_data.dart     # données fictives section 7
│   └── widgets/                     # BottomNavBar, StatCard, RewardCard, etc.
├── features/
│   ├── auth/            (splash, inscription, infos_perso, connexion, mdp_*, verification_email)
│   ├── onboarding/       (onboarding, tutoriel)
│   ├── menage/           (accueil_menage, scanner, analyse, resultat, signalement, confirmation_signalement, signalement_doublon, vote_communautaire, suivi_signalement)
│   ├── collecteur/       (accueil_collecteur, retrait_collecteur, notation_collecteur)
│   ├── filiere/          (accueil_filiere)
│   ├── mairie/           (dashboard_mairie)
│   ├── carte/            (carte, fiche_point)
│   ├── marketplace/      (marketplace, panier, paiement_commande, confirmation_commande)
│   ├── impact/           (impact_carbone, historique)
│   ├── assistant_vocal/  (assistant_vocal)
│   └── commun/           (profil, notifications, parametres, langue, aide, cgu, erreur_camera, erreur_reseau)
└── services/
    ├── ai_classification_service.dart   # mock du scanner IA (section 5.10-5.12)
    ├── payment_service.dart             # mock Mobile Money
    └── location_service.dart
```

**Gestion d'état recommandée :** `flutter_riverpod` (un `StateNotifier`/`Notifier` par domaine : thème, panier, profil actif, langue).
**Navigation :** `go_router`, avec une route nommée par valeur de `data-screen` (ex. `/accueil_menage`, `/scanner`, `/fiche_point`).

---

## 4. Graphe de navigation complet (exact, extrait de la maquette)

| Écran source | Navigue vers (dans l'ordre d'apparition des boutons) |
|---|---|
| splash | inscription, connexion |
| inscription | splash, infos_perso, connexion |
| infos_perso | inscription, cgu |
| connexion | splash, mdp_oublie, accueil_menage, inscription |
| mdp_oublie | connexion, mdp_reset, connexion |
| mdp_reset | mdp_oublie, mdp_confirmation |
| mdp_confirmation | connexion |
| onboarding | inscription, tutoriel, accueil_collecteur, accueil_filiere, dashboard_mairie |
| accueil_menage | notifications, profil, scanner, signalement, historique, carte, notation_collecteur |
| scanner | accueil_menage, assistant_vocal, analyse, carte, erreur_camera |
| analyse | resultat |
| resultat | accueil_menage, carte, signalement, vote_communautaire |
| signalement | accueil_menage, assistant_vocal, signalement_doublon |
| confirmation_signalement | suivi_signalement, accueil_menage |
| carte | accueil_menage, signalement, fiche_point |
| accueil_collecteur | onboarding, profil, carte, retrait_collecteur |
| accueil_filiere | onboarding, marketplace |
| dashboard_mairie | onboarding, carte, impact_carbone |
| profil | accueil_menage, historique, parametres, aide, accueil_collecteur, dashboard_mairie, impact_carbone, connexion |
| notifications | accueil_menage, suivi_signalement |
| marketplace | accueil_filiere, panier |
| impact_carbone | profil |
| assistant_vocal | accueil_menage, signalement |
| historique | accueil_menage |
| suivi_signalement | accueil_menage |
| notation_collecteur | accueil_menage |
| verification_email | onboarding |
| tutoriel | accueil_menage |
| vote_communautaire | resultat |
| retrait_collecteur | accueil_collecteur |
| panier | marketplace, paiement_commande |
| paiement_commande | panier, confirmation_commande |
| confirmation_commande | marketplace |
| langue | parametres |
| parametres | profil, langue, aide, cgu |
| aide | profil |
| cgu | inscription |
| erreur_camera | scanner |
| erreur_reseau | accueil_menage |
| signalement_doublon | signalement, suivi_signalement, confirmation_signalement |
| fiche_point | carte, signalement |

**Note sur `onboarding` :** cet écran sert de sélecteur de profil ("Je rejoins EcoTrack en tant que…") et redirige selon le choix vers `tutoriel` (Ménage), `accueil_collecteur`, `accueil_filiere` ou `dashboard_mairie`.

**Barre de navigation basse (bottom nav), présente sur les écrans d'accueil du profil Ménage :**
`Accueil` (actif) · `Carte` → carte · `Signaler` → signalement · `Profil` → profil

---

## 5. Catalogue exhaustif des 41 écrans

Pour chaque écran : **rôle concerné**, **objectif**, **contenu textuel exact à reproduire**, **éléments/interactions spécifiques**.

### 5.1 `splash` — Écran d'accueil au lancement
**Rôle :** tous.
**Texte exact :** « 🇨🇮 Pensé pour Abidjan » (badge) · « IA + IoT · gestion des déchets » (sous-titre eyebrow) · « EcoTrack » (titre) · « Signalement → tri → collecte → valorisation → revenu » (accroche du cycle) · Bouton « Commencer » · « Déjà membre ? » + lien « Se connecter ».
**Navigation :** Commencer → `inscription` ; Se connecter → `connexion`.

### 5.2 `inscription` — Création de compte
**Texte exact :** « Créer un compte » (eyebrow) · « Rejoindre EcoTrack » (titre) · « Inscrivez-vous avec votre numéro ou une adresse email. » · Onglets « Téléphone » / « Email ».
**Bloc téléphone :** champ « NUMÉRO DE TÉLÉPHONE » préfixe `+225`, placeholder `07 00 00 00 00` ; champ OTP 4 chiffres avec libellé « CODE OTP (SMS) » ; texte « Code envoyé au +225 07 •• •• •• 00 · » + lien « Renvoyer ».
**Bloc email :** champ « ADRESSE EMAIL » placeholder `aya@exemple.ci` ; note « Un lien de confirmation vous sera envoyé à cette adresse après l'inscription. » ; champ « MOT DE PASSE » placeholder `••••••••`.
**Bouton :** « Vérifier et continuer → ».
**Bas de page :** « Déjà inscrit ? » + lien « Se connecter ».
**Navigation :** logo/retour → `splash` ; validation → `infos_perso` ; « Se connecter » → `connexion`.
**Fonction associée :** `setInscMethod(this)` (bascule Téléphone/Email), `submitInscription()`.

### 5.3 `infos_perso` — Dernière étape d'inscription
**Texte exact :** « Dernière étape » (eyebrow) · « Vos informations » (titre) · « Dites-nous qui vous êtes et où vous vous trouvez. »
**Champs :** « PRÉNOM » (placeholder `Aya`), « NOM » (placeholder `Konan`), « LOCALISATION » avec état « Position non détectée » + note « Utilisé pour vous localiser les points de collecte proches » + bouton « Localiser ».
**Case à cocher :** « J'accepte les **CGU et la politique de confidentialité** d'EcoTrack. » (le lien CGU est cliquable).
**Bouton :** « Terminer l'inscription ».
**Navigation :** retour → `inscription` ; lien CGU → `cgu`.
**Fonction associée :** `detectLocation('inscLocText','inscLocSub','inscLocBox')`.

### 5.4 `connexion` — Connexion
**Texte exact :** « Connexion » (eyebrow) · « Bon retour parmi nous » (titre) · champ « TÉLÉPHONE OU EMAIL » (placeholder `aya@exemple.ci`) · champ « MOT DE PASSE » (placeholder `••••••••`) · lien « Mot de passe oublié ? » · bouton « Se connecter → » · « Pas de compte ? » + lien « S'inscrire ».
**Navigation :** retour → `splash` ; mot de passe oublié → `mdp_oublie` ; connexion réussie → `accueil_menage` ; S'inscrire → `inscription`.

### 5.5 `mdp_oublie` — Mot de passe oublié
**Texte exact :** « Mot de passe oublié » (eyebrow) · « Réinitialiser votre mot de passe » (titre) · « Indiquez le numéro ou l'email associé à votre compte. Nous vous enverrons un code de vérification. » · champ « TÉLÉPHONE OU EMAIL » (placeholder `07 00 00 00 00 ou aya@exemple.ci`) · bouton « Envoyer le code » · « Vous vous souvenez ? » + lien « Se connecter ».
**Navigation :** retour → `connexion` ; envoyer le code → `mdp_reset` (toast « Code envoyé ») ; « Se connecter » → `connexion`.

### 5.6 `mdp_reset` — Vérification et nouveau mot de passe
**Texte exact :** « Vérification » (eyebrow) · « Nouveau mot de passe » (titre) · champ OTP 7 chiffres « CODE DE VÉRIFICATION » · « Code envoyé · » + lien « Renvoyer » (toast « Nouveau code envoyé ») · champ « NOUVEAU MOT DE PASSE » · champ « CONFIRMER LE MOT DE PASSE » · bouton « Réinitialiser le mot de passe ».
**Navigation :** retour → `mdp_oublie` ; validation → `mdp_confirmation`.

### 5.7 `mdp_confirmation` — Confirmation
**Texte exact :** « Mot de passe mis à jour » · « Vous pouvez maintenant vous connecter avec votre nouveau mot de passe. » · bouton « Retour à la connexion ».
**Navigation :** → `connexion`.

### 5.8 `onboarding` — Sélection du profil
**Texte exact :** « Créer un compte » (eyebrow) · « Je rejoins EcoTrack en tant que… » (titre) · « Choisissez votre profil. Vous pourrez en ajouter d'autres plus tard. »
**4 cartes de sélection :**
1. « Ménage / Commerce » — « Je trie, signale, gagne des points »
2. « Collecteur informel » — « Charrette, moto ou à pied »
3. « Filière de valorisation » — « Recycleur, compost, biogaz, e-waste »
4. « Mairie / Collectivité » — « Dashboard B2G · pilotage territorial »
**Navigation :** retour → `inscription` ; Ménage → `tutoriel` ; Collecteur → `accueil_collecteur` ; Filière → `accueil_filiere` ; Mairie → `dashboard_mairie`.

### 5.9 `accueil_menage` — Accueil profil Ménage/Commerce
**En-tête :** logo « EcoTrack » · bouton bascule thème · icône notifications (badge rouge) → `notifications` · icône profil → `profil`.
**Texte exact :** « Bonjour, » / « Aya · Cocody ».
**Bloc scanner (carte principale) :** eyebrow « SCANNER IA » · « Trier un déchet » · icône caméra animée → `scanner`.
**Bouton signalement :** « Signaler un dépôt sauvage » / « Photo + localisation » → `signalement`.
**Badge :** « 🔥 7 jours d'affilée ».
**3 statistiques (cartes) :** « 1 240 / points » · « 38 kg / triés / mois » (cliquable → `historique`) · « 6 / collectes ».
**Bloc « Passage du collecteur » :** lien « Carte → » (→ `carte`) · carte « Aujourd'hui · 16h–17h » / « Ibrahim K. · notation 4.8 ★ » · bouton « Noter » → `notation_collecteur` · pastille "live" animée.
**Bloc « Récompenses » (carrousel horizontal) :** « 400 PTS — Recharge mobile » · « 900 PTS — Kit scolaire » · « 1 500 PTS — Bon d'achat CDCI » (fonction `redeemReward(nom, points)`).
**Barre de navigation basse :** Accueil (actif) · Carte → `carte` · Signaler → `signalement` · Profil → `profil`.

### 5.10 `scanner` — Scanner de déchet (caméra)
**Texte exact :** badge « LIVE » · guide de cadrage « CADRAGE · FORME · MATIÈRE » · 4 catégories suggérées à l'écran : « Plastique », « Organique », « Métal/verre », « Dangereux » · lien « Problème avec la caméra ? ».
**Navigation :** retour → `accueil_menage` ; icône micro/assistant → `assistant_vocal` ; déclenchement capture → `analyse` ; icône carte → `carte` ; problème caméra → `erreur_camera`.
**Fonction associée :** `openGallery()` (import depuis galerie en alternative à la caméra).

### 5.11 `analyse` — Classification en cours
**Texte exact :** « CLASSIFICATION EN COURS » · « L'IA identifie le déchet » · « Modèle MobileNetV3 · on-device ».
**Comportement :** écran de chargement temporaire (2-3 secondes simulées) puis navigation automatique → `resultat`.

### 5.12 `resultat` — Résultat de la classification IA
**Texte exact :** « 91% / CONFIANCE IA » (score dynamique) · « ORGANIQUE · COMPOSTABLE » (catégorie détectée) · « Épluchures & résidus alimentaires » (sous-détail) · « FILIÈRE DE VALORISATION RECOMMANDÉE » → « Unité de compost · Yopougon » / « 1,8 km · dépôt sous 24h recommandé » · « POINT DE DÉPÔT LE PLUS PROCHE » → « Bac communautaire — Rue 12 » / « Remplissage capteur IoT : 42% » · « + 25 points gagnés » · « Impact cumulé : 38 kg valorisés ce mois-ci ».
**Boutons :** « Signaler un dépôt » → `signalement` ; « Terminer » → `accueil_menage` ; lien « Classification incorrecte ? Aider à corriger » → `vote_communautaire`.
**Navigation additionnelle :** → `carte`.

### 5.13 `signalement` — Signalement citoyen d'un dépôt sauvage
**Texte exact :** « Signalement citoyen » (eyebrow) · « Un dépôt sauvage ? » (titre) · bouton/zone « Ajouter une photo » · champ « LOCALISATION » avec état « Position GPS détectée · Marcory » · champ « DESCRIPTION » (texte libre) · bouton « Envoyer le signalement ».
**Fonction associée :** `togglePhoto(this)`.
**Navigation :** retour → `accueil_menage` ; icône assistant vocal → `assistant_vocal` ; envoi → `signalement_doublon` (si doublon détecté) ou `confirmation_signalement`.

### 5.14 `confirmation_signalement` — Confirmation de signalement
**Texte exact :** « Signalement transmis » · « La mairie de votre commune a été notifiée. Un agent évaluera l'urgence sous 48h. » · bouton « Suivre mon signalement » → `suivi_signalement` ; bouton « Retour à l'accueil » → `accueil_menage`.

### 5.15 `carte` — Carte des points de collecte
**En-tête :** logo « EcoTrack » · titre « Carte des points de collecte » · badge « 12 actifs ».
**Filtres (chips) :** « Tous » / « Plastique » / « Organique » / « Verre/Métal » / « Signalements » (fonction `setFilter(this)`).
**Contrôles carte :** zoom `+` / `−` (fonction `zoomMap(delta)`), recentrage (`recenterMap()`), champ de recherche « Rechercher un quartier… » (`filterMapSearch`).
**Bouton flottant :** « Signaler ici » → `signalement`.
**3 compteurs :** « 12 / points actifs » · « 3 / à surveiller » · « 2 / signalements ».
**Légende (niveau de remplissage capteur IoT) :** Bac libre/faible remplissage · Remplissage moyen — à surveiller · Dépôt sauvage signalé · Point de collecte plastique · Point verre/métal.
**Liste « Points à proximité » (triée par distance) :**
- Bac communautaire — Rue 12 · 0,9 km · 42% plein
- Point plastique — Cité SOGEFIHA · 1,4 km · 63% plein
- Dépôt sauvage — arrière du marché · 1,1 km · signalé hier
- Marché de Koumassi · 2,3 km · 91% plein
**Panneau détail au clic sur un pin (`openPoint(this)`) :** CATÉGORIE / distance / remplissage IoT (valeurs dynamiques) · bouton « Fermer » (`closePoint()`) · bouton « Voir la fiche » → `fiche_point`.
**Navigation :** retour → `accueil_menage`.

### 5.16 `accueil_collecteur` — Accueil profil Collecteur informel
**Texte exact :** « Espace Collecteur » · « Ibrahim K. » · « ★ 4.8 · 214 collectes · Koumassi ».
**Bloc itinéraire :** « ITINÉRAIRE OPTIMISÉ · IA » · « 7 arrêts » · liste des 3 premiers arrêts :
1. Rue 12, Marcory — Plastique · 78% plein
2. Marché Koumassi — Organique · 91% plein
3. Cité SOGEFIHA — Mixte · 54% plein
Bouton « Démarrer la tournée ».
**2 statistiques :** « 36 500 / FCFA · cette semaine » · « 312 kg / collectés · semaine ».
**Bloc « FORMATIONS COURTES » :** « Tri & sécurité · 6 min · vidéo » et « Hygiène terrain · 4 min · vidéo » (fonction `playTraining(nom)`).
**Navigation :** retour → `onboarding` ; icône profil → `profil` ; « Carte » → `carte` ; solde/retrait → `retrait_collecteur`.

### 5.17 `accueil_filiere` — Accueil profil Filière de valorisation
**Texte exact :** « Filière de valorisation » (eyebrow) · « Unité de compost — Yopougon » · « Coopérative EcoTerre CI ».
**Bloc « VOLUMES DISPONIBLES PAR ZONE » :**
- Marcory — 1,2 t disponible
- Koumassi — 870 kg disponible
- Cocody — 2,4 t disponible
**Bloc prévision :** « PRÉVISION IA · 7 PROCHAINS JOURS » · « Pic attendu jeudi (jour de marché) · Random Forest ».
**Boutons :** « Réserver un lot » (`reserverLot()`) ; « Voir la marketplace des produits recyclés » → `marketplace`.
**Navigation :** retour → `onboarding`.

### 5.18 `dashboard_mairie` — Dashboard B2G Mairie/Collectivité
**Texte exact :** « Dashboard B2G » (eyebrow) · « Commune de Koumassi » · « Rapport d'impact · juillet 2026 ».
**4 indicateurs clés :** « 63% / taux de collecte » · « 14,2 t / valorisées / mois » · « 9 / dépôts sauvages actifs » · « 47 / emplois soutenus ».
**Bloc « ZONES À RISQUE DE DÉPÔT SAUVAGE » :** sous-titre « Imagerie Sentinel-2 · caméras terrain ».
**Bloc « STATISTIQUES PAR QUARTIER » :** Marcory, Koumassi, Treichville (données comparatives).
**Boutons :** « Voir les crédits carbone générés » → `impact_carbone` ; « Générer le rapport PDF » (`genererRapport()`).
**Navigation :** retour → `onboarding` ; → `carte`.

### 5.19 `profil` — Profil utilisateur
**Texte exact :** badge « 🌿 Éco-héros · Niv 4 » · « Aya Konan » · « Ménage · Cocody · membre depuis mars 2026 ».
**3 statistiques :** « 1 240 / points » · « 184 kg / valorisés » · « 4 / mois actifs ».
**Section « HISTORIQUE & COMPTE » :** « Historique de tri » → `historique` ; « Paramètres » → `parametres` ; « Aide & FAQ » → `aide`.
**Section « MES PROFILS » (multi-rôles) :** « Ménage / Commerce » (badge ACTIF) → `accueil_menage` ; « Collecteur informel » → `accueil_collecteur` ; « Mairie / Collectivité » → `dashboard_mairie`.
**Bloc :** « Mon impact carbone » / « Voir mes crédits CO₂ générés » → `impact_carbone`.
**Bouton :** « Se déconnecter » → `connexion`.

### 5.20 `notifications` — Centre de notifications
**Texte exact :** « Notifications » · lien « Tout marquer lu » (`markAllRead()`).
**Liste (3 exemples) :**
- « Le collecteur Ibrahim arrive dans 15 min » — Il y a 2 min
- « +25 points crédités — tri organique » — Aujourd'hui, 09:14
- « Votre signalement a été traité » — Hier, 17:40 (→ `suivi_signalement`)
**Navigation :** retour → `accueil_menage`.

### 5.21 `marketplace` — Marketplace des produits recyclés
**Texte exact :** « Marketplace EcoTrack » · compteur panier « 0 » (icône panier → `panier`) · « Produits issus des filières de valorisation locales — le cycle bouclé, du déchet au produit fini. »
**Filtres (chips) :** « Tous » / « Compost » / « Construction » / « Mobilier » (`setMpFilter(this)`).
**4 produits (catalogue exact) :**
1. Pavés recyclés (lot de 10) — EcoTerre CI · plastique valorisé — **7 500 FCFA** — bouton « Commander »
2. Compost bio — sac 25 kg — Unité de compost Yopougon — **3 000 FCFA** — bouton « Commander »
3. Mobilier scolaire (table-banc) — Coopérative Treichville · plastique + bois — **28 000 FCFA** — bouton « Commander »
4. Briquettes combustibles (5 kg) — Résidus organiques compactés — **1 500 FCFA** — bouton « Commander »
**Fonction associée :** `orderProduct(nom, prix)`.
**Navigation :** retour → `accueil_filiere` ; panier → `panier`.

### 5.22 `impact_carbone` — Monétisation carbone
**Texte exact :** « Monétisation carbone » (eyebrow) · « Impact carbone généré » · badge « ✓ CERTIFIÉ » · « 2,4 t / CO₂e évitées depuis mars 2026 ».
**Équivalences :** « 🌳 ≈ 110 arbres plantés sur un an » · « 🚗 ≈ 9 800 km évités en voiture ».
**Bloc :** « GÉNÉRATION MENSUELLE » — période « Mars → Juillet 2026 » (graphique d'évolution).
**Texte institutionnel :** « Pour les partenaires institutionnels » — « Ces crédits carbone certifiés peuvent être valorisés auprès de bailleurs (AFD, PNUD) ou d'entreprises en compensation volontaire. »
**Bouton :** « Exporter le certificat » (`exporterCertificat()`).
**Navigation :** retour → `profil`.

### 5.23 `assistant_vocal` — Assistant vocal
**Texte exact :** « ASSISTANT VOCAL EcoTrack » · bulle exemple « Il y a des ordures dans la rue derrière le marché » · instruction « Je vous écoute… décrivez le déchet ou le dépôt en langue locale ou en français » · lien « Repasser en mode texte ».
**Navigation :** retour → `accueil_menage` ; validation → `signalement`.
**Note technique :** l'interface prévoit explicitement un usage en langue locale ou en français — prévoir un composant de reconnaissance vocale multilingue (mock acceptable pour le prototype : simuler une transcription).

### 5.24 `historique` — Historique de tri
**Texte exact :** « Historique de tri » · 3 statistiques : « 38 kg / ce mois » · « 14 / scans » · « 350 / points gagnés ».
**Liste « TOUS LES SCANS » (5 entrées exactes) :**
- Organique · +25 pts — Aujourd'hui, 09:14 · 2,1 kg
- Plastique · +30 pts — Hier, 18:02 · 1,4 kg
- Verre / métal · +20 pts — Lundi, 12:47 · 3,0 kg
- Organique · +25 pts — Dimanche, 08:30 · 1,9 kg
- Dangereux (pile) · +40 pts — Samedi, 16:12 · 0,2 kg
**Navigation :** retour → `accueil_menage`.

### 5.25 `suivi_signalement` — Suivi d'un signalement
**Texte exact :** « Suivi du signalement » · « Dépôt sauvage — Rue 12 » · « Signalé le 8 juillet 2026 à 17:40 ».
**Timeline (3 étapes) :**
1. « Signalement envoyé » — 08/07 · 17:40
2. « Pris en charge par la mairie de Koumassi » — 09/07 · 08:12 · Agent : K. Yao
3. « Intervention planifiée » — Prévue le 11/07 · équipe de collecte
**Détail :** « Photo jointe · voie ferrée, Koumassi ».
**Navigation :** retour → `accueil_menage`.

### 5.26 `notation_collecteur` — Évaluation du collecteur
**Texte exact :** « Noter Ibrahim K. » · « Passage du 9 juillet · 16h20 » · 5 étoiles cliquables (`setRating(1..5)`) · bouton « Envoyer la note ».
**Navigation :** retour/validation → `accueil_menage` (toast « Merci pour votre évaluation ! »).

### 5.27 `verification_email` — Vérification email
**Texte exact :** « Vérifiez votre boîte mail » · « Un lien de confirmation a été envoyé à votre adresse email. Cliquez dessus pour activer votre compte. » · bouton « J'ai confirmé, continuer » · « Pas reçu ? » + lien « Renvoyer le lien ».
**Navigation :** → `onboarding` (toast « Email confirmé »).

### 5.28 `tutoriel` — Tutoriel de bienvenue (profil Ménage)
**Texte exact :** « Bienvenue » (eyebrow) · « Comment ça marche ? » (titre).
**3 étapes :**
1. « Scannez votre déchet » — « L'IA identifie la catégorie en quelques secondes. »
2. « Suivez la recommandation » — « Filière de valorisation et point de dépôt le plus proche. »
3. « Déposez et gagnez des points » — « Échangez vos points contre des récompenses locales. »
**Boutons :** « Commencer » et « Passer », tous deux → `accueil_menage`.

### 5.29 `vote_communautaire` — Vote communautaire (correction IA)
**Texte exact :** badge « Confiance IA faible · 54% » · « Aidez-nous à trancher » · « L'IA hésite entre deux catégories. Votre vote aide la communauté à confirmer. »
**2 options de vote :** « Plastique — 54% » / « Métal / verre — 46% » (`voteCategory(this, categorie)`).
**Confirmation :** « Merci ! Votre vote a été enregistré. » · bouton « Retour au résultat » → `resultat`.

### 5.30 `retrait_collecteur` — Retrait des revenus du collecteur
**Texte exact :** « Retrait de revenus » · « Solde disponible » · « 36 500 FCFA » · « Cumul de la semaine ».
**Moyens de retrait (sélecteur) :** « Orange Money » / « MTN Mobile Money » / « Wave » (`setPayOpt(this)`).
**Champ :** « MONTANT À RETIRER » (pré-rempli `36 500`).
**Bouton :** « Retirer maintenant » → `accueil_collecteur` (toast « Retrait initié — vous recevrez un SMS de confirmation »).

### 5.31 `panier` — Panier marketplace
**Texte exact :** « Mon panier » · « Total » · « 0 FCFA » (dynamique selon contenu) · bouton « Passer au paiement ».
**Fonctions associées :** `removeFromCart(i)`, `renderCart()`, `clearCart()`.
**Navigation :** retour → `marketplace` ; validation → `paiement_commande`.

### 5.32 `paiement_commande` — Paiement de commande marketplace
**Texte exact :** « Paiement » (eyebrow) · « Choisir un mode de paiement » · options « Mobile Money » / « Espèces à la livraison » (`setPayOpt2(this)`) · bouton « Confirmer la commande ».
**Navigation :** retour → `panier` ; validation → `confirmation_commande`.

### 5.33 `confirmation_commande` — Confirmation de commande
**Texte exact :** « Commande confirmée » · « Vous recevrez un SMS avec les détails de livraison ou de retrait. » · bouton « Retour à la marketplace » → `marketplace` (via `clearCart()`).

### 5.34 `langue` — Choix de la langue
**Texte exact :** « Langue » (eyebrow) · « Choisir la langue » · 5 options : « Français », « English », « Dioula », « Baoulé », « Nouchi » (`setLang(this)`).
**Navigation :** retour → `parametres`.
**Note :** confirme la nécessité prévue d'une interface multilingue incluant les langues locales.

### 5.35 `parametres` — Paramètres
**Texte exact :** « Paramètres » · section « INFORMATIONS PERSONNELLES » · section « PRÉFÉRENCES » : « Langue → Français ›» (→ `langue`), « Notifications push » (toggle, `toggleSwitch(this)`), « Mode hors-ligne » (toggle, `toggleOfflineSwitch(this)`) · section « SUPPORT » : « Aide & FAQ ›» (→ `aide`), « CGU & confidentialité ›» (→ `cgu`) · bouton « Enregistrer » (toast « Paramètres enregistrés »).
**Navigation :** retour → `profil`.

### 5.36 `aide` — Aide et FAQ
**Texte exact :** « Aide & FAQ » · section « QUESTIONS FRÉQUENTES » avec 3 questions/réponses exactes :
1. « L'IA se trompe sur mon déchet, que faire ? » → « Utilisez le vote communautaire proposé après le scan pour aider à corriger la classification. »
2. « Comment échanger mes points ? » → « Rendez-vous dans l'accueil, section "Récompenses", et sélectionnez une offre disponible. »
3. « L'application fonctionne-t-elle sans réseau ? » → « Oui : activez le mode hors-ligne dans les paramètres. Vos actions se synchroniseront dès que le réseau revient. »
**Bloc « CONTACTER LE SUPPORT » :** champ libre + bouton « Envoyer » (toast « Message envoyé au support EcoTrack »).
**Navigation :** retour → `profil`.

### 5.37 `cgu` — Conditions générales et confidentialité
**Texte exact (4 sections) :**
1. « Données collectées. » — « EcoTrack collecte votre nom, numéro, localisation approximative et vos historiques de tri afin d'améliorer la collecte et la valorisation des déchets. »
2. « Usage des photos. » — « Les photos de déchets et de signalements sont utilisées pour entraîner le modèle de classification IA et ne sont jamais revendues. »
3. « Partage institutionnel. » — « Des données agrégées et anonymisées peuvent être partagées avec les mairies et partenaires (AFD, PNUD). »
4. « Vos droits. » — « Vous pouvez à tout moment demander l'export ou la suppression de vos données depuis Paramètres → Aide & FAQ. »
**Navigation :** retour → `inscription`.

### 5.38 `erreur_camera` — Erreur d'accès caméra
**Texte exact :** « Accès à la caméra refusé » · « EcoTrack a besoin de la caméra pour scanner vos déchets. Autorisez l'accès dans les réglages de votre téléphone. » · bouton « Réessayer » → `scanner` ; bouton « Utiliser une photo de la galerie » (`openGallery()`).

### 5.39 `erreur_reseau` — Erreur de connexion
**Texte exact :** « Pas de connexion » · « Impossible de joindre le serveur. Activez le mode hors-ligne pour continuer à trier — vos actions se synchroniseront plus tard. » · bouton « Réessayer » ; bouton « Continuer hors-ligne » (`toggleOffline()`) → `accueil_menage`.

### 5.40 `signalement_doublon` — Détection de doublon de signalement
**Texte exact :** « Un signalement existe déjà ici » · « Un dépôt sauvage a été signalé à moins de 50 m de cette position, il y a 3 heures, par un autre usager. » · « Voie ferrée, Koumassi » · « Statut : pris en charge par la mairie » · bouton « Voir ce signalement » → `suivi_signalement` ; bouton « Signaler quand même » → `confirmation_signalement`.

### 5.41 `fiche_point` — Fiche détaillée d'un point de collecte
**Texte exact :** « POINT DE COLLECTE · ORGANIQUE » (catégorie dynamique) · « Bac communautaire — Rue 12 » · « 42% / remplissage IoT » · « 6h – 19h / horaires d'accès ».
**Bloc « DÉCHETS ACCEPTÉS » :** « Épluchures », « Résidus de marché », explicitement exclu : « ✕ Plastique ».
**Bloc « GESTIONNAIRE » :** « Mairie de Koumassi » / « Service de propreté urbaine ».
**Boutons :** « Signaler un problème » → `signalement` ; « Itinéraire » (toast « Itinéraire ouvert »).
**Navigation :** retour → `carte`.

---

## 6. Interactions et fonctions transverses (à implémenter comme services/providers)

| Fonction JS source | Équivalent Flutter à implémenter |
|---|---|
| `go(nomEcran)` | Navigation `go_router` vers la route correspondante |
| `toggleTheme()` | Bascule `ThemeMode.light`/`ThemeMode.dark` via provider |
| `setLang(this)` | Sélection de langue active, persistée (`shared_preferences`) |
| `setFilter(this)` / `setMpFilter(this)` | Filtres de catégories sur la carte / la marketplace (state local) |
| `setPayOpt(this)` / `setPayOpt2(this)` | Sélection du moyen de paiement actif |
| `setInscMethod(this)` | Bascule méthode d'inscription (téléphone/email) |
| `toggleSwitch(this)` / `toggleOfflineSwitch(this)` | Switches de paramètres (notifications, hors-ligne) |
| `toggleOffline()` | Active le mode hors-ligne global (bannière + file d'attente de synchronisation) |
| `togglePhoto(this)` | Affiche/masque l'aperçu photo dans le formulaire de signalement |
| `openGallery()` | Sélecteur d'image (package `image_picker`) |
| `openPoint(this)` / `closePoint()` | Ouverture/fermeture du panneau de détail sur la carte |
| `recenterMap()` / `zoomMap(delta)` / `filterMapSearch()` | Contrôles de la carte (`flutter_map`) |
| `setRating(n)` | Sélection d'une note 1 à 5 étoiles |
| `voteCategory(this, categorie)` | Enregistrement du vote communautaire |
| `redeemReward(nom, points)` | Échange de points contre une récompense (décrémente le solde de points) |
| `orderProduct(nom, prix)` / `removeFromCart(i)` / `renderCart()` / `clearCart()` | Gestion du panier marketplace (provider `CartNotifier`) |
| `reserverLot()` | Réservation d'un lot de déchets par une filière |
| `genererRapport()` / `exporterCertificat()` | Génération de documents PDF (mock acceptable pour le prototype) |
| `playTraining(nom)` | Lecture d'une vidéo de formation courte |
| `markAllRead()` | Marque toutes les notifications comme lues |
| `showToast(message)` | Affichage d'un `SnackBar`/toast, à reproduire à chaque point listé dans le catalogue d'écrans (section 5) |
| `detectLocation(...)` | Récupération de la position GPS réelle (package `geolocator`) |

---

## 7. Modèles de données Dart à créer

```dart
enum UserRole { menage, collecteur, filiere, mairie }

class AppUser {
  final String id;
  final String prenom;
  final String nom;
  final String localisation; // ex. "Cocody"
  final UserRole roleActif;
  final List<UserRole> rolesDisponibles;
  final int points;
  final double kgValorises;
  final int moisActifs;
}

enum WasteCategory { plastique, organique, metalVerre, dangereux, eWaste, carton }

class WasteScanResult {
  final WasteCategory categorie;
  final double confianceIA; // ex. 0.91
  final String sousDetail;  // ex. "Épluchures & résidus alimentaires"
  final String filiereRecommandee;
  final double distanceFiliereKm;
  final CollectPoint pointDepotProche;
  final int pointsGagnes;
}

class CollectPoint {
  final String nom;           // "Bac communautaire — Rue 12"
  final WasteCategory categorie;
  final double distanceKm;
  final int remplissageIoTPct; // 0-100
  final String horaires;
  final List<String> dechetsAcceptes;
  final List<String> dechetsExclus;
  final String gestionnaire;
}

class Signalement {
  final String id;
  final String localisation;
  final String description;
  final String photoUrl;
  final DateTime dateEnvoi;
  final List<SignalementEtape> timeline;
}

class SignalementEtape {
  final String titre;      // "Pris en charge par la mairie de Koumassi"
  final DateTime date;
  final String? agent;
}

class Collecteur {
  final String nom;         // "Ibrahim K."
  final double notation;    // 4.8
  final int nombreCollectes;
  final String zone;
  final double soldeFCFA;
  final double kgCollectesSemaine;
}

class ItineraireArret {
  final int ordre;
  final String lieu;
  final WasteCategory categorie;
  final int remplissagePct;
}

class ProduitMarketplace {
  final String nom;
  final String fournisseur;
  final int prixFCFA;
  final String categorie; // Compost / Construction / Mobilier
}

class ImpactCarbone {
  final double tonnesCO2eEvitees;
  final int equivalentArbres;
  final int equivalentKmVoiture;
  final bool certifie;
}

class DashboardMairie {
  final String commune;
  final double tauxCollectePct;
  final double tonnesValoriseesMois;
  final int depotsSauvagesActifs;
  final int emploisSoutenus;
}
```

---

## 8. Données fictives (mock) à utiliser telles quelles pour le prototype

Reprendre **exactement** les valeurs suivantes (déjà extraites de la maquette) pour que la démonstration soit cohérente :

- **Utilisatrice ménage démo :** Aya Konan, Cocody, membre depuis mars 2026, 1 240 points, 184 kg valorisés, 4 mois actifs, badge "Éco-héros · Niv 4".
- **Collecteur démo :** Ibrahim K., Koumassi, ★4.8, 214 collectes, solde 36 500 FCFA/semaine, 312 kg collectés/semaine.
- **Récompenses :** Recharge mobile (400 pts), Kit scolaire (900 pts), Bon d'achat CDCI (1 500 pts).
- **Produits marketplace :** cf. section 5.21 (4 produits, prix exacts en FCFA).
- **Points de collecte carte :** cf. section 5.15 (4 points, distances et remplissages exacts).
- **Impact carbone :** 2,4 t CO₂e évitées depuis mars 2026, ≈110 arbres, ≈9 800 km voiture.
- **Dashboard mairie (Koumassi) :** 63% taux de collecte, 14,2 t valorisées/mois, 9 dépôts sauvages actifs, 47 emplois soutenus.
- **Historique de tri (5 entrées) :** cf. section 5.24, valeurs exactes en kg et points.

---

## 9. Points de vigilance pour l'agent IA

1. **Catégories de déchets actuellement limitées à l'urbain** (plastique, organique, métal/verre, dangereux, e-waste) — la maquette ne couvre pas encore les catégories agricoles (cabosses de cacao, coques d'anacarde). Prévoir l'architecture des catégories comme une liste extensible (voir modèle `WasteCategory`), mais **ne pas ajouter ces catégories rurales dans l'interface tant qu'elles ne sont pas explicitement demandées**.
2. **Le module IA de classification et les capteurs IoT sont simulés** dans ce prototype (valeurs mock), conformément à la maquette — ne pas tenter d'intégrer un vrai modèle de vision ni de vrais capteurs à ce stade.
3. **Mode hors-ligne et mode sombre sont des exigences fonctionnelles explicites** de la maquette, pas des options secondaires — à implémenter dès la première version.
4. **Respecter la structure multi-rôle unique** : un même compte utilisateur peut basculer entre plusieurs profils (section `profil` → « MES PROFILS ») ; ne pas créer 4 applications séparées.
5. **Chaque toast/message de confirmation listé en section 5 doit apparaître** au moment précis indiqué — ce sont des retours utilisateur explicitement conçus dans la maquette, pas des détails facultatifs.

---

**Fin du cahier des charges. Ce document couvre l'intégralité des 41 écrans de la maquette `EcoTrack_Maquette_Interactive.html`, leur contenu exact, leur navigation et leurs interactions.**
