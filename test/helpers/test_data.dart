import 'package:serie_liste/models/serie.dart';

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

final List<Map<String, dynamic>> mockSeriesJson = [
  {
    'id': 1,
    'name': 'Breaking Bad',
    'summary': '<p>A chemistry teacher diagnosed with cancer turns to crime.</p>',
    'genres': ['Drama', 'Crime', 'Thriller'],
    'image': {
      'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg',
    },
    'rating': {'average': 9.3},
    'status': 'Ended',
  },
  {
    'id': 2,
    'name': 'Stranger Things',
    'summary': '<p>Kids face <b>supernatural</b> mysteries in Hawkins.</p>',
    'genres': ['Science-Fiction', 'Horror', 'Drama'],
    'image': {
      'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/200/501942.jpg',
    },
    'rating': {'average': 8.7},
    'status': 'Running',
  },
];

final Map<String, dynamic> mockInternalSerieJson = {
  'id': 10,
  'nom': 'Série interne',
  'synopsis': 'Résumé sauvegardé localement.',
  'genre': 'Comédie',
  'imageUrl': null,
  'note': 7.5,
  'statut': 'Ended',
};
