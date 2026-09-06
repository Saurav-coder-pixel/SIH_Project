import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const NookApp(),
    ),
  );
}

class NookApp extends StatelessWidget {
  const NookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nook — Hyperlocal Connection Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
