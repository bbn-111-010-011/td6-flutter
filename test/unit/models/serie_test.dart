import 'package:flutter_test/flutter_test.dart';
import 'package:serie_liste/models/serie.dart';

import '../../helpers/test_data.dart';

void main() {
  group('Serie', () {
    test('fromJson construit une série depuis le format TVMaze', () {
      final serie = Serie.fromJson(mockSeriesJson[0]);

      expect(serie.id, 1);
      expect(serie.nom, 'Breaking Bad');
      expect(serie.synopsis, 'A chemistry teacher diagnosed with cancer turns to crime.');
      expect(serie.genre, 'Drama');
      expect(serie.imageUrl, isNotNull);
      expect(serie.note, 9.3);
      expect(serie.statut, 'Ended');
    });

    test('fromJson supprime les balises HTML du synopsis', () {
      final serie = Serie.fromJson(mockSeriesJson[1]);

      expect(serie.synopsis, 'Kids face supernatural mysteries in Hawkins.');
      expect(serie.synopsis.contains('<b>'), isFalse);
      expect(serie.synopsis.contains('</b>'), isFalse);
    });

    test('fromJson construit une série depuis le format interne', () {
      final serie = Serie.fromJson(mockInternalSerieJson);

      expect(serie.id, 10);
      expect(serie.nom, 'Série interne');
      expect(serie.synopsis, 'Résumé sauvegardé localement.');
      expect(serie.genre, 'Comédie');
      expect(serie.imageUrl, isNull);
      expect(serie.note, 7.5);
      expect(serie.statut, 'Ended');
    });

    test('toJson retourne le format interne attendu', () {
      final json = testSerie1.toJson();

      expect(json['id'], 1);
      expect(json['nom'], 'Breaking Bad');
      expect(json['synopsis'], testSerie1.synopsis);
      expect(json['genre'], 'Drama');
      expect(json['imageUrl'], testSerie1.imageUrl);
      expect(json['note'], 9.3);
      expect(json['statut'], 'Ended');
    });

    test('deux séries avec le même id sont égales', () {
      const serieA = Serie(
        id: 1,
        nom: 'Nom A',
        synopsis: 'Synopsis A',
        genre: 'Drama',
        statut: 'Running',
      );

      const serieB = Serie(
        id: 1,
        nom: 'Nom B',
        synopsis: 'Synopsis B',
        genre: 'Comedy',
        statut: 'Ended',
      );

      expect(serieA, equals(serieB));
      expect(serieA.hashCode, serieB.hashCode);
    });
  });
}
