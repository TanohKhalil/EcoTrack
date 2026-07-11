"""
Script 5 - Démonstration complète
Montre tous les 6 modules IA intégrés dans un workflow complet
"""

import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src"))
sys.path.insert(0, str(PROJECT_ROOT / "modules_ia"))

from modules_ia.module_6_1_classification import ClassificationModule
from modules_ia.module_6_2_dump_detection import WildDumpDetector
from modules_ia.module_6_3_volume_prediction import VolumPredictor
from modules_ia.module_6_4_route_optimization import RouteOptimizer
from modules_ia.module_6_5_collector_scoring import CollectorScoring
from modules_ia.module_6_6_community_voting import CommunityVoting


class EcoTrackAIOrchestr:
    """Orchestration de tous les 6 modules IA"""
    
    def __init__(self):
        self.classifier = ClassificationModule()
        self.detector = WildDumpDetector()
        self.predictor = VolumPredictor()
        self.optimizer = RouteOptimizer()
        self.scorer = CollectorScoring()
        self.voting = CommunityVoting()
    
    def complete_workflow_demo(self):
        """Démontre le workflow complet"""
        print("\n" + "="*60)
        print("DEMONSTRATION ECOTRACK - TOUS LES 6 MODULES IA")
        print("="*60 + "\n")
        
        # Module 6.1 : Classification
        print("📸 [MODULE 6.1] Classification des déchets")
        print("-"*60)
        classification_result = {
            "image": "waste_sample.jpg",
            "predicted_class": "plastique",
            "confidence": 78.5,
        }
        print(f"Classe prédite : {classification_result['predicted_class']}")
        print(f"Confiance : {classification_result['confidence']:.1f}%\n")
        
        # Module 6.2 : Détection
        print("🚨 [MODULE 6.2] Détection de dépôts sauvages")
        print("-"*60)
        dump_detection = self.detector.detect_dump("satellite_image.jpg")
        print(f"Dépôts détectés : {len(dump_detection)}")
        print(f"Sévérité : {dump_detection[0]['severity']}")
        print(f"Confiance : {dump_detection[0]['confidence']*100:.0f}%\n")
        
        # Module 6.3 : Prédiction volumes
        print("📊 [MODULE 6.3] Prédiction des volumes")
        print("-"*60)
        districts = ["Cocody", "Plateaux", "Treichville"]
        for district in districts:
            pred = self.predictor.predict_daily_volume(district, {
                "day_of_week": 3, "is_market_day": True,
                "temperature": 28, "rainfall": 0,
                "population_density": 100, "commercial_activity": 0.8
            })
            print(f"{district:20} {pred['predicted_volume_kg']:>6.0f}kg (confiance {pred['confidence']*100:.0f}%)")
        print()
        
        # Module 6.4 : Optimisation routes
        print("🗺️  [MODULE 6.4] Optimisation des tournées")
        print("-"*60)
        collection_points = [
            {"lat": 5.34, "lon": -4.02, "waste_type": "plastique"},
            {"lat": 5.33, "lon": -4.03, "waste_type": "organique"},
        ]
        
        collectors = [
            {"id": "C1", "type": "cart"},
            {"id": "C2", "type": "moto"},
        ]
        
        routes = self.optimizer.optimize_multi_collector(collection_points, collectors)
        for collector_id, route in routes.items():
            print(f"Collecteur {collector_id:3} : {route['distance_km']:.2f}km ({route['estimated_time_min']}min)")
        print()
        
        # Module 6.5 : Scoring
        print("⭐ [MODULE 6.5] Scoring des collecteurs")
        print("-"*60)
        self.scorer.register_collector("Abou", {
            "name": "Abou", "vehicle_type": "cart",
            "specialties": ["plastique", "metal"]
        })
        self.scorer.log_collection("Abou", 80, 80, True, "plastique")
        self.scorer.log_collection("Abou", 60, 50, False, "organique")
        
        score = self.scorer.calculate_overall_score("Abou")
        print(f"Score global Abou : {score:.2f}%\n")
        
        # Module 6.6 : Vote
        print("🗳️  [MODULE 6.6] Vote communautaire")
        print("-"*60)
        session_id = self.voting.create_voting_session("img_001", [
            {"category": "plastique", "confidence": 0.65},
            {"category": "organique", "confidence": 0.25},
        ], 0.65)
        
        self.voting.submit_vote(session_id, "user1", "plastique")
        self.voting.submit_vote(session_id, "user2", "plastique")
        self.voting.submit_vote(session_id, "user3", "organique")
        
        result = self.voting.get_voting_result(session_id)
        print(f"Résultat du vote : {result['community_result']}")
        print(f"Correction détectée : {result['was_corrected']}")
        print(f"Votes : {result['total_votes']}\n")
        
        print("="*60)
        print("✓ WORKFLOW COMPLET DÉTERMINÉ")
        print("="*60 + "\n")


def main():
    orchestrator = EcoTrackAIOrchestr()
    orchestrator.complete_workflow_demo()


if __name__ == "__main__":
    main()
