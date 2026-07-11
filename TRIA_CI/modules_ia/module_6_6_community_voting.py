"""
Module 6.6 - Vote Communautaire
Collecte et utilise les corrections crowdsourcing pour l'amélioration continue du modèle
"""

import numpy as np
from collections import defaultdict
from datetime import datetime


class CommunityVoting:
    """Système de vote communautaire pour IA collaborative"""
    
    def __init__(self, confidence_threshold=0.70):
        self.confidence_threshold = confidence_threshold
        self.voting_sessions = {}
        self.votes_history = []
        self.model_retraining_buffer = []

    def should_trigger_vote(self, model_confidence):
        """Déclenche un vote si confiance basse"""
        return model_confidence < self.confidence_threshold

    def create_voting_session(self, image_id, top_candidates, model_confidence):
        """Crée une session de vote"""
        session_id = f"vote_{image_id}_{datetime.now().timestamp()}"

        self.voting_sessions[session_id] = {
            "image_id": image_id,
            "created_at": datetime.now(),
            "model_confidence": model_confidence,
            "top_candidates": top_candidates[:2],
            "votes": defaultdict(int),
            "total_votes": 0,
            "status": "active",
            "winning_category": None,
        }

        return session_id

    def submit_vote(self, session_id, user_id, selected_category):
        """Enregistre un vote"""
        if session_id not in self.voting_sessions:
            return {"status": "error", "message": "Session introuvable"}

        session = self.voting_sessions[session_id]

        if session["status"] != "active":
            return {"status": "error", "message": "Session fermée"}

        candidates = [c["category"] for c in session["top_candidates"]]
        if selected_category not in candidates:
            return {"status": "error", "message": "Catégorie non valide"}

        session["votes"][selected_category] += 1
        session["total_votes"] += 1

        self.votes_history.append({
            "session_id": session_id,
            "user_id": user_id,
            "vote": selected_category,
            "timestamp": datetime.now(),
        })

        self.model_retraining_buffer.append({
            "image_id": session["image_id"],
            "ground_truth": selected_category,
            "model_prediction": session["top_candidates"][0]["category"],
            "model_confidence": session["model_confidence"],
            "community_consensus": selected_category,
            "vote_count": session["total_votes"],
        })

        if self._check_consensus(session):
            self.close_voting_session(session_id)

        return {"status": "success", "votes_count": session["total_votes"]}

    def _check_consensus(self, session):
        """Vérifie s'il y a consensus"""
        if session["total_votes"] < 2:
            return False

        max_votes = max(session["votes"].values())
        consensus_threshold = 0.7 * session["total_votes"]

        return max_votes >= consensus_threshold or session["total_votes"] >= 5

    def close_voting_session(self, session_id):
        """Ferme une session"""
        if session_id not in self.voting_sessions:
            return

        session = self.voting_sessions[session_id]
        session["status"] = "closed"

        if session["votes"]:
            winning_category = max(session["votes"], key=session["votes"].get)
            session["winning_category"] = winning_category

            model_prediction = session["top_candidates"][0]["category"]
            session["was_corrected"] = winning_category != model_prediction

    def get_voting_result(self, session_id):
        """Retourne le résultat"""
        if session_id not in self.voting_sessions:
            return None

        session = self.voting_sessions[session_id]

        return {
            "session_id": session_id,
            "image_id": session["image_id"],
            "model_prediction": session["top_candidates"][0]["category"],
            "model_confidence": session["model_confidence"],
            "community_result": session["winning_category"],
            "vote_distribution": dict(session["votes"]),
            "total_votes": session["total_votes"],
            "status": session["status"],
            "was_corrected": session.get("was_corrected", False),
        }

    def get_retraining_dataset(self):
        """Retourne les données pour ré-entraînement"""
        return {
            "total_samples": len(self.model_retraining_buffer),
            "samples": self.model_retraining_buffer,
            "corrections_rate": self._calculate_corrections_rate(),
        }

    def _calculate_corrections_rate(self):
        """Taux de correction"""
        if not self.model_retraining_buffer:
            return 0.0

        corrections = sum(
            1 for s in self.model_retraining_buffer
            if s["model_prediction"] != s["community_consensus"]
        )
        return (corrections / len(self.model_retraining_buffer)) * 100

    def clear_retraining_buffer(self):
        """Vide le buffer"""
        cleared = len(self.model_retraining_buffer)
        self.model_retraining_buffer = []
        return cleared

    def get_statistics(self):
        """Retourne les statistiques"""
        active_sessions = sum(1 for s in self.voting_sessions.values() if s["status"] == "active")
        closed_sessions = len(self.voting_sessions) - active_sessions

        return {
            "active_voting_sessions": active_sessions,
            "closed_voting_sessions": closed_sessions,
            "total_votes_recorded": len(self.votes_history),
            "corrections_rate": self._calculate_corrections_rate(),
            "model_improvement_samples": len(self.model_retraining_buffer),
        }
