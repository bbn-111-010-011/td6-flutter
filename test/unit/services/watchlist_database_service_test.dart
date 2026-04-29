import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:td6/models/serie.dart';
import 'package:td6/models/watchlist_item.dart';
import 'package:td6/services/watchlist_database_service.dart';

const testSerie1 = Serie(
  id: 1,
  nom: 'Breaking Bad',
  synopsis: 'A chemistry teacher diagnosed with cancer turns to crime.',
  genre: 'Drama',
  imageUrl: 'https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg',
  note: 9.3,
  statut: 'Ended',
);

const testSerie2 = Serie(
  id: 2,
  nom: 'Stranger Things',
  synopsis: 'Kids face supernatural mysteries in Hawkins.',
  genre: 'Science-Fiction',
  imageUrl: 'https://static.tvmaze.com/uploads/images/medium_portrait/200/501942.jpg',
  note: 8.7,
  statut: 'Running',
);

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WatchlistDatabaseService', () {
    late WatchlistDatabaseService service;

    setUp(() {
      service = WatchlistDatabaseService(databasePath: inMemoryDatabasePath);
    });

    tearDown(() async {
      await service.close();
    });

    test('getWatchlist retourne une liste vide au départ', () async {
      final items = await service.getWatchlist();

      expect(items, isEmpty);
    });

    test('saveWatchlist puis getWatchlist retourne les items sauvegardés', () async {
      await service.saveWatchlist([
        WatchlistItem(serie: testSerie1, statut: StatutVisionnage.aVoir),
        WatchlistItem(serie: testSerie2, statut: StatutVisionnage.enCours),
      ]);

      final loaded = await service.getWatchlist();

      expect(loaded.length, 2);
      expect(loaded[0].serie.nom, 'Breaking Bad');
      expect(loaded[0].statut, StatutVisionnage.aVoir);
      expect(loaded[1].serie.nom, 'Stranger Things');
      expect(loaded[1].statut, StatutVisionnage.enCours);
    });

    test('clearWatchlist vide la base', () async {
      await service.saveWatchlist([
        WatchlistItem(serie: testSerie1),
      ]);

      await service.clearWatchlist();
      final loaded = await service.getWatchlist();

      expect(loaded, isEmpty);
    });
  });
}
