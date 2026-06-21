import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeData get themeData =>
      isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  void toggleTheme(bool value) {
    isDarkMode = value;
    notifyListeners(); 
  }
}

class AppThemes {
  
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(249, 249, 242, 1),
    primaryColor: const Color.fromRGBO(0, 95, 107, 1),
    secondaryHeaderColor: Color.fromRGBO(45,52, 54, 1),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color.fromRGBO(0, 95, 107, 1),
    ),

    
bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromRGBO(255, 127, 80, 1),
      unselectedItemColor: const Color.fromRGBO(45, 52, 54, 1),

    ),


    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(0, 206, 209, 1),
      secondary: Color.fromRGBO(0, 95, 107, 1),     
    
),
  );

  // 🌙 DARK MODE (custom fishing/ocean theme)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromRGBO(11, 18, 30, 1),
    primaryColor: const Color.fromRGBO(22, 31, 44, 1),
    secondaryHeaderColor: Color.fromRGBO(224, 230, 237, 1),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(15, 30, 45, 1),
      foregroundColor: Color.fromRGBO(0, 206, 209, 1),
      
    ),
    

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(22, 31, 44, 1),
      selectedItemColor: Color.fromRGBO(0, 206, 209, 1),
      unselectedItemColor: Color.fromRGBO(84, 95, 114, 1),
    ),


    colorScheme: const ColorScheme.dark(
  primary: Color.fromRGBO(255, 127, 80, 1),
  secondary: Color.fromRGBO(0, 206, 209, 1),
),
  );
}