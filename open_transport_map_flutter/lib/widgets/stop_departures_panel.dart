import 'dart:async';

import 'package:flutter/gestures.dart'
    show PointerDeviceKind, PointerScrollEvent, PointerSignalEvent;
import 'package:flutter/material.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import 'transit_ui.dart';

/// Departures for one stop, rendered as a header plus a scrollable list.
///
/// Used docked on the right on wide layouts and inside a draggable bottom
/// sheet on narrow ones; the only difference is the [scrollController] the
/// sheet needs to drive its drag.
///
/// The list ticks once a second, so a departure flips to `now` and then drops
/// off on its own without waiting for the next server refresh.
///
/// Tapping a row opens that departure's journey timeline; see
/// [onOpenDeparture].
class StopDeparturesPanel extends StatefulWidget {
  const StopDeparturesPanel({
    super.key,
    required this.data,
    required this.loading,
    required this.error,
    required this.onClose,
    required this.onRefresh,
    this.onOpenDeparture,
    this.onOpenStopArea,
    this.nextStopFilter,
    this.onNextStopFilterChanged,
    this.scrollController,
  });

  final StopDeparturesResponse? data;
  final bool loading;
  final String? error;
  final VoidCallback onClose;
  final VoidCallback onRefresh;

  /// Called when a row is tapped, to show that departure's journey. Null (and
  /// on rows the upstream gave no details reference) leaves the row inert.
  final ValueChanged<DepartureItem>? onOpenDeparture;

  /// Called when the title is tapped to switch to the parent stop area's
  /// departures. Null when there is no parent (already an area, or unknown).
  final VoidCallback? onOpenStopArea;

  /// Next stop currently filtered on, or null for every line. The options come
  /// from [nextStopFilterOptions] once the journey details have arrived.
  final String? nextStopFilter;
  final ValueChanged<String?>? onNextStopFilterChanged;
  final ScrollController? scrollController;

  @override
  State<StopDeparturesPanel> createState() => _StopDeparturesPanelState();
}

class _StopDeparturesPanelState extends State<StopDeparturesPanel> {
  static const _tick = Duration(seconds: 1);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Drives the live countdown and the expiry filter below.
    _timer = Timer.periodic(_tick, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          data: widget.data,
          loading: widget.loading,
          onClose: widget.onClose,
          onRefresh: widget.onRefresh,
          onOpenStopArea: widget.onOpenStopArea,
        ),
        const Divider(height: 1),
        if (widget.loading && widget.data != null)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(child: _body(context)),
      ],
    );
  }

  Widget _body(BuildContext context) {
    final error = widget.error;
    if (error != null && widget.data == null) {
      return TransitMessage(
        icon: Icons.cloud_off,
        title: 'Could not load departures',
        detail: error,
        action: TextButton(
          onPressed: widget.onRefresh,
          child: const Text('Retry'),
        ),
      );
    }

    final response = widget.data;
    if (response == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Already-departed rows fall off once they are past the `now` window, even
    // before the next upstream refresh drops them.
    final cutoff = DateTime.now().subtract(departureNowWindow);
    final upcoming = [
      for (final departure in response.departures)
        if (_effectiveTime(departure).isAfter(cutoff)) departure,
    ];

    // The next stop of each line only arrives with the journey details, so this
    // is empty until the second stream event and the bar is simply absent.
    final options = nextStopFilterOptions(response);
    final selected = options.contains(widget.nextStopFilter)
        ? widget.nextStopFilter
        : null;
    final visible = [
      for (final departure in upcoming)
        if (selected == null || departure.nextStop == selected) departure,
    ];

    final Widget listing;
    if (visible.isEmpty) {
      listing = selected == null
          ? TransitMessage(
              icon: Icons.schedule,
              title: 'No upcoming departures',
              detail: response.stopName,
              action: TextButton(
                onPressed: widget.onRefresh,
                child: const Text('Refresh'),
              ),
            )
          : TransitMessage(
              icon: Icons.filter_alt_off,
              title: 'Nothing to $selected',
              detail: 'No upcoming departures head that way.',
              action: TextButton(
                onPressed: () => widget.onNextStopFilterChanged?.call(null),
                child: const Text('Clear filter'),
              ),
            );
    } else {
      listing = ListView.separated(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: visible.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
        itemBuilder: (context, index) => _DepartureTile(
          departure: visible[index],
          // A stop area aggregates platforms, so the platform is what tells the
          // rows apart. A single stop point makes it redundant.
          showPlatform: response.isStopArea,
          onOpen: widget.onOpenDeparture,
        ),
      );
    }

    if (options.isEmpty) return listing;
    return Column(
      children: [
        _NextStopFilterBar(
          options: options,
          selected: selected,
          onSelected: widget.onNextStopFilterChanged ?? (_) {},
        ),
        const Divider(height: 1),
        Expanded(child: listing),
      ],
    );
  }
}

/// Next stops worth offering as filter chips, sorted.
///
/// Empty unless the stop is served by at least two different lines that do not
/// all continue to the same place — one line, or one common next stop, makes
/// the filter pointless.
List<String> nextStopFilterOptions(StopDeparturesResponse data) {
  final lines = <String>{};
  final nextStops = <String>{};
  for (final departure in data.departures) {
    final nextStop = departure.nextStop;
    if (nextStop == null) continue;
    lines.add(departure.lineDesignation);
    nextStops.add(nextStop);
  }
  if (lines.length < 2 || nextStops.length < 2) return const [];
  return nextStops.toList()..sort();
}

/// Horizontal row of next-stop chips, with an `All` chip to clear the filter.
class _NextStopFilterBar extends StatefulWidget {
  const _NextStopFilterBar({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  State<_NextStopFilterBar> createState() => _NextStopFilterBarState();
}

class _NextStopFilterBarState extends State<_NextStopFilterBar> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// A vertical wheel does nothing on a horizontal strip, so map it across.
  /// Desktop pointers otherwise have no way to move the bar at all: Flutter
  /// leaves the mouse out of `dragDevices`, and horizontal wheels are rare.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) return;
    final position = _controller.position;
    final target = (position.pixels + event.scrollDelta.dy).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target != position.pixels) _controller.jumpTo(target);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        // Let a mouse drag the strip, the way touch already can.
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      child: Listener(
        onPointerSignal: _onPointerSignal,
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: widget.selected == null,
                onSelected: (_) => widget.onSelected(null),
              ),
              for (final option in widget.options) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  label: Text(option),
                  selected: widget.selected == option,
                  onSelected: (isSelected) =>
                      widget.onSelected(isSelected ? option : null),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.data,
    required this.loading,
    required this.onClose,
    required this.onRefresh,
    required this.onOpenStopArea,
  });

  final StopDeparturesResponse? data;
  final bool loading;
  final VoidCallback onClose;
  final VoidCallback onRefresh;
  final VoidCallback? onOpenStopArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final response = data;
    // A stop point names its own platform here; a stop area aggregates
    // platforms, so those are shown per row instead. The municipality is left
    // out: next to the stop name it is redundant.
    final subtitle =
        response != null && !response.isStopArea && response.platform != null
        ? 'Läge ${response.platform}'
        : '';

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                response?.stopName ?? 'Departures',
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onOpenStopArea != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.unfold_more,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.directions_transit, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: onOpenStopArea == null
                ? title
                : Tooltip(
                    message: 'Show stop area departures',
                    child: InkWell(
                      onTap: onOpenStopArea,
                      borderRadius: BorderRadius.circular(6),
                      child: title,
                    ),
                  ),
          ),
          IconButton(
            onPressed: loading ? null : onRefresh,
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Close',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _DepartureTile extends StatelessWidget {
  const _DepartureTile({
    required this.departure,
    required this.showPlatform,
    this.onOpen,
  });

  final DepartureItem departure;

  /// Whether the platform chip is drawn. Hidden for stop-area lists, where the
  /// rows come from several platforms at once.
  final bool showPlatform;

  /// Opens the journey timeline for this departure. Null when unavailable.
  final ValueChanged<DepartureItem>? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = parseLineColor(
      departure.backgroundColor,
      const Color(0xFF1D4ED8),
    );
    final foreground = parseLineColor(
      departure.foregroundColor,
      const Color(0xFFFFFFFF),
    );

    return InkWell(
      // Rows the upstream gave no details handle have no journey to open.
      onTap: onOpen == null ? null : () => onOpen!(departure),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineChip(
              label: departure.lineDesignation,
              background: background,
              foreground: foreground,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    departure.destination,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (departure.via != null ||
                      (showPlatform && departure.platform != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          if (showPlatform && departure.platform != null)
                            PlatformChip(label: departure.platform!),
                          if (departure.via != null &&
                              showPlatform &&
                              departure.platform != null)
                            const SizedBox(width: 6),
                          if (departure.via != null)
                            Flexible(
                              child: Text(
                                'via ${departure.via}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            DepartureTimeColumn(
              planned: departure.plannedTime,
              estimated: departure.estimatedTime,
              isCancelled: departure.isCancelled,
            ),
          ],
        ),
      ),
    );
  }
}

/// The time a departure is counted down against: the realtime estimate when
/// there is one, otherwise the timetable.
DateTime _effectiveTime(DepartureItem departure) =>
    departure.estimatedTime ?? departure.plannedTime;
