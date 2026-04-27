import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/serie.dart';

class SerieApiService {
  static const _baseUrl = 'https://api.tvmaze.com';
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;

  /// Le client HTTP est injecté :
  /// - production : http.Client()
  /// - tests : MockHttpClient
  SerieApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Serie>> fetchSeries({int page = 0}) async {
    final uri = Uri.parse('$_baseUrl/shows?page=$page');
    final response = await _client.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((j) => Serie.fromJson(j as Map<String, dynamic>)).toList();
    }

    throw Exception('Erreur HTTP ${response.statusCode}');
  }

  Future<Serie> fetchSerieById(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id');
    final response = await _client.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {
      return Serie.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Série $id introuvable');
  }

  /// Données de secours affichées si le réseau est indisponible.
  List<Serie> getMockSeries() => [
        const Serie(
          id: 0,
          nom: 'Mode hors-ligne',
          synopsis: 'Pas de connexion réseau.',
          genre: '-',
          statut: '-',
        ),
      ];
}
