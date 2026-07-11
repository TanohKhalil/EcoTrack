"""
Module 6.1 - Classification automatique des déchets (Computer Vision)
Utilise MobileNetV3Small avec transfer learning et fine-tuning
"""

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import sys
from pathlib import Path

# Import depuis src
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
from src.config import *
from src.utils import load_dataset, plot_history, save_confusion_matrix, print_report


class ClassificationModule:
    """Modèle de classification automatique des déchets"""
    
    def __init__(self, model_path=None):
        self.model = None
        self.base_model = None
        if model_path:
            self.load_model(model_path)
    
    def load_model(self, model_path):
        """Charge un modèle pré-entraîné"""
        try:
            self.model = tf.keras.models.load_model(model_path)
            print(f"Modèle chargé : {model_path}")
        except Exception as e:
            print(f"Erreur : {e}")
    
    def build_model(self, input_shape, num_classes):
        """Construit le modèle MobileNetV3Small"""
        data_augmentation = keras.Sequential([
            layers.RandomFlip("horizontal"),
            layers.RandomRotation(0.15),
            layers.RandomZoom(0.15),
            layers.RandomTranslation(height_factor=0.10, width_factor=0.10),
            layers.RandomContrast(0.20),
        ])

        base_model = tf.keras.applications.MobileNetV3Small(
            input_shape=input_shape,
            include_top=False,
            weights="imagenet",
        )
        base_model.trainable = False
        self.base_model = base_model

        inputs = keras.Input(shape=input_shape)
        x = data_augmentation(inputs)
        x = tf.keras.applications.mobilenet_v3.preprocess_input(x)
        x = base_model(x, training=False)
        x = layers.GlobalAveragePooling2D()(x)
        x = layers.Dropout(0.30)(x)
        outputs = layers.Dense(num_classes, activation="softmax")(x)

        self.model = keras.Model(inputs, outputs)
        return self.model
    
    def train(self, train_ds=None, val_ds=None, class_names=None):
        """Entraîne le modèle en 2 phases"""
        if train_ds is None:
            train_ds, val_ds, class_names = load_dataset()
        
        MODELS_DIR.mkdir(exist_ok=True, parents=True)
        
        if self.model is None:
            self.build_model(IMAGE_SIZE + (CHANNELS,), len(class_names))
        
        # Phase 1: Transfer Learning
        self.model.compile(
            optimizer=keras.optimizers.Adam(learning_rate=INITIAL_LR),
            loss="sparse_categorical_crossentropy",
            metrics=["accuracy"],
        )
        
        callbacks = [
            keras.callbacks.ModelCheckpoint(
                filepath=BEST_MODEL, monitor="val_accuracy", save_best_only=True
            ),
            keras.callbacks.EarlyStopping(
                monitor="val_loss", patience=EARLY_STOPPING_PATIENCE
            ),
            keras.callbacks.ReduceLROnPlateau(
                monitor="val_loss", factor=REDUCE_LR_FACTOR, patience=REDUCE_LR_PATIENCE
            ),
        ]
        
        print("\n" + "="*60)
        print("PHASE 1 : TRANSFER LEARNING")
        print("="*60 + "\n")
        
        history = self.model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=INITIAL_EPOCHS,
            callbacks=callbacks,
        )
        
        # Phase 2: Fine-tuning
        print("\n" + "="*60)
        print("PHASE 2 : FINE TUNING")
        print("="*60 + "\n")
        
        self.base_model.trainable = True
        for layer in self.base_model.layers[:-UNFREEZE_LAST_LAYERS]:
            layer.trainable = False
        
        self.model.compile(
            optimizer=keras.optimizers.Adam(learning_rate=FINE_TUNE_LR),
            loss="sparse_categorical_crossentropy",
            metrics=["accuracy"],
        )
        
        history_fine = self.model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=history.epoch[-1] + 1 + FINE_TUNE_EPOCHS,
            initial_epoch=history.epoch[-1] + 1,
            callbacks=callbacks,
        )
        
        self.model.save(FINAL_MODEL)
        
        print("\n" + "="*60)
        print("MODÈLE SAUVEGARDÉ")
        print("="*60 + "\n")
        
        return history, history_fine
    
    def evaluate(self, val_ds=None, class_names=None):
        """Évalue le modèle"""
        if val_ds is None or class_names is None:
            _, val_ds, class_names = load_dataset()
        
        if self.model is None:
            self.load_model(BEST_MODEL)
        
        loss, accuracy = self.model.evaluate(val_ds)
        print_report(self.model, val_ds, class_names)
        save_confusion_matrix(self.model, val_ds, class_names)
        
        return loss, accuracy
    
    def predict(self, image_path):
        """Prédit la classe d'une image"""
        from PIL import Image
        import numpy as np
        
        if self.model is None:
            self.load_model(BEST_MODEL)
        
        image = Image.open(image_path).convert("RGB")
        image = image.resize(IMAGE_SIZE)
        image = np.array(image)
        image = np.expand_dims(image, axis=0)
        image = tf.keras.applications.mobilenet_v3.preprocess_input(image)
        
        prediction = self.model.predict(image, verbose=0)[0]
        classe = int(np.argmax(prediction))
        
        return {
            "class": CLASS_NAMES[classe],
            "french_name": FRENCH_NAMES[CLASS_NAMES[classe]],
            "confidence": float(prediction[classe] * 100),
            "probabilities": {CLASS_NAMES[i]: float(p*100) for i, p in enumerate(prediction)}
        }
