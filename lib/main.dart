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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 79, 149, 184),
          foregroundColor: Colors.white,
        )
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        )
      ),
      themeMode: _themeMode,
      home: WeatherScreen(onThemeChange: _toggleTheme,),
    );
  }
}
