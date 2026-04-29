import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:td6/models/serie.dart';
import 'package:td6/models/watchlist_item.dart';
import 'package:td6/providers/watchlist_provider.dart';
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

Future<WatchlistProvider> createProvider() async {
  final dbService = WatchlistDatabaseService(databasePath: inMemoryDatabasePath);
  final provider = WatchlistProvider(dbService: dbService);

  // Le constructeur charge la watchlist de façon asynchrone.
  await Future<void>.delayed(const Duration(milliseconds: 100));

  return provider;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('WatchlistProvider', () {
    test('état initial : watchlist vide', () async {
      final provider = await createProvider();

      expect(provider.isLoading, isFalse);
      expect(provider.items, isEmpty);
      expect(provider.itemCount, 0);
    });

    test('ajouterASerie ajoute une série et évite les doublons', () async {
      final provider = await createProvider();

      await provider.ajouterASerie(testSerie1);
      await provider.ajouterASerie(testSerie1);

      expect(provider.itemCount, 1);
      expect(provider.estDansWatchlist(testSerie1.id), isTrue);
      expect(provider.getStatut(testSerie1.id), StatutVisionnage.aVoir);
    });

    test('changerStatut puis retirerSerie modifient correctement la watchlist', () async {
      final provider = await createProvider();

      await provider.ajouterASerie(testSerie1);
      await provider.ajouterASerie(testSerie2);
      await provider.changerStatut(testSerie1.id, StatutVisionnage.vu);

      expect(provider.getStatut(testSerie1.id), StatutVisionnage.vu);
      expect(provider.itemCount, 2);

      await provider.retirerSerie(testSerie1.id);

      expect(provider.estDansWatchlist(testSerie1.id), isFalse);
      expect(provider.estDansWatchlist(testSerie2.id), isTrue);
      expect(provider.itemCount, 1);
    });
  });
}
