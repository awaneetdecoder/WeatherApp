import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main(){
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode=ThemeMode.light;
  
  void _toggleTheme(){
    setState(() {
      _themeMode=_themeMode==ThemeMode.light?ThemeMode.dark:ThemeMode.light;
    });
  } 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 165, 209, 254),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 63, 154, 200),
          foregroundColor: Colors.white,
        )
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 108, 112, 116),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 81, 80, 80),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
         surface: const Color(0xFF1E1E1E),
        ),
      ),
      themeMode: _themeMode,
      home: WeatherScreen(onThemeChange: _toggleTheme),
    );
  }
}
