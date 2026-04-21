import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/debugger_screen.dart';

void main() {
  runApp(const ProviderScope(child: AIVideoEngineApp()));
}

class AIVideoEngineApp extends StatelessWidget {
  const AIVideoEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Video Engine',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // Gold
          secondary: Color(0xFF1E1E1E), // Matte Black
        ),
        useMaterial3: true,
      ),
      home: const DebuggerScreen(),
    );
  }
}
