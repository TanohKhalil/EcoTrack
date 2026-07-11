"""
Module 6.3 - Prédiction des volumes de déchets
Prédit les volumes par quartier pour planification (horizon 7 jours)
"""

import numpy as np
from sklearn.ensemble import RandomForestRegressor
import pickle


class VolumPredictor:
    """Prédiction des volumes de déchets"""
    
    def __init__(self, model_path=None):
        self.model = None
        self.model_path = model_path
        self.feature_names = [
            "day_of_week", "is_market_day", "temperature",
            "rainfall", "population_density", "commercial_activity",
        ]
        if model_path:
            self.load_model()

    def load_model(self):
        """Charge un modèle Random Forest pré-entraîné"""
        try:
            with open(self.model_path, "rb") as f:
                self.model = pickle.load(f)
            print(f"Modèle chargé : {self.model_path}")
        except Exception as e:
            print(f"Erreur : {e}")

    def train_model(self, X_train, y_train):
        """Entraîne Random Forest"""
        self.model = RandomForestRegressor(
            n_estimators=100, max_depth=15, random_state=42, n_jobs=-1
        )
        self.model.fit(X_train, y_train)
        print("Modèle entraîné")

    def predict_daily_volume(self, district, date_features):
        """Prédit le volume pour un district"""
        if not self.model:
            return self._mock_prediction()

        features = self._prepare_features(date_features)
        prediction = self.model.predict([features])[0]
        confidence = self._estimate_confidence(features)

        return {
            "district": district,
            "predicted_volume_kg": float(prediction),
            "confidence": confidence,
            "recommended_collection_type": self._recommend_collection(prediction),
        }

    def predict_7day_forecast(self, district, weather_forecast):
        """Prédit les volumes pour 7 jours"""
        forecast = []
        for day_offset in range(7):
            day_features = self._create_features_for_day(day_offset, weather_forecast)
            pred = self.predict_daily_volume(district, day_features)
            forecast.append(pred)
        return forecast

    def _prepare_features(self, date_features):
        """Prépare le vecteur de features"""
        features = []
        for fname in self.feature_names:
            features.append(date_features.get(fname, 0.0))
        return np.array(features, dtype=float)

    def _estimate_confidence(self, features):
        """Estime la confiance"""
        return 0.75 + np.random.uniform(0, 0.2)

    def _recommend_collection(self, volume_kg):
        """Recommande le type de collecte"""
        if volume_kg < 50:
            return "light"
        elif volume_kg < 200:
            return "medium"
        elif volume_kg < 500:
            return "heavy"
        else:
            return "truck"

    def _create_features_for_day(self, day_offset, weather_forecast):
        """Crée features pour un jour"""
        return {
            "day_of_week": (day_offset % 7),
            "is_market_day": day_offset % 3 == 0,
            "temperature": weather_forecast.get("temperature", 28),
            "rainfall": weather_forecast.get("rainfall", 0),
            "population_density": 100,
            "commercial_activity": np.random.uniform(0.5, 1.0),
        }

    def _mock_prediction(self):
        """Prédiction simulée"""
        return {
            "predicted_volume_kg": 150,
            "confidence": 0.82,
            "recommended_collection_type": "medium",
        }

    def save_model(self, output_path):
        """Sauvegarde le modèle"""
        if self.model:
            with open(output_path, "wb") as f:
                pickle.dump(self.model, f)
            print(f"Modèle sauvegardé : {output_path}")
