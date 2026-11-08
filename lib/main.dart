import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      title: 'My Page',

      // Dynamically select the application theme.
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),

      home: MyPage(
        isDarkMode: _isDarkMode,
        updateTheme: _updateTheme,
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> updateTheme;

  const MyPage({
    super.key,
    required this.isDarkMode,
    required this.updateTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Center(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle application theme'),
              value: isDarkMode,
              onChanged: updateTheme,
            ),
            NotesSection(),
          ]
        ),
      )
    );
  }
}


