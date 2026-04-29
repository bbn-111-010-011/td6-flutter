Patch de tests TD6

Copier le dossier test/ dans le vrai projet Flutter.

Attention : ces tests utilisent le nom de package du pubspec.yaml fourni : td6.
Si ton pubspec.yaml contient un autre nom, remplace les imports package:td6/... par package:<nom_du_projet>/...

Commandes :
flutter pub get
flutter test test/unit/models/watchlist_item_test.dart
flutter test test/unit/services/watchlist_database_service_test.dart
flutter test test/unit/providers/watchlist_provider_test.dart
