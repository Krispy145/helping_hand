import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Defines the router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Screen')),
        ),
        routes: [
          GoRoute(
            path: 'requests/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Scaffold(
                appBar: AppBar(title: Text('Request $id')),
                body: Center(child: Text('Details for Request #$id')),
              );
            },
          ),
        ],
      ),
    ],
  );
});
