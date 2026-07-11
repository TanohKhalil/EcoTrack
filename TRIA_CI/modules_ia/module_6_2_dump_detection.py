"""
Module 6.2 - Détection des dépôts sauvages
Détecte la formation de décharges illégales via satellite/caméra
"""

import numpy as np
import tensorflow as tf
from PIL import Image


class WildDumpDetector:
    """Détection des dépôts sauvages"""
    
    def __init__(self, model_path=None):
        self.model_path = model_path
        self.model = None
        if model_path:
            self.load_model()

    def load_model(self):
        """Charge un modèle YOLO/U-Net pré-entraîné"""
        try:
            self.model = tf.keras.models.load_model(self.model_path)
            print(f"Modèle chargé : {self.model_path}")
        except Exception as e:
            print(f"Erreur : {e}")

    def detect_dump(self, image_path):
        """Détecte les dépôts sauvages"""
        if not self.model:
            return self._mock_detection()

        image = Image.open(image_path).convert("RGB")
        image = np.array(image)
        image = np.expand_dims(image, axis=0)
        predictions = self.model.predict(image, verbose=0)
        
        return self._parse_predictions(predictions)

    def _mock_detection(self):
        """Détection simulée pour test"""
        return [{
            "id": 1,
            "confidence": 0.85,
            "location": {"lat": 5.3364, "lon": -4.0268},
            "area": 150,
            "severity": "high",
            "debris_type": "mixed",
        }]

    def _parse_predictions(self, predictions):
        """Parse les prédictions du modèle"""
        detections = []
        return detections

    def compare_temporal(self, image1_path, image2_path):
        """Compare deux images pour détecter changements"""
        img1 = Image.open(image1_path).convert("RGB")
        img2 = Image.open(image2_path).convert("RGB")

        arr1 = np.array(img1)
        arr2 = np.array(img2)

        diff = np.abs(arr1.astype(float) - arr2.astype(float))
        change_ratio = np.sum(diff > 30) / diff.size

        return change_ratio > 0.10

    def generate_alert(self, dump_detection, location_data):
        """Génère une alerte géolocalisée"""
        return {
            "timestamp": str(np.datetime64("now")),
            "type": "wild_dump_detected",
            "location": location_data,
            "severity": dump_detection.get("severity", "medium"),
            "debris_type": dump_detection.get("debris_type", "unknown"),
            "estimated_area": dump_detection.get("area", 0),
            "urgency_level": self._calculate_urgency(dump_detection),
        }

    def _calculate_urgency(self, detection):
        """Calcule le niveau d'urgence"""
        severity = detection.get("severity", "medium")
        urgency_map = {"low": 1, "medium": 2, "high": 3, "critical": 4}
        return urgency_map.get(severity, 2)
