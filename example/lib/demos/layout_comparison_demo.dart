import 'package:flutter/material.dart';
import 'package:avkeypad/avkeypad.dart';
import '../constants/demo_design_constants.dart';

/// Demo comparing traditional vs compact keypad layouts
class LayoutComparisonDemo extends StatefulWidget {
  const LayoutComparisonDemo({super.key});

  @override
  State<LayoutComparisonDemo> createState() => _LayoutComparisonDemoState();
}

class _LayoutComparisonDemoState extends State<LayoutComparisonDemo> {
  String _traditionalValue = '';
  String _compactValue = '';
  double? _traditionalConfirmed;
  double? _compactConfirmed;
  String _traditionalMessage = 'Ready for input';
  String _compactMessage = 'Ready for input';

  // Create adapter for compact keypad
  final _compactAdapter = CompactKeypadAdapter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualDensity = theme.visualDensity;
    final densityAdjustment = visualDensity.baseSizeAdjustment;

    final effectivePadding = DemoDesignConstants.getEffectiveDemoPadding(
      densityAdjustment.dx,
    );
    final effectiveSpacing = DemoDesignConstants.getEffectiveDemoSpacing(
      densityAdjustment.dx,
    );
    final effectiveSmallSpacing =
        DemoDesignConstants.getEffectiveDemoSmallSpacing(densityAdjustment.dx);

    return Padding(
      padding: EdgeInsets.all(effectivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          Card(
            child: Padding(
              padding: EdgeInsets.all(effectivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layout Comparison',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: effectiveSmallSpacing),
                  Text(
                    'Compare the Traditional layout (action buttons in separate bottom row) '
                    'with the Compact layout (action buttons integrated within the digit grid). '
                    'Both keypads have identical functionality but different visual organization.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: effectiveSpacing),

          // Comparison view
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use different layouts based on available width
                if (constraints.maxWidth > 800) {
                  // Side-by-side layout for wide screens
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTraditionalKeypad(
                          theme,
                          effectivePadding,
                          effectiveSpacing,
                          effectiveSmallSpacing,
                        ),
                      ),
                      SizedBox(width: effectiveSpacing),
                      Expanded(
                        child: _buildCompactKeypad(
                          theme,
                          effectivePadding,
                          effectiveSpacing,
                          effectiveSmallSpacing,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Stacked layout for narrow screens
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTraditionalKeypad(
                          theme,
                          effectivePadding,
                          effectiveSpacing,
                          effectiveSmallSpacing,
                        ),
                        SizedBox(height: effectiveSpacing),
                        _buildCompactKeypad(
                          theme,
                          effectivePadding,
                          effectiveSpacing,
                          effectiveSmallSpacing,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraditionalKeypad(
    ThemeData theme,
    double effectivePadding,
    double effectiveSpacing,
    double effectiveSmallSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Row(
              children: [
                Icon(
                  Icons.grid_view,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                SizedBox(width: effectiveSmallSpacing),
                Text(
                  'Traditional Layout',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: effectiveSmallSpacing),

        // Status
        Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $_traditionalMessage'),
                if (_traditionalConfirmed != null) ...[
                  SizedBox(height: effectiveSmallSpacing / 2),
                  Text(
                    'Confirmed: $_traditionalConfirmed',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: effectiveSmallSpacing),

        // Traditional Keypad
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TraditionalKeypadWidget(
                config: const KeypadConfig(
                  showDecimalKey: true,
                  showSignKey: true,
                  showClearKey: true,
                  showBackspaceKey: true,
                  showConfirmKey: true,
                  showCancelKey: true,
                ),
                onValueChanged: (value) {
                  setState(() {
                    _traditionalValue = value;
                    _traditionalMessage = 'Current: $_traditionalValue';
                  });
                },
                onConfirm: (value) {
                  final numValue = double.tryParse(value);
                  setState(() {
                    _traditionalConfirmed = numValue;
                    _traditionalMessage =
                        'Confirmed: ${numValue?.toString() ?? 'Invalid'}';
                  });
                },
                onCancel: () {
                  setState(() {
                    _traditionalValue = '';
                    _traditionalConfirmed = null;
                    _traditionalMessage = 'Cancelled - Ready for input';
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactKeypad(
    ThemeData theme,
    double effectivePadding,
    double effectiveSpacing,
    double effectiveSmallSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Card(
          color: theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Row(
              children: [
                Icon(Icons.apps, color: theme.colorScheme.onSecondaryContainer),
                SizedBox(width: effectiveSmallSpacing),
                Text(
                  'Compact Layout',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: effectiveSmallSpacing),

        // Status
        Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $_compactMessage'),
                if (_compactConfirmed != null) ...[
                  SizedBox(height: effectiveSmallSpacing / 2),
                  Text(
                    'Confirmed: $_compactConfirmed',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: effectiveSmallSpacing),

        // Compact Keypad
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: CompactKeypadWidget(
                keypadPort: _compactAdapter,
                currentValue: _compactValue,
                config: const KeypadConfig(
                  showDecimalKey: true,
                  showSignKey: true,
                  showClearKey: true,
                  showBackspaceKey: true,
                  showConfirmKey: true,
                  showCancelKey: true,
                ),
                onKeyPressed: (key) {
                  // Handle different key types
                  switch (key.type) {
                    case KeypadKeyType.digit:
                      setState(() {
                        _compactValue += key.value;
                        _compactMessage = 'Current: $_compactValue';
                      });
                      break;
                    case KeypadKeyType.decimal:
                      if (!_compactValue.contains('.')) {
                        setState(() {
                          _compactValue += key.value;
                          _compactMessage = 'Current: $_compactValue';
                        });
                      }
                      break;
                    case KeypadKeyType.backspace:
                      if (_compactValue.isNotEmpty) {
                        setState(() {
                          _compactValue = _compactValue.substring(
                            0,
                            _compactValue.length - 1,
                          );
                          _compactMessage = 'Current: $_compactValue';
                        });
                      }
                      break;
                    case KeypadKeyType.clear:
                      setState(() {
                        _compactValue = '';
                        _compactMessage = 'Cleared - Ready for input';
                      });
                      break;
                    case KeypadKeyType.sign:
                      if (_compactValue.isNotEmpty) {
                        setState(() {
                          if (_compactValue.startsWith('-')) {
                            _compactValue = _compactValue.substring(1);
                          } else {
                            _compactValue = '-$_compactValue';
                          }
                          _compactMessage = 'Current: $_compactValue';
                        });
                      }
                      break;
                    case KeypadKeyType.confirm:
                      final numValue = double.tryParse(_compactValue);
                      setState(() {
                        _compactConfirmed = numValue;
                        _compactMessage =
                            'Confirmed: ${numValue?.toString() ?? 'Invalid'}';
                      });
                      break;
                    case KeypadKeyType.cancel:
                      setState(() {
                        _compactValue = '';
                        _compactConfirmed = null;
                        _compactMessage = 'Cancelled - Ready for input';
                      });
                      break;
                    case KeypadKeyType.custom:
                      // Handle custom keys if needed
                      break;
                  }
                },
                onValueChanged: (value) {
                  setState(() {
                    _compactValue = value;
                    _compactMessage = 'Current: $_compactValue';
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
