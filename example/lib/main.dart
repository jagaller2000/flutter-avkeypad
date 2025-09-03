import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'models/demo_settings.dart';
import 'extensions/extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final DemoSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = DemoSettings();
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVKeypad Demo',
      themeMode: _settings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: _settings.visualDensity,
        textTheme: ThemeData.light().textTheme.withCustomFonts,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        visualDensity: _settings.visualDensity,
        textTheme: ThemeData.dark().textTheme.withCustomFonts,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(_settings.textScaleFactor)),
          child: child!,
        );
      },
      home: KeypadDemoTabs(settings: _settings),
    );
  }
}
