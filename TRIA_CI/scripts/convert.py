"""
Script 4 - Convertir en TensorFlow Lite
Convertit le modèle Keras en format mobile TFLite
"""

import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))

import tensorflow as tf
from src.config import BEST_MODEL, TFLITE_MODEL


def main():
    print("\n" + "="*60)
    print("CONVERSION EN TENSORFLOW LITE")
    print("="*60 + "\n")
    
    print(f"Chargement du modèle : {BEST_MODEL}")
    model = tf.keras.models.load_model(BEST_MODEL)
    
    print("Conversion en cours...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()
    
    TFLITE_MODEL.parent.mkdir(exist_ok=True, parents=True)
    with open(TFLITE_MODEL, "wb") as f:
        f.write(tflite_model)
    
    print(f"\n✓ Conversion terminée")
    print(f"Modèle sauvegardé : {TFLITE_MODEL}")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
