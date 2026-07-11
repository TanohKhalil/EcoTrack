#!/usr/bin/env python
"""
TRIA CI - Lanceur central
Interface unifiée pour toutes les commandes du projet

Usage:
  python main.py train          # Entraîner le modèle
  python main.py evaluate       # Évaluer le modèle
  python main.py predict [IMG]  # Prédire sur une image
  python main.py convert        # Convertir en TFLite
  python main.py demo           # Démonstration complète
"""

import sys
import subprocess
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent
SCRIPTS_DIR = PROJECT_ROOT / "scripts"


def run_command(command_name, *args):
    """Exécute un script"""
    script_map = {
        "train": "train.py",
        "evaluate": "evaluate.py",
        "eval": "evaluate.py",
        "predict": "predict.py",
        "pred": "predict.py",
        "convert": "convert.py",
        "demo": "demo.py",
        "demo-complet": "demo.py",
    }
    
    if command_name not in script_map:
        print_usage()
        sys.exit(1)
    
    script = SCRIPTS_DIR / script_map[command_name]
    
    try:
        cmd = [sys.executable, str(script)] + list(args)
        result = subprocess.run(cmd, check=True)
        sys.exit(result.returncode)
    except subprocess.CalledProcessError as e:
        print(f"❌ Erreur : {e}")
        sys.exit(1)
    except FileNotFoundError:
        print(f"❌ Script non trouvé : {script}")
        sys.exit(1)


def print_usage():
    """Affiche l'aide"""
    print("\n" + "="*60)
    print("TRIA CI - Intelligence Artificielle pour les Déchets")
    print("="*60)
    print("\nCommandes disponibles :\n")
    print("  python main.py train              Entraîner le modèle")
    print("  python main.py evaluate           Évaluer le modèle")
    print("  python main.py predict [--image PATH]  Prédire sur une image")
    print("  python main.py convert            Convertir en TensorFlow Lite")
    print("  python main.py demo               Démonstration des 6 modules")
    print("\n" + "="*60 + "\n")


def main():
    if len(sys.argv) < 2:
        print_usage()
        sys.exit(1)
    
    command = sys.argv[1]
    args = sys.argv[2:] if len(sys.argv) > 2 else []
    
    run_command(command, *args)


if __name__ == "__main__":
    main()
