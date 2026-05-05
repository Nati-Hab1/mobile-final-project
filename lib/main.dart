import 'package:flutter/material.dart';
import 'package:menesha/core/routing/app_router.dart';

void main() {
  runApp(const MeneshaApp());
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
