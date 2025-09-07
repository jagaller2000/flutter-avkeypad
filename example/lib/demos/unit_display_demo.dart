import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../widgets/keypad_demo_base.dart';

/// Unit display demo showing keypad with units
class UnitDisplayDemo extends KeypadDemoPage {
  const UnitDisplayDemo({super.key});

  @override
  State<UnitDisplayDemo> createState() => _UnitDisplayDemoState();
}

class _UnitDisplayDemoState extends KeypadDemoPageState<UnitDisplayDemo> {
  String _selectedUnit = 'km';
  final List<String> _availableUnits = ['km', 'kg', '°C', '\$', '%', 'm/s'];

  @override
  Widget build(BuildContext context) {
    return buildKeypadDemo(
      context: context,
      title: 'Unit Display',
      description:
          'Keypad with unit display. The selected unit will be shown '
          'alongside the input value. Change the unit using the dropdown below.',
      config: KeypadConfig(
        showDecimalKey: true,
        showSignKey: true,
        allowNegative: true,
        maxDigits: 6,
        maxDecimalPlaces: 2,
        unit: _selectedUnit,
      ),
      customControls: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unit: '),
              DropdownButton<String>(
                value: _selectedUnit,
                items: _availableUnits.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedUnit = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}