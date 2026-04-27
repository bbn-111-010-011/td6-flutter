import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'SérieListe — TD6 réalisé jusqu\'à la partie 3.4 Tests du Provider',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  ],
);
