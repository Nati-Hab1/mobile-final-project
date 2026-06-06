import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menesha/core/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MeneshaApp(), // ← Use 'child:' parameter
    ),
  );
}

class MeneshaApp extends StatelessWidget {
  const MeneshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Menesha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      routerConfig: appRouter,
    );
  }
}
