"""
Module 6.4 - Optimisation des tournées (VRP)
Génère des itinéraires optimaux pour collecteurs multiples et hétérogènes
"""

import numpy as np
import math


class RouteOptimizer:
    """Optimisation des tournées VRP"""
    
    def __init__(self):
        self.start_point = {"lat": 5.3364, "lon": -4.0268}

    def optimize_route(self, collection_points, collector_type="cart"):
        """Optimise un itinéraire pour un collecteur"""
        if not collection_points:
            return {"route": [], "distance_km": 0, "estimated_time_min": 0}

        capacity = self._get_capacity(collector_type)
        avg_speed = self._get_speed(collector_type)

        all_points = [self.start_point] + collection_points
        route_indices = self._nearest_neighbor(all_points)
        route = [all_points[i] for i in route_indices]

        distance = self._calculate_distance(route)
        time_min = (distance / avg_speed) * 60 + len(collection_points) * 5

        return {
            "route": route,
            "stops": len(collection_points),
            "distance_km": round(distance, 2),
            "estimated_time_min": round(time_min),
            "capacity_remaining_kg": capacity,
            "collection_points": collection_points,
        }

    def optimize_multi_collector(self, collection_points, collectors):
        """Optimise plusieurs collecteurs simultanément"""
        routes = {}

        for i, point in enumerate(collection_points):
            collector_idx = i % len(collectors)
            if collector_idx not in routes:
                routes[collector_idx] = []
            routes[collector_idx].append(point)

        optimized_routes = {}
        for collector_idx, points in routes.items():
            collector = collectors[collector_idx]
            optimized = self.optimize_route(points, collector["type"])
            optimized_routes[collector["id"]] = optimized

        return optimized_routes

    def _nearest_neighbor(self, points):
        """Heuristique du plus proche voisin"""
        if len(points) <= 1:
            return [0]

        unvisited = set(range(1, len(points)))
        current = 0
        route = [current]

        while unvisited:
            nearest = min(
                unvisited,
                key=lambda i: self._haversine_distance(points[current], points[i]),
            )
            route.append(nearest)
            unvisited.remove(nearest)
            current = nearest

        return route

    def _haversine_distance(self, p1, p2):
        """Distance GPS en km"""
        lat1, lon1 = p1["lat"], p1["lon"]
        lat2, lon2 = p2["lat"], p2["lon"]

        R = 6371
        dlat = math.radians(lat2 - lat1)
        dlon = math.radians(lon2 - lon1)
        a = (
            math.sin(dlat / 2) ** 2
            + math.cos(math.radians(lat1))
            * math.cos(math.radians(lat2))
            * math.sin(dlon / 2) ** 2
        )
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return R * c

    def _calculate_distance(self, route):
        """Distance totale"""
        total = 0
        for i in range(len(route) - 1):
            total += self._haversine_distance(route[i], route[i + 1])
        return total

    def _get_capacity(self, collector_type):
        """Capacité en kg"""
        return {"foot": 20, "cart": 50, "moto": 100, "truck": 500}.get(collector_type, 50)

    def _get_speed(self, collector_type):
        """Vitesse en km/h"""
        return {"foot": 4, "cart": 6, "moto": 25, "truck": 30}.get(collector_type, 5)

    def generate_daily_routes(self, districts, daily_volume_forecast):
        """Génère les routes pour toute une journée"""
        all_routes = {}
        for district, volume_pred in daily_volume_forecast.items():
            num_stops = max(1, int(volume_pred["predicted_volume_kg"] / 30))
            collection_points = self._generate_mock_points(num_stops, district)
            route = self.optimize_route(collection_points, "cart")
            all_routes[district] = route

        return all_routes

    def _generate_mock_points(self, num_stops, district):
        """Génère des points simulés"""
        points = []
        base_lat = 5.3364 + np.random.uniform(-0.05, 0.05)
        base_lon = -4.0268 + np.random.uniform(-0.05, 0.05)

        for i in range(num_stops):
            points.append({
                "lat": base_lat + np.random.uniform(-0.01, 0.01),
                "lon": base_lon + np.random.uniform(-0.01, 0.01),
                "waste_type": np.random.choice(["plastique", "organique", "metal", "e-waste"]),
                "stop_id": i + 1,
            })
        return points
