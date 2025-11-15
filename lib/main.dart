import 'package:flutter/material.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/authentication_controller.dart';
import 'package:landsteam/controllers/property_controller.dart';
import 'package:landsteam/screens/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  Supabase.initialize(url: supabaseURL, anonKey: supabaseAnonkey)
      .then((value) {
        // print('Supabase initialized successfully');
      })
      .catchError((error) {
        // print('Error initializing Supabase: $error');
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PropertyController()),
        ChangeNotifierProvider(create: (context) => AuthenticationController()),
      ],
      child: MaterialApp(
        title: 'Real Estate App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
