import 'package:flutter_test/flutter_test.dart';
import 'package:td6/models/serie.dart';
import 'package:td6/models/watchlist_item.dart';

const testSerie1 = Serie(
  id: 1,
  nom: 'Breaking Bad',
  synopsis: 'A chemistry teacher diagnosed with cancer turns to crime.',
  genre: 'Drama',
  imageUrl: 'https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg',
  note: 9.3,
  statut: 'Ended',
);

void main() {
  group('WatchlistItem', () {
    test('statut par défaut est À voir', () {
      final item = WatchlistItem(serie: testSerie1);

      expect(item.statut, StatutVisionnage.aVoir);
      expect(item.statut.label, 'À voir');
    });

    test('toJson / fromJson conservent la série et le statut', () {
      final original = WatchlistItem(
        serie: testSerie1,
        statut: StatutVisionnage.enCours,
      );

      final reconstruit = WatchlistItem.fromJson(original.toJson());

      expect(reconstruit.serie.id, testSerie1.id);
      expect(reconstruit.serie.nom, testSerie1.nom);
      expect(reconstruit.statut, StatutVisionnage.enCours);
    });

    test('les labels des statuts sont lisibles', () {
      expect(StatutVisionnage.aVoir.label, 'À voir');
      expect(StatutVisionnage.enCours.label, 'En cours');
      expect(StatutVisionnage.vu.label, 'Vu');
    });
  });
}
