import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/favoris_provider.dart';
import '../providers/serie_provider.dart';

class SerieListScreen extends StatefulWidget {
  const SerieListScreen({super.key});

  @override
  State<SerieListScreen> createState() => _SerieListScreenState();
}

class _SerieListScreenState extends State<SerieListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SerieProvider>().fetchSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Série Liste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.go('/favoris'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => context.go('/watchlist'),
          ),
        ],
      ),
      body: Consumer<SerieProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return ListView.builder(
            itemCount: provider.series.length,
            itemBuilder: (context, index) {
              final serie = provider.series[index];

              return ListTile(
                leading: serie.imageUrl != null
                    ? Image.network(
                        serie.imageUrl!,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.tv),
                title: Text(serie.nom),
                subtitle: Text('${serie.genre} · ${serie.statut}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (serie.note != null)
                      Text('★ ${serie.note!.toStringAsFixed(1)}'),
                    const SizedBox(width: 8),
                    Consumer<FavorisProvider>(
                      builder: (context, favorisProvider, _) {
                        final estFavori = favorisProvider.estFavori(serie.id);

                        return IconButton(
                          tooltip: estFavori
                              ? 'Retirer des favoris'
                              : 'Ajouter aux favoris',
                          icon: Icon(
                            estFavori
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: estFavori ? Colors.red : null,
                          ),
                          onPressed: () {
                            favorisProvider.toggleFavori(serie);
                          },
                        );
                      },
                    ),
                  ],
                ),
                onTap: () => context.go('/serie/${serie.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
