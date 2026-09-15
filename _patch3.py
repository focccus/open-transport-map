from pathlib import Path

p = Path('open_transport_map_flutter/lib/screens/vehicle_map_screen.dart')
lines = p.read_text(encoding='utf-8').splitlines()

# Replace the per-marker annotation helpers (_addSymbol ... _updateSymbolSafe)
# with the source-based marker layer setup.
start = next(
    n for n, l in enumerate(lines) if l.startswith('  Future<void> _addSymbol(')
)
end = next(
    n
    for n, l in enumerate(lines)
    if l.strip() == '}' and 'updateSymbol failed' in lines[n - 1]
)
assert end > start, (start, end)

replacement = '''  /// Adds the marker source and its two data-driven symbol layers.
  ///
  /// Everything that used to be a per-marker annotation property (rotation,
  /// colour, label, glyph) is a feature property here, so one source update
  /// moves every marker and the GPU does the rest.
  Future<void> _setupMarkerLayers(MapLibreMapController controller) async {
    await controller.addSource(
      _markerSourceId,
      GeojsonSourceProperties(data: _markerFeatureCollection()),
    );
    // The zoom swap is a layer bound, so nothing is created or destroyed while
    // the user zooms through the threshold.
    final minzoom = _markersMinZoom;
    await controller.addSymbolLayer(
      _markerSourceId,
      _markerLayerId,
      SymbolLayerProperties(
        iconImage: [Expressions.get, 'icon'],
        iconSize: _iconSize,
        iconRotate: [Expressions.get, 'rotate'],
        iconColor: [Expressions.get, 'color'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
        textField: [Expressions.get, 'label'],
        textColor: [Expressions.get, 'textColor'],
        textSize: [Expressions.get, 'textSize'],
        textOffset: [Expressions.get, 'textOffset'],
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ),
      minzoom: minzoom,
    );
    // Train pictogram on its own layer: no `iconRotate`, so the glyph stays
    // upright while the arrow underneath marks the heading.
    await controller.addSymbolLayer(
      _markerSourceId,
      _markerGlyphLayerId,
      SymbolLayerProperties(
        iconImage: _trainGlyphImageName,
        iconSize: _trainGlyphSize,
        iconColor: [Expressions.get, 'textColor'],
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
      ),
      filter: [
        '==',
        [Expressions.get, 'isTrain'],
        1,
      ],
      minzoom: minzoom,
    );
  }'''

lines[start : end + 1] = replacement.splitlines()
p.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('replaced annotation helpers with marker layers')
