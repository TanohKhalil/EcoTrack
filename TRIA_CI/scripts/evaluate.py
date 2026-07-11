"""
Script 2 - Évaluer le modèle
Évalue les performances sur le jeu de validation
"""

import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))
sys.path.insert(0, str(PROJECT_ROOT / "modules_ia"))

from src.config import BEST_MODEL
from src.utils import load_dataset, print_report, save_confusion_matrix
from modules_ia.module_6_1_classification import ClassificationModule


def main():
    print("\n" + "="*60)
    print("ÉVALUATION DU MODÈLE")
    print("="*60 + "\n")
    
    # Charger le dataset et le modèle
    _, val_ds, class_names = load_dataset()
    
    classifier = ClassificationModule(BEST_MODEL)
    loss, accuracy = classifier.evaluate(val_ds, class_names)
    
    print("\n" + "="*60)
    print(f"Loss     : {loss:.4f}")
    print(f"Accuracy : {accuracy*100:.2f}%")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
