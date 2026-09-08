import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/psk_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const PskStudentApp(),
    ),
  );
}

class PskStudentApp extends StatelessWidget {
  const PskStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSK — Prva Sportska Kladionica | Student & Youth Hub',
      debugShowCheckedModeBanner: false,
      theme: PskTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
