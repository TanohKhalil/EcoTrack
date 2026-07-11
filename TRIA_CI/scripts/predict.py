"""
Script 3 - Prédire sur une image
Effectue l'inférence du modèle sur une image donnée
"""

import argparse
import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))
sys.path.insert(0, str(PROJECT_ROOT / "modules_ia"))

from src.config import BEST_MODEL, TEST_DIR
from modules_ia.module_6_1_classification import ClassificationModule


def main():
    parser = argparse.ArgumentParser(description="Prédiction d'une image de déchets")
    parser.add_argument("--image", default=str(TEST_DIR / "photo.jpg"), 
                       help="Chemin vers l'image")
    args = parser.parse_args()
    
    print("\n" + "="*60)
    print("PRÉDICTION")
    print("="*60 + "\n")
    
    classifier = ClassificationModule(BEST_MODEL)
    result = classifier.predict(args.image)
    
    print(f"Classe : {result['class']}")
    print(f"Nom : {result['french_name']}")
    print(f"Confiance : {result['confidence']:.2f}%")
    print("\n" + "-"*60)
    print("Probabilités :")
    print("-"*60)
    for cls, prob in result['probabilities'].items():
        print(f"  {cls:<15} {prob:.2f}%")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
