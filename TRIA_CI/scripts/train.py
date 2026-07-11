"""
Script 1 - Entraîner le modèle
Exécute les phases de transfer learning et fine-tuning
"""

import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))
sys.path.insert(0, str(PROJECT_ROOT / "modules_ia"))

from src.config import *
from src.utils import load_dataset, plot_history, save_confusion_matrix, print_report
from modules_ia.module_6_1_classification import ClassificationModule


def main():
    print("\n" + "="*60)
    print("ENTRAINEMENT DU MODÈLE IA")
    print("="*60 + "\n")
    
    # Charger le dataset
    train_ds, val_ds, class_names = load_dataset()
    print(f"Classes détectées : {class_names}\n")
    
    # Initialiser et entraîner le modèle
    classifier = ClassificationModule()
    classifier.build_model(IMAGE_SIZE + (CHANNELS,), len(class_names))
    
    history, history_fine = classifier.train(train_ds, val_ds, class_names)
    
    # Générer les métriques
    plot_history(history)
    print_report(classifier.model, val_ds, class_names)
    save_confusion_matrix(classifier.model, val_ds, class_names)
    
    print("\n" + "="*60)
    print("ENTRAINEMENT TERMINÉ")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
