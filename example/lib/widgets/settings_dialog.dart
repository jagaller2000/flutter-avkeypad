import 'package:flutter/material.dart';
import '../models/demo_settings.dart';

/// Settings dialog for customizing the demo app appearance
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key, required this.settings});

  final DemoSettings settings;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Demo Settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Section
            Text(
              'Theme Mode',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ThemeMode>(
              value: widget.settings.themeMode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: DemoSettings.availableThemeModes
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Row(
                        children: [
                          Icon(_getThemeModeIcon(mode)),
                          const SizedBox(width: 8),
                          Text(widget.settings.getThemeModeDisplayName(mode)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (mode) {
                if (mode != null) {
                  widget.settings.setThemeMode(mode);
                }
              },
            ),

            const SizedBox(height: 24),

            // Visual Density Section
            Text(
              'Visual Density',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<VisualDensity>(
              value: widget.settings.visualDensity,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: DemoSettings.availableVisualDensities
                  .map(
                    (density) => DropdownMenuItem(
                      value: density,
                      child: Row(
                        children: [
                          Icon(_getVisualDensityIcon(density)),
                          const SizedBox(width: 8),
                          Text(
                            widget.settings.getVisualDensityDisplayName(
                              density,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (density) {
                if (density != null) {
                  widget.settings.setVisualDensity(density);
                }
              },
            ),

            const SizedBox(height: 24),

            // Text Scale Factor Section
            Text(
              'Text Scale Factor',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: widget.settings.textScaleFactor,
                    min: 0.5,
                    max: 3.0,
                    divisions: 25,
                    label:
                        '${widget.settings.textScaleFactor.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      widget.settings.setTextScaleFactor(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${widget.settings.textScaleFactor.toStringAsFixed(1)}x',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Quick preset buttons for text scale
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: DemoSettings.availableTextScaleFactors
                  .map(
                    (factor) => FilterChip(
                      label: Text('${factor}x'),
                      selected:
                          (widget.settings.textScaleFactor - factor).abs() <
                          0.01,
                      onSelected: (_) {
                        widget.settings.setTextScaleFactor(factor);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  IconData _getVisualDensityIcon(VisualDensity density) {
    if (density == VisualDensity.compact) return Icons.compress;
    if (density == VisualDensity.comfortable) return Icons.expand;
    if (density == VisualDensity.standard) return Icons.crop_square;
    return Icons.crop_square; // Default
  }
}
