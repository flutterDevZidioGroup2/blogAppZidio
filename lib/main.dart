import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AuthPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iufnzcylgsnvuictmzmu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1Zm56Y3lsZ3NudnVpY3Rtem11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQxNjEwNDksImV4cCI6MjAzOTczNzA0OX0.EZApkXj9Xb8uAHef4zmpVN0iKxOXoPZssddXku6oiOY',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(),
    );
  }
}
