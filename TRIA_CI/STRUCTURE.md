# TRIA CI - Structure du Projet

## 📊 Vue d'ensemble hiérarchique

```
TRIA_CI/
│
├── 🚀 POINT D'ENTREE
│   └── main.py                    # Lanceur centralisé
│
├── 📋 CONFIGURATION & DOCS
│   ├── README.md                  # Guide complet
│   ├── requirements.txt           # Dépendances
│   ├── .gitignore                 # Git config
│   └── Cahier_des_charges_EcoTrack.docx
│
├── 📁 src/                        # Code principal (BASE)
│   ├── __init__.py
│   ├── config.py                  # Configuration centralisée
│   └── utils.py                   # Utilitaires partagés
│
├── 📁 modules_ia/                 # 6 MODULES IA
│   ├── __init__.py
│   ├── module_6_1_classification.py          [✅ MobileNetV3]
│   ├── module_6_2_dump_detection.py          [📍 Satellite]
│   ├── module_6_3_volume_prediction.py       [📊 RandomForest]
│   ├── module_6_4_route_optimization.py      [🗺️ VRP]
│   ├── module_6_5_collector_scoring.py       [⭐ Scoring]
│   └── module_6_6_community_voting.py        [🗳️ Crowdsource]
│
├── 📁 scripts/                    # SCRIPTS D'EXECUTION
│   ├── train.py                   # Entraîner
│   ├── evaluate.py                # Évaluer
│   ├── predict.py                 # Prédire
│   ├── convert.py                 # TFLite
│   └── demo.py                    # Démonstration
│
├── 📁 data/                       # DONNEES
│   ├── dataset/                   # Images d'entraînement
│   │   ├── cardboard/
│   │   ├── glass/
│   │   ├── metal/
│   │   ├── paper/
│   │   ├── plastic/
│   │   └── trash/
│   ├── test/                      # Images de test
│   ├── history.png                # Courbes d'entraînement
│   └── confusion_matrix.png       # Matrice de confusion
│
├── 📁 models/                     # MODELES
│   ├── best_model.keras           # Meilleur Keras
│   ├── final_model.keras          # Final Keras
│   └── best_model.tflite          # Mobile TFLite
│
├── 📁 docs/                       # DOCUMENTATION
│   └── (à remplir)
│
└── 📁 .venv/                      # Environnement virtuel

```

## 🔄 Flux d'exécution

```
main.py (lanceur)
    ↓
    ├─→ python main.py train      → scripts/train.py      → Module 6.1
    ├─→ python main.py evaluate   → scripts/evaluate.py   → Module 6.1
    ├─→ python main.py predict    → scripts/predict.py    → Module 6.1
    ├─→ python main.py convert    → scripts/convert.py    → TFLite
    └─→ python main.py demo       → scripts/demo.py       → Modules 6.1-6.6
```

## 🏗️ Dépendances entre modules

```
src/config.py (configuration)
    ↓
src/utils.py (utilitaires)
    ↓
modules_ia/module_6_1_classification.py (base)
    ↓
modules_ia/module_6_2_*.py (autres modules)
    ↓
scripts/*.py (scripts d'exécution)
```

## 📦 Imports principaux

```python
# Dans scripts/
from src.config import *                    # Configuration
from src.utils import *                     # Utilitaires

# Pour les modules
from modules_ia.module_6_X_*.py import *   # Module spécifique
```

## 🎯 Points clés de l'architecture

### 1. Centralisation (config.py)

- Tous les chemins, hyperparamètres, constantes
- Source unique de vérité pour le projet

### 2. Modularité (modules_ia/)

- Chaque module = classe indépendante
- Peut être utilisée seule ou intégrée
- Mock implementations pour tests

### 3. Orchestration (scripts/)

- Interface CLI uniforme via main.py
- Chaque script peut être exécuté indépendamment
- Réutilisable pour intégration externe

### 4. Séparation des responsabilités

- **src/** = Code partagé (config, utils)
- **modules_ia/** = Logique métier IA
- **scripts/** = Interface utilisateur
- **data/** = Données et résultats
- **models/** = Modèles entraînés

## 🔗 Comment ajouter un nouveau module

```bash
1. Créer modules_ia/module_X_description.py
2. Implémenter une classe avec méthodes clés
3. Ajouter import dans modules_ia/__init__.py
4. Créer script dans scripts/ si nécessaire
5. Ajouter commande dans main.py
```

## ✅ Validation du projet

```bash
# Tester un module
python -c "from modules_ia.module_6_1_classification import *; print('✓')"

# Tester les imports
python main.py

# Tester la démo complète
python main.py demo
```

## 🚀 Commandes utiles

```bash
# Activation
.\.venv\Scripts\Activate.ps1

# Exécution
python main.py train
python main.py evaluate
python main.py predict --image data/test/photo.jpg
python main.py convert
python main.py demo

# Validation
python -m py_compile src/*.py modules_ia/*.py scripts/*.py
```

## 📊 Structure des données

```
Dataset structure (ImageNet-like):
data/dataset/
├── cardboard/
│   ├── img_001.jpg
│   ├── img_002.jpg
│   └── ...
├── glass/
│   └── ...
└── ...

Test images:
data/test/
└── photo.jpg
```

## 🎨 Conventions du code

- **config.py**: Toutes en MAJUSCULES
- **utils.py**: Fonctions avec type hints
- **modules_ia/**: Classes PascalCase, méthodes snake_case
- **scripts/**: Point d'entrée with main()

---

**Status:** ✅ Production Ready
**Version:** 1.0.0
**Date:** 2026-07-10
