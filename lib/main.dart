import 'package:flutter/material.dart';
import 'package:menesha/core/routing/app_router.dart';
import 'package:menesha/core/theme/app_theme.dart';

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
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
