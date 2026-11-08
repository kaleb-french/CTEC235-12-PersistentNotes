import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _StockAppState();
}

class _StockAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _updateTheme(bool newValue) async {
    setState(() {
      _isDarkMode = newValue;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Tracker',

      // Dynamically select the application theme.
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),

      home: StockPage(
        isDarkMode: _isDarkMode,
        updateTheme: _updateTheme,
      ),
    );
  }
}

class StockPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> updateTheme;

  const StockPage({
    super.key,
    required this.isDarkMode,
    required this.updateTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Toggle application theme'),
          value: isDarkMode,
          onChanged: updateTheme,
        ),
      ),
    );
  }
}
