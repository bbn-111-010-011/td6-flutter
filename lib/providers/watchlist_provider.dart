import 'package:flutter/material.dart';

import '../models/serie.dart';
import '../models/watchlist_item.dart';
import '../services/watchlist_database_service.dart';

class WatchlistProvider with ChangeNotifier {
  final WatchlistDatabaseService _dbService;

  List<WatchlistItem> _items = [];
  bool _isLoading = false;

  List<WatchlistItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;

  /// Injection de dépendance :
  /// - production : WatchlistProvider() utilise WatchlistDatabaseService réel
  /// - tests : WatchlistProvider(dbService: serviceEnMemoire)
  WatchlistProvider({WatchlistDatabaseService? dbService})
      : _dbService = dbService ?? WatchlistDatabaseService() {
    _chargerWatchlist();
  }

  Future<void> _chargerWatchlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _dbService.getWatchlist();
    } catch (_) {
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> ajouterASerie(Serie serie) async {
    if (estDansWatchlist(serie.id)) return;

    _items.add(WatchlistItem(serie: serie));
    await _dbService.saveWatchlist(_items);
    notifyListeners();
  }

  Future<void> retirerSerie(int serieId) async {
    _items.removeWhere((item) => item.serie.id == serieId);
    await _dbService.saveWatchlist(_items);
    notifyListeners();
  }

  Future<void> changerStatut(int serieId, StatutVisionnage statut) async {
    final index = _items.indexWhere((item) => item.serie.id == serieId);

    if (index < 0) return;

    _items[index].statut = statut;
    await _dbService.saveWatchlist(_items);
    notifyListeners();
  }

  bool estDansWatchlist(int serieId) {
    return _items.any((item) => item.serie.id == serieId);
  }

  StatutVisionnage? getStatut(int serieId) {
    final index = _items.indexWhere((item) => item.serie.id == serieId);
    return index >= 0 ? _items[index].statut : null;
  }
}
