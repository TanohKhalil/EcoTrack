"""
Module 6.5 - Scoring et Matching des collecteurs
Évalue la fiabilité et connecte aux filières appropriées
"""

import numpy as np
from datetime import datetime


class CollectorScoring:
    """Scoring et matching des collecteurs"""
    
    def __init__(self):
        self.collectors_history = {}

    def register_collector(self, collector_id, initial_data):
        """Enregistre un collecteur"""
        self.collectors_history[collector_id] = {
            "name": initial_data.get("name", "Unknown"),
            "location": initial_data.get("location", {}),
            "vehicle_type": initial_data.get("vehicle_type", "cart"),
            "waste_specialties": initial_data.get("specialties", []),
            "total_collections": 0,
            "total_kg_collected": 0,
            "total_revenue": 0,
            "reliability_score": 0.5,
            "punctuality_score": 0.5,
            "accuracy_score": 0.5,
            "ratings": [],
            "transactions": [],
        }

    def log_collection(self, collector_id, volume_declared_kg, volume_verified_kg, on_time, waste_type):
        """Enregistre une collecte"""
        if collector_id not in self.collectors_history:
            return

        collector = self.collectors_history[collector_id]
        collector["total_collections"] += 1
        collector["total_kg_collected"] += volume_verified_kg

        if volume_declared_kg > 0:
            accuracy = min(volume_verified_kg / volume_declared_kg, 1.0)
        else:
            accuracy = 0.5

        alpha = 0.1
        collector["accuracy_score"] = (1 - alpha) * collector["accuracy_score"] + alpha * accuracy
        collector["punctuality_score"] = (1 - alpha) * collector["punctuality_score"] + alpha * (1.0 if on_time else 0.6)

        collector["transactions"].append({
            "date": str(datetime.now()),
            "declared_kg": volume_declared_kg,
            "verified_kg": volume_verified_kg,
            "waste_type": waste_type,
            "on_time": on_time,
        })

    def calculate_overall_score(self, collector_id):
        """Calcule le score global"""
        if collector_id not in self.collectors_history:
            return 0.0

        collector = self.collectors_history[collector_id]
        weights = {"accuracy": 0.4, "punctuality": 0.35, "reliability": 0.25}

        overall = (
            weights["accuracy"] * collector["accuracy_score"]
            + weights["punctuality"] * collector["punctuality_score"]
            + weights["reliability"] * collector["reliability_score"]
        )

        return round(overall * 100, 2)

    def match_collector_to_filiere(self, collector_id, waste_volumes_by_type):
        """Recommande la filière appropriée"""
        if collector_id not in self.collectors_history:
            return None

        collector = self.collectors_history[collector_id]
        score = self.calculate_overall_score(collector_id)

        recommendations = []

        for waste_type, volume_kg in waste_volumes_by_type.items():
            is_specialty = waste_type in collector["waste_specialties"]
            affinity = 0.9 if is_specialty else 0.6
            matching_score = (score / 100) * affinity

            recommendations.append({
                "waste_type": waste_type,
                "volume_kg": volume_kg,
                "filiere": self._select_filiere(waste_type),
                "match_score": round(matching_score, 3),
                "is_specialty": is_specialty,
            })

        recommendations.sort(key=lambda x: x["match_score"], reverse=True)

        return {
            "collector_id": collector_id,
            "collector_name": collector["name"],
            "overall_score": score,
            "recommendations": recommendations,
            "best_match": recommendations[0] if recommendations else None,
        }

    def _select_filiere(self, waste_type):
        """Sélectionne la filière"""
        filiere_map = {
            "plastique": "Recycleur Plastique SARL",
            "organique": "Unité Compost Biogaz",
            "metal": "Ferrailleur Local",
            "e-waste": "Centre E-Waste ASREC",
            "verre": "Verrerie Artisanale",
            "carton": "Papeterie Recyclage",
        }
        return filiere_map.get(waste_type, "Filière Générale")

    def rate_collector(self, collector_id, rating_stars, comment=""):
        """Ajoute une évaluation"""
        if collector_id not in self.collectors_history:
            return

        collector = self.collectors_history[collector_id]
        collector["ratings"].append({
            "date": str(datetime.now()),
            "stars": rating_stars,
            "comment": comment,
        })

        avg_rating = np.mean([r["stars"] for r in collector["ratings"]])
        collector["reliability_score"] = avg_rating / 5.0

    def get_collector_profile(self, collector_id):
        """Retourne le profil complet"""
        if collector_id not in self.collectors_history:
            return None

        collector = self.collectors_history[collector_id]
        overall_score = self.calculate_overall_score(collector_id)

        return {
            "id": collector_id,
            "name": collector["name"],
            "location": collector["location"],
            "vehicle_type": collector["vehicle_type"],
            "specialties": collector["waste_specialties"],
            "total_collections": collector["total_collections"],
            "total_kg_collected": collector["total_kg_collected"],
            "total_revenue": collector["total_revenue"],
            "overall_score": overall_score,
            "accuracy_score": round(collector["accuracy_score"] * 100, 1),
            "punctuality_score": round(collector["punctuality_score"] * 100, 1),
            "reliability_score": round(collector["reliability_score"] * 100, 1),
            "avg_rating": np.mean([r["stars"] for r in collector["ratings"]]) if collector["ratings"] else 0,
            "num_ratings": len(collector["ratings"]),
        }

    def get_leaderboard(self, limit=10):
        """Retourne le classement"""
        scores = [(cid, self.calculate_overall_score(cid)) for cid in self.collectors_history.keys()]
        scores.sort(key=lambda x: x[1], reverse=True)
        return scores[:limit]
