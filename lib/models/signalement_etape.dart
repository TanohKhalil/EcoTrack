import 'package:flutter/foundation.dart';

@immutable
class SignalementEtape {
  final String id;
  final String signalementId;
  final String titre;
  final DateTime date;
  final String? agent;

  const SignalementEtape({
    required this.id,
    required this.signalementId,
    required this.titre,
    required this.date,
    this.agent,
  });

  factory SignalementEtape.fromJson(Map<String, dynamic> json) {
    return SignalementEtape(
      id: json['id'] as String,
      signalementId: json['signalement_id'] as String,
      titre: json['titre'] as String,
      date: DateTime.parse(json['date'] as String),
      agent: json['agent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signalement_id': signalementId,
      'titre': titre,
      'date': date.toIso8601String(),
      'agent': agent,
    };
  }
}
