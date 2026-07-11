# TRIA CI - Intelligence Artificielle pour la Gestion des Déchets

## 📋 Vue d'ensemble

TRIA CI est un système d'IA complèt pour la gestion des déchets à Abidjan, intégrant 6 modules intelligents conformes au cahier des charges du projet EcoTrack.

## 🏗️ Architecture du Projet

```
TRIA_CI/
├── 📄 main.py                 # Lanceur central
├── 📄 requirements.txt         # Dépendances Python
│
├── 📁 src/                    # Code source principal
│   ├── __init__.py
│   ├── config.py              # Configuration centralisée
│   └── utils.py               # Fonctions utilitaires
│
├── 📁 modules_ia/             # 6 Modules d'IA
│   ├── __init__.py
│   ├── module_6_1_classification.py        # Classification des déchets
│   ├── module_6_2_dump_detection.py        # Détection dépôts sauvages
│   ├── module_6_3_volume_prediction.py     # Prédiction de volumes
│   ├── module_6_4_route_optimization.py    # Optimisation tournées (VRP)
│   ├── module_6_5_collector_scoring.py     # Scoring collecteurs
│   └── module_6_6_community_voting.py      # Vote communautaire
│
├── 📁 scripts/                # Scripts d'exécution
│   ├── train.py              # Entraîner le modèle
│   ├── evaluate.py           # Évaluer le modèle
│   ├── predict.py            # Prédire sur une image
│   ├── convert.py            # Convertir en TFLite
│   └── demo.py               # Démonstration complète
│
├── 📁 data/                   # Données et résultats
│   ├── dataset/              # Images d'entraînement (6 catégories)
│   │   ├── cardboard/
│   │   ├── glass/
│   │   ├── metal/
│   │   ├── paper/
│   │   ├── plastic/
│   │   └── trash/
│   ├── test/                 # Images de test
│   ├── history.png           # Courbes d'entraînement
│   └── confusion_matrix.png  # Matrice de confusion
│
├── 📁 models/                # Modèles entraînés
│   ├── best_model.keras      # Meilleur modèle Keras
│   ├── final_model.keras     # Modèle final
│   └── best_model.tflite     # Modèle mobile
│
├── 📁 docs/                  # Documentation
└── 📁 .venv/                 # Environnement virtuel Python
```

## 🚀 Démarrage Rapide

### 1️⃣ Installation des dépendances

```bash
# Créer l'environnement virtuel
python -m venv .venv

# Activer l'environnement
.\.venv\Scripts\Activate.ps1  # Windows PowerShell
source .venv/bin/activate      # Linux/Mac

# Installer les packages
pip install -r requirements.txt
```

### 2️⃣ Utiliser le lanceur central

```bash
# Afficher l'aide
python main.py

# Entraîner le modèle
python main.py train

# Évaluer le modèle
python main.py evaluate

# Prédire sur une image
python main.py predict --image data/test/photo.jpg

# Convertir en TensorFlow Lite (mobile)
python main.py convert

# Démonstration des 6 modules
python main.py demo
```

## 📦 Les 6 Modules IA

### 🔍 Module 6.1 - Classification Automatique

**Fichier:** `modules_ia/module_6_1_classification.py`

- Identifie automatiquement le type de déchet
- Modèle: MobileNetV3Small (transfer learning + fine-tuning)
- Input: Image 224×224 RGB
- Output: Classe + confiance (6 catégories)
- Déploiement: TensorFlow Lite pour mobile

### 🚨 Module 6.2 - Détection de Dépôts Sauvages

**Fichier:** `modules_ia/module_6_2_dump_detection.py`

- Détecte les décharges illégales via satellite/caméra
- Utilise comparaison temporelle d'images
- Génère des alertes géolocalisées
- Niveaux d'urgence (1-4)

### 📊 Module 6.3 - Prédiction de Volumes

**Fichier:** `modules_ia/module_6_3_volume_prediction.py`

- Prédit les volumes de déchets par district
- Horizon: 7 jours (planning collecte)
- Modèle: Random Forest Regressor
- Features: jour, météo, densité pop, activité commerciale

### 🗺️ Module 6.4 - Optimisation des Tournées

**Fichier:** `modules_ia/module_6_4_route_optimization.py`

- Résout le problème VRP (Vehicle Routing Problem)
- Support multi-collecteurs (piéton, charrette, moto, camion)
- Heuristique: Nearest Neighbor pour rapidité
- Output: Routes optimisées, distance, temps

### ⭐ Module 6.5 - Scoring des Collecteurs

**Fichier:** `modules_ia/module_6_5_collector_scoring.py`

- Évalue la fiabilité des collecteurs (0-100)
- Scoring pondéré: précision (40%), ponctualité (35%), fiabilité (25%)
- Recommande les filières de valorisation appropriées
- Historique des transactions complètement tracé

### 🗳️ Module 6.6 - Vote Communautaire

**Fichier:** `modules_ia/module_6_6_community_voting.py`

- Crowdsource la classification quand confiance IA < 70%
- Consensus: 70% des votes ou min 3 votes
- Buffer de ré-entraînement continu
- Taux de correction suivable

## 🔧 Configuration

Tous les paramètres se trouvent dans `src/config.py`:

```python
# Images
IMAGE_SIZE = (224, 224)
BATCH_SIZE = 32

# Entraînement
INITIAL_EPOCHS = 20
FINE_TUNE_EPOCHS = 30

# Chemins
DATASET_DIR = data/dataset
MODELS_DIR = models
```

## 📊 Workflow Complet

```
1. Charger images → 2. Entraîner (Phase 1 + 2)
        ↓
3. Évaluer → 4. Convertir en TFLite
        ↓
5. Déployer en production
        ↓
6. Intégrer tous les 6 modules
```

## 📈 Performance du Modèle

- **Architecture**: MobileNetV3Small + GlobalAvgPooling + Dense
- **Augmentation**: Flip, Rotation, Zoom, Translation, Contrast
- **Phase 1**: 20 epochs (transfer learning, LR=1e-3)
- **Phase 2**: 30 epochs (fine-tuning, LR=1e-5)
- **Callbacks**: Early Stopping, ModelCheckpoint, ReduceLROnPlateau

## 🔄 Workflow Démonstration

```bash
python main.py demo
```

Montre:

- Classification d'une image
- Détection de dépôts sauvages
- Prédiction de volumes pour 3 districts
- Optimisation multi-collecteurs
- Scoring d'un collecteur
- Processus de vote communautaire

## 📚 Dépendances Principales

- **tensorflow** 2.21.0 - Deep Learning
- **numpy** - Calcul numérique
- **pillow** - Traitement images
- **scikit-learn** - ML classique
- **matplotlib** - Visualisation

## 🛠️ Structure des Modules

Chaque module IA suit la même structure:

```python
class ModuleXXX:
    def __init__(self):
        # Initialisation
        pass

    def load_model(self, path):
        # Charger un modèle
        pass

    def process(self, input_data):
        # Traiter les données
        pass
```

## 📝 Fichiers de Configuration

- `src/config.py` - Constantes du projet
- `src/utils.py` - Fonctions partagées
- `requirements.txt` - Dépendances

## 🌐 Roadmap

**Phase 1 (MVP actuel):** ✅ Complète

- 6 modules IA implémentés
- Intégration complète
- Mode demonstration

**Phase 2 (IoT - 6-12 mois)**

- Capteurs LoRaWAN
- Module 7 (monitoring temps réel)

**Phase 3 (Scaling - 12-18 mois)**

- Extension multi-villes
- Optimisation infrastructure

**Phase 4 (B2G - 18-24 mois)**

- Intégration gouvernementale
- API publiques

## 👥 Contribution

Pour ajouter un nouveau module:

1. Créer `modules_ia/module_X_Y_description.py`
2. Implémenter la classe principale
3. Ajouter les imports dans `modules_ia/__init__.py`
4. Créer le script dans `scripts/`
5. Ajouter la commande dans `main.py`

## 📄 Licence

Projet TRIA CI - 2024

## 📞 Support

Pour des questions ou problèmes, consultez la documentation complète dans le cahier des charges du projet EcoTrack.

---

**Status:** ✅ Production Ready (MVP Phase 1)
