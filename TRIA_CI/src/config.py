"""
==================================================
TRIA CI - Configuration du projet
==================================================
Toutes les constantes du projet sont définies ici.
Si tu souhaites modifier un paramètre, fais-le dans ce fichier.
==================================================
"""

from pathlib import Path

# ==========================================================
# CHEMINS - Adaptés à la nouvelle structure
# ==========================================================

BASE_DIR = Path(__file__).resolve().parent.parent

SRC_DIR = BASE_DIR / "src"
MODULES_DIR = BASE_DIR / "modules_ia"
SCRIPTS_DIR = BASE_DIR / "scripts"
DATA_DIR = BASE_DIR / "data"
MODELS_DIR = BASE_DIR / "models"
DOCS_DIR = BASE_DIR / "docs"

DATASET_DIR = DATA_DIR / "dataset"
TEST_DIR = DATA_DIR / "test"

HISTORY_IMAGE = DATA_DIR / "history.png"
CONFUSION_IMAGE = DATA_DIR / "confusion_matrix.png"

BEST_MODEL = MODELS_DIR / "best_model.keras"
FINAL_MODEL = MODELS_DIR / "final_model.keras"
TFLITE_MODEL = MODELS_DIR / "best_model.tflite"

# ==========================================================
# IMAGE
# ==========================================================

IMAGE_HEIGHT = 224
IMAGE_WIDTH = 224
IMAGE_SIZE = (IMAGE_HEIGHT, IMAGE_WIDTH)
CHANNELS = 3

# ==========================================================
# DATASET
# ==========================================================

VALIDATION_SPLIT = 0.20
BATCH_SIZE = 32
SEED = 123

# ==========================================================
# ENTRAINEMENT
# ==========================================================

INITIAL_EPOCHS = 20
FINE_TUNE_EPOCHS = 30
TOTAL_EPOCHS = INITIAL_EPOCHS + FINE_TUNE_EPOCHS

# ==========================================================
# LEARNING RATE
# ==========================================================

INITIAL_LR = 1e-3
FINE_TUNE_LR = 1e-5

# ==========================================================
# FINE TUNING
# ==========================================================

UNFREEZE_LAST_LAYERS = 40

# ==========================================================
# CALLBACKS
# ==========================================================

EARLY_STOPPING_PATIENCE = 8
REDUCE_LR_PATIENCE = 3
REDUCE_LR_FACTOR = 0.2

# ==========================================================
# CLASSES TRASHNET
# ==========================================================

CLASS_NAMES = [
    "cardboard",
    "glass",
    "metal",
    "paper",
    "plastic",
    "trash"
]

# ==========================================================
# AFFICHAGE EN FRANÇAIS
# ==========================================================

FRENCH_NAMES = {
    "cardboard": "Carton",
    "glass": "Verre",
    "metal": "Métal",
    "paper": "Papier",
    "plastic": "Plastique",
    "trash": "Autres déchets"
}
