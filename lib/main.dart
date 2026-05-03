import 'package:flutter/material.dart';
import './core/routing/app_router.dart';

void main() {
  runApp(const Menesha());
}

class Menesha extends StatelessWidget {
  const Menesha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Menesha',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
