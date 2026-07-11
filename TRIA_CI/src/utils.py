"""
====================================================
TRIA CI - Fonctions utilitaires
====================================================
"""

import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf

from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay

from src.config import (
    DATASET_DIR,
    IMAGE_SIZE,
    BATCH_SIZE,
    VALIDATION_SPLIT,
    SEED,
    CONFUSION_IMAGE,
    HISTORY_IMAGE,
)

AUTOTUNE = tf.data.AUTOTUNE


# ==========================================================
# Chargement du dataset
# ==========================================================

def load_dataset():
    """Charge et retourne les jeux d'entraînement et de validation."""
    train_ds = tf.keras.utils.image_dataset_from_directory(
        DATASET_DIR,
        validation_split=VALIDATION_SPLIT,
        subset="training",
        seed=SEED,
        image_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        shuffle=True,
    )

    val_ds = tf.keras.utils.image_dataset_from_directory(
        DATASET_DIR,
        validation_split=VALIDATION_SPLIT,
        subset="validation",
        seed=SEED,
        image_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        shuffle=False,
    )

    class_names = train_ds.class_names

    train_ds = train_ds.prefetch(AUTOTUNE)
    val_ds = val_ds.prefetch(AUTOTUNE)

    return train_ds, val_ds, class_names


# ==========================================================
# Affichage des courbes Accuracy / Loss
# ==========================================================

def plot_history(history):
    """Sauvegarde et affiche l'historique d'entraînement."""
    plt.figure(figsize=(12, 5))

    plt.subplot(1, 2, 1)
    plt.plot(history.history["accuracy"], label="Train")
    plt.plot(history.history["val_accuracy"], label="Validation")
    plt.title("Accuracy")
    plt.legend()

    plt.subplot(1, 2, 2)
    plt.plot(history.history["loss"], label="Train")
    plt.plot(history.history["val_loss"], label="Validation")
    plt.title("Loss")
    plt.legend()

    plt.tight_layout()
    plt.savefig(HISTORY_IMAGE)
    plt.close()


# ==========================================================
# Matrice de confusion
# ==========================================================

def save_confusion_matrix(model, dataset, class_names, output_path=CONFUSION_IMAGE):
    """Calcule et sauvegarde la matrice de confusion."""
    y_true = []
    y_pred = []

    for images, labels in dataset:
        predictions = model.predict(images, verbose=0)
        y_pred.extend(np.argmax(predictions, axis=1))
        y_true.extend(labels.numpy())

    cm = confusion_matrix(y_true, y_pred)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=class_names)

    fig, ax = plt.subplots(figsize=(8, 8))
    disp.plot(ax=ax, cmap="Blues")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close()

    return cm


# ==========================================================
# Rapport Precision Recall F1
# ==========================================================

def print_report(model, dataset, class_names):
    """Affiche le rapport de classification du modèle."""
    y_true = []
    y_pred = []

    for images, labels in dataset:
        predictions = model.predict(images, verbose=0)
        y_pred.extend(np.argmax(predictions, axis=1))
        y_true.extend(labels.numpy())

    print()
    print("=" * 60)
    print("RAPPORT DE CLASSIFICATION")
    print("=" * 60)
    print(
        classification_report(
            y_true,
            y_pred,
            target_names=class_names,
            digits=4,
        )
    )
