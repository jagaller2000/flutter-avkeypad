import 'package:flutter/material.dart';
import '../demos/demos.dart';
import '../models/demo_settings.dart';
import 'settings_dialog.dart';

/// Main screen with tabs for different keypad demos
class KeypadDemoTabs extends StatefulWidget {
  const KeypadDemoTabs({super.key, required this.settings});

  final DemoSettings settings;

  @override
  State<KeypadDemoTabs> createState() => _KeypadDemoTabsState();
}

class _KeypadDemoTabsState extends State<KeypadDemoTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVKeypad Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.looks_one), text: 'Basic'),
            Tab(icon: Icon(Icons.looks_two), text: 'Decimal'),
            Tab(icon: Icon(Icons.looks_3), text: 'Signed'),
            Tab(icon: Icon(Icons.looks_4), text: 'Limited'),
            Tab(icon: Icon(Icons.looks_5), text: 'Advanced'),
            Tab(icon: Icon(Icons.plus_one), text: 'Step 2'),
            Tab(icon: Icon(Icons.more_horiz), text: 'Step 0.1'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BasicKeypadDemo(),
          DecimalKeypadDemo(),
          SignedKeypadDemo(),
          LimitedKeypadDemo(),
          AdvancedKeypadDemo(),
          StepSize2KeypadDemo(),
          StepSizeDecimalKeypadDemo(),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => SettingsDialog(settings: widget.settings),
    );
  }
}
