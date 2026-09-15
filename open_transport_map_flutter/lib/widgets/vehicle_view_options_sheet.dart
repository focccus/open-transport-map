import 'package:flutter/material.dart';

import '../models/vehicle_view_options.dart';

/// Opens the map's view options sheet.
///
/// [onChanged] fires on every change so the map updates behind the sheet.
Future<void> showVehicleViewOptionsSheet(
  BuildContext context, {
  required VehicleViewOptions options,
  required ValueChanged<VehicleViewOptions> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) =>
        _VehicleViewOptionsSheet(options: options, onChanged: onChanged),
  );
}

class _VehicleViewOptionsSheet extends StatefulWidget {
  const _VehicleViewOptionsSheet({
    required this.options,
    required this.onChanged,
  });

  final VehicleViewOptions options;
  final ValueChanged<VehicleViewOptions> onChanged;

  @override
  State<_VehicleViewOptionsSheet> createState() =>
      _VehicleViewOptionsSheetState();
}

class _VehicleViewOptionsSheetState extends State<_VehicleViewOptionsSheet> {
  late VehicleViewOptions _options = widget.options;

  /// Commit a change to the map. Sliders call this on release only, so the
  /// cluster layers are not rebuilt on every drag frame.
  void _commit(VehicleViewOptions next) => widget.onChanged(next);

  void _preview(VehicleViewOptions next) => setState(() => _options = next);

  void _reset() {
    const defaults = VehicleViewOptions();
    _preview(defaults);
    _commit(defaults);
  }

  void _setAllKinds(bool enabled) {
    final next = VehicleViewOptions(
      kinds: enabled
          ? {for (final kind in VehicleKind.values) kind}
          : const <VehicleKind>{},
      clustering: _options.clustering,
      clusterMinPoints: _options.clusterMinPoints,
      animations: _options.animations,
      animationZoom: _options.animationZoom,
    );
    _preview(next);
    _commit(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'View options',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                TextButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),

            _SectionHeader(
              'Vehicles',
              trailing: Row(
                children: [
                  TextButton(
                    onPressed: () => _setAllKinds(true),
                    child: const Text('All'),
                  ),
                  TextButton(
                    onPressed: () => _setAllKinds(false),
                    child: const Text('None'),
                  ),
                ],
              ),
            ),
            for (final kind in VehicleKind.values)
              SwitchListTile(
                dense: true,
                secondary: Icon(kind.icon),
                title: Text(kind.label),
                value: _options.showsKind(kind),
                onChanged: (enabled) {
                  final next = _options.withKind(kind, enabled);
                  _preview(next);
                  _commit(next);
                },
              ),

            const Divider(height: 24),
            _SectionHeader('Clustering'),
            SwitchListTile(
              dense: true,
              secondary: const Icon(Icons.scatter_plot),
              title: const Text('Cluster nearby vehicles'),
              subtitle: const Text('Off shows every vehicle as its own dot'),
              value: _options.clustering,
              onChanged: (enabled) {
                final next = _options.copyWith(clustering: enabled);
                _preview(next);
                _commit(next);
              },
            ),
            _SliderTile(
              label: 'Fewest vehicles to cluster',
              value: '${_options.clusterMinPoints}',
              enabled: _options.clustering,
              slider: Slider(
                min: VehicleViewOptions.minClusterMinPoints.toDouble(),
                max: VehicleViewOptions.maxClusterMinPoints.toDouble(),
                divisions:
                    VehicleViewOptions.maxClusterMinPoints -
                    VehicleViewOptions.minClusterMinPoints,
                label: '${_options.clusterMinPoints}',
                value: _options.clusterMinPoints.toDouble(),
                onChanged: _options.clustering
                    ? (value) => _preview(
                        _options.copyWith(clusterMinPoints: value.round()),
                      )
                    : null,
                onChangeEnd: _options.clustering
                    ? (value) => _commit(
                        _options.copyWith(clusterMinPoints: value.round()),
                      )
                    : null,
              ),
            ),

            const Divider(height: 24),
            _SectionHeader('Animations'),
            SwitchListTile(
              dense: true,
              secondary: const Icon(Icons.play_circle_outline),
              title: const Text('Animate markers'),
              subtitle: const Text('Off keeps plain dots at every zoom'),
              value: _options.animations,
              onChanged: (enabled) {
                final next = _options.copyWith(animations: enabled);
                _preview(next);
                _commit(next);
              },
            ),
            _SliderTile(
              label: 'Markers take over at zoom',
              value: _options.animationZoom.toStringAsFixed(1),
              enabled: _options.animations,
              slider: Slider(
                min: VehicleViewOptions.minAnimationZoom,
                max: VehicleViewOptions.maxAnimationZoom,
                divisions: 16,
                label: _options.animationZoom.toStringAsFixed(1),
                value: _options.animationZoom,
                onChanged: _options.animations
                    ? (value) => _preview(
                        _options.copyWith(animationZoom: value),
                      )
                    : null,
                onChangeEnd: _options.animations
                    ? (value) => _commit(
                        _options.copyWith(animationZoom: value),
                      )
                    : null,
              ),
            ),
            _SliderTile(
              label: 'Animated vehicles shown',
              value: '${_options.maxAnimatedVehicles}',
              enabled: _options.animations,
              slider: Slider(
                min: VehicleViewOptions.minAnimatedVehiclesLimit.toDouble(),
                max: VehicleViewOptions.maxAnimatedVehiclesLimit.toDouble(),
                // Steps of 5, so the value always lands on a round number.
                divisions: 399,
                label: '${_options.maxAnimatedVehicles}',
                value: _options.maxAnimatedVehicles.toDouble(),
                onChanged: _options.animations
                    ? (value) => _preview(
                        _options.copyWith(
                          maxAnimatedVehicles: value.round(),
                        ),
                      )
                    : null,
                onChangeEnd: _options.animations
                    ? (value) => _commit(
                        _options.copyWith(
                          maxAnimatedVehicles: value.round(),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.slider,
    required this.enabled,
  });

  final String label;
  final String value;
  final Widget slider;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(value, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          slider,
        ],
      ),
    );
  }
}
