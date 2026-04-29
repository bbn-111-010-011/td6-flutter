import 'serie.dart';

/// Les trois états possibles d'une série dans la watchlist.
enum StatutVisionnage {
  aVoir,
  enCours,
  vu;

  /// Libellé affiché à l'utilisateur.
  String get label => switch (this) {
        StatutVisionnage.aVoir => 'À voir',
        StatutVisionnage.enCours => 'En cours',
        StatutVisionnage.vu => 'Vu',
      };

  /// Reconstruit un StatutVisionnage depuis son nom stocké en base.
  static StatutVisionnage fromString(String s) {
    return StatutVisionnage.values.firstWhere(
      (e) => e.name == s,
      orElse: () => StatutVisionnage.aVoir,
    );
  }
}

class WatchlistItem {
  final Serie serie;
  StatutVisionnage statut;

  WatchlistItem({
    required this.serie,
    this.statut = StatutVisionnage.aVoir,
  });

  Map<String, dynamic> toJson() => {
        'serie': serie.toJson(),
        'statut': statut.name,
      };

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      serie: Serie.fromJson(json['serie'] as Map<String, dynamic>),
      statut: StatutVisionnage.fromString(json['statut'] as String? ?? 'aVoir'),
    );
  }
}
