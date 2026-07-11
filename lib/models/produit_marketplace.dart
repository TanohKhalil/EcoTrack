import 'package:flutter/foundation.dart';

@immutable
class ProduitMarketplace {
  final String id;
  final String nom;
  final String fournisseur;
  final int prixFcfa;
  final String categorie;
  final String? imageUrl;

  const ProduitMarketplace({
    required this.id,
    required this.nom,
    required this.fournisseur,
    required this.prixFcfa,
    required this.categorie,
    this.imageUrl,
  });

  factory ProduitMarketplace.fromJson(Map<String, dynamic> json) {
    return ProduitMarketplace(
      id: json['id'] as String,
      nom: json['nom'] as String,
      fournisseur: json['fournisseur'] as String,
      prixFcfa: (json['prix_fcfa'] as num).toInt(),
      categorie: json['categorie'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'fournisseur': fournisseur,
      'prix_fcfa': prixFcfa,
      'categorie': categorie,
      'image_url': imageUrl,
    };
  }
}
