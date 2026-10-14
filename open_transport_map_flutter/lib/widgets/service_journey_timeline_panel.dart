import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_transport_map_client/open_transport_map_client.dart';

import 'transit_ui.dart';

/// One departure's journey as a live vertical timeline: the line and
/// destination in the header, then a row per call showing its stop, platform
/// and realtime time.
///
/// Shown in place of the departures list when a departure is tapped, in the
/// same bottom sheet or side panel, with a back button to return to the list.
///
/// The timeline reads as a live position:
/// - Calls whose time has gone by are greyed out and read `passed`; the line
///   keeps the neutral color behind the vehicle and takes the line's own color
///   from there on.
/// - A dot rides the connector between the stop the vehicle has left and the
///   one it is heading for, at the fraction of that leg the clock has reached.
/// - Calls already behind the vehicle are folded away, keeping
///   [_keptBeforeCurrent] of them as context, with a button to reveal the rest.
///
/// Calls tick once a second, and the caller refetches the journey on its own
/// clock, so the dot and the countdowns stay live.
class ServiceJourneyTimelinePanel extends StatefulWidget {
  const ServiceJourneyTimelinePanel({
    super.key,
    required this.departure,
    required this.calls,
    required this.loading,
    required this.error,
    required this.onBack,
    required this.onRefresh,
    this.scrollController,
  });

  /// The departure the timeline belongs to. Carries the line, destination and
  /// colors for the header and the timeline's own coloring.
  final DepartureItem departure;

  /// Ordered calls of its journey. Null until the first response arrives.
  final List<ServiceJourneyCall>? calls;
  final bool loading;
  final String? error;
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  final ScrollController? scrollController;

  @override
  State<ServiceJourneyTimelinePanel> createState() =>
      _ServiceJourneyTimelinePanelState();
}

class _ServiceJourneyTimelinePanelState
    extends State<ServiceJourneyTimelinePanel> {
  static const _tick = Duration(seconds: 1);

  /// Calls kept above the vehicle for context, so the list does not open right
  /// on the current position with nothing before it.
  static const _keptBeforeCurrent = 3;

  Timer? _timer;

  /// Whether the folded-away calls behind the vehicle are revealed.
  bool _showEarlier = false;

  @override
  void initState() {
    super.initState();
    // Moves the dot and flips calls to `passed` while the journey runs.
    _timer = Timer.periodic(_tick, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(ServiceJourneyTimelinePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A different journey always opens folded at its own live position.
    if (!identical(oldWidget.departure, widget.departure)) {
      _showEarlier = false;
    }
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
        _header(context),
        const Divider(height: 1),
        if (widget.loading && widget.calls != null)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(child: _body(context)),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final departure = widget.departure;
    final background = parseLineColor(
      departure.backgroundColor,
      const Color(0xFF1D4ED8),
    );
    final foreground = parseLineColor(
      departure.foregroundColor,
      const Color(0xFFFFFFFF),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: widget.onBack,
            tooltip: 'Back to departures',
            icon: const Icon(Icons.arrow_back),
          ),
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
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (departure.via != null)
                  Text(
                    'via ${departure.via}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.loading ? null : widget.onRefresh,
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final error = widget.error;
    if (error != null && widget.calls == null) {
      return TransitMessage(
        icon: Icons.cloud_off,
        title: 'Could not load the journey',
        detail: error,
        action: TextButton(
          onPressed: widget.onRefresh,
          child: const Text('Retry'),
        ),
      );
    }

    final response = widget.calls;
    if (response == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (response.isEmpty) {
      return TransitMessage(
        icon: Icons.schedule,
        title: 'No stops reported',
        detail: widget.departure.destination,
        action: TextButton(
          onPressed: widget.onRefresh,
          child: const Text('Refresh'),
        ),
      );
    }
    // The last call is often a bare repeat of the stop before it, or carries no
    // time to show. Either way it tells the user nothing, so it is left out.
    final calls = _withoutEmptyTerminus(response);

    final now = DateTime.now();
    final last = calls.length - 1;
    final passed = [
      for (var i = 0; i <= last; i++)
        switch (_callTime(calls[i], isLast: i == last)) {
          final time? => now.difference(time) > departureNowWindow,
          null => false,
        },
    ];

    // Last call the vehicle has left; it is on the way to the next one.
    var departed = -1;
    for (var i = 0; i <= last; i++) {
      if (passed[i]) departed = i;
    }
    final travelling = departed >= 0 && departed < last ? departed : null;
    final progress = travelling == null
        ? null
        : _progressToNext(calls, travelling, now);

    // Everything the vehicle has left behind, less the few kept for context,
    // is folded away so the timeline opens at the live position.
    final hidden = _showEarlier || departed < _keptBeforeCurrent
        ? 0
        : departed - _keptBeforeCurrent + 1;
    final names = _displayNames(calls);
    final lineColor = parseLineColor(
      widget.departure.backgroundColor,
      const Color(0xFF1D4ED8),
    );

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: calls.length - hidden + (hidden > 0 ? 1 : 0),
      itemBuilder: (context, index) {
        if (hidden > 0) {
          if (index == 0) return _earlierButton(hidden);
          index -= 1;
        }
        final callIndex = index + hidden;
        // The dot rides the connector halves on either side of the stop it is
        // between: the lower half of the stop it left, the upper half of the
        // stop it is heading for.
        double? vehicleAbove;
        double? vehicleBelow;
        if (travelling != null && progress != null) {
          if (callIndex == travelling && progress <= 0.5) {
            vehicleBelow = progress * 2;
          } else if (callIndex == travelling + 1 && progress > 0.5) {
            vehicleAbove = progress * 2 - 1;
          }
        }

        return _CallTile(
          call: calls[callIndex],
          name: names[callIndex],
          lineColor: lineColor,
          passed: passed[callIndex],
          // A leg of the line is behind the vehicle once the stop it leads to
          // has been passed.
          abovePassed: passed[callIndex],
          belowPassed: callIndex < last && passed[callIndex + 1],
          isFirst: callIndex == 0,
          isLast: callIndex == last,
          boarded:
              widget.departure.stopPointGid != null &&
              calls[callIndex].stopPointGid == widget.departure.stopPointGid,
          vehicleAbove: vehicleAbove,
          vehicleBelow: vehicleBelow,
        );
      },
    );
  }

  Widget _earlierButton(int hidden) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _showEarlier = true),
          icon: const Icon(Icons.unfold_more, size: 18),
          label: Text('View $hidden earlier ${hidden == 1 ? 'stop' : 'stops'}'),
        ),
      ),
    );
  }
}

/// The calls worth drawing: a trailing call that only repeats the stop before
/// it, or that has no time at all, is dropped.
List<ServiceJourneyCall> _withoutEmptyTerminus(
  List<ServiceJourneyCall> calls,
) {
  if (calls.length < 2) return calls;
  final terminus = calls.last;
  final previous = calls[calls.length - 2];
  final sameStop = terminus.stopPointGid.isNotEmpty
      ? terminus.stopPointGid == previous.stopPointGid
      : terminus.name.trim() == previous.name.trim();
  if (!sameStop && _callTime(terminus, isLast: true) != null) return calls;
  return calls.sublist(0, calls.length - 1);
}

/// How far the vehicle has come from [segment] to the call after it, 0 to 1.
/// Null when either end has no usable time.
double? _progressToNext(
  List<ServiceJourneyCall> calls,
  int segment,
  DateTime now,
) {
  final from = _departureTime(calls[segment]);
  final to = _arrivalTime(calls[segment + 1]);
  if (from == null || to == null) return null;
  final leg = to.difference(from).inMilliseconds;
  if (leg <= 0) return null;
  return (now.difference(from).inMilliseconds / leg).clamp(0.0, 1.0);
}

/// Time a call is read at: its departure, or its arrival at the terminus.
DateTime? _callTime(ServiceJourneyCall call, {required bool isLast}) =>
    _estimatedTime(call, isLast: isLast) ?? _plannedTime(call, isLast: isLast);

DateTime? _departureTime(ServiceJourneyCall call) =>
    call.estimatedDepartureTime ?? call.plannedDepartureTime;

DateTime? _arrivalTime(ServiceJourneyCall call) =>
    call.estimatedArrivalTime ?? call.plannedArrivalTime;

DateTime? _plannedTime(ServiceJourneyCall call, {required bool isLast}) =>
    isLast
    ? (call.plannedArrivalTime ?? call.plannedDepartureTime)
    : (call.plannedDepartureTime ?? call.plannedArrivalTime);

DateTime? _estimatedTime(ServiceJourneyCall call, {required bool isLast}) =>
    isLast
    ? (call.estimatedArrivalTime ?? call.estimatedDepartureTime)
    : (call.estimatedDepartureTime ?? call.estimatedArrivalTime);

/// One call in the timeline: its times in the gutter, a node on the line, and
/// the stop with its platform.
class _CallTile extends StatelessWidget {
  const _CallTile({
    required this.call,
    required this.name,
    required this.lineColor,
    required this.passed,
    required this.abovePassed,
    required this.belowPassed,
    required this.isFirst,
    required this.isLast,
    required this.boarded,
    this.vehicleAbove,
    this.vehicleBelow,
  });

  final ServiceJourneyCall call;

  /// Stop name to draw: [ServiceJourneyCall.name] with any municipality the
  /// whole journey shares removed.
  final String name;

  /// The line's own color, used from the vehicle onwards.
  final Color lineColor;

  /// Whether this call's time has gone by.
  final bool passed;

  /// Whether the leg above / below this call is behind the vehicle.
  final bool abovePassed;
  final bool belowPassed;

  /// The first call is where the journey starts, the last is where it ends;
  /// both get a larger node, and the line does not run past them.
  final bool isFirst;
  final bool isLast;

  /// Whether this is the stop the journey was opened from.
  final bool boarded;

  /// Where the vehicle sits on the leg above / below this call, 0 to 1, or
  /// null when it is not on that leg.
  final double? vehicleAbove;
  final double? vehicleBelow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final planned = _plannedTime(call, isLast: isLast);
    final estimated = _estimatedTime(call, isLast: isLast);

    final neutral = theme.colorScheme.outlineVariant;
    final nodeColor = call.isCancelled
        ? theme.colorScheme.error
        : passed
        ? neutral
        : lineColor;
    final emphasize = boarded || isFirst || isLast;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
              child: DepartureTimeColumn(
                planned: planned,
                estimated: estimated,
                isCancelled: call.isCancelled,
                alignment: CrossAxisAlignment.start,
                stacked: true,
              ),
            ),
          ),
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Expanded(
                  child: _Connector(
                    visible: !isFirst,
                    color: abovePassed ? neutral : lineColor,
                    vehicle: vehicleAbove,
                    vehicleColor: lineColor,
                  ),
                ),
                _Node(color: nodeColor, big: emphasize),
                Expanded(
                  child: _Connector(
                    visible: !isLast,
                    color: belowPassed ? neutral : lineColor,
                    vehicle: vehicleBelow,
                    vehicleColor: lineColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: emphasize
                        ? theme.textTheme.titleSmall
                        : theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (call.platform != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: PlatformChip(label: call.platform!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The half of the line above or below a node, hidden at the two ends of the
/// journey and carrying the vehicle dot while it is on that leg.
class _Connector extends StatelessWidget {
  const _Connector({
    required this.visible,
    required this.color,
    this.vehicle,
    required this.vehicleColor,
  });

  final bool visible;
  final Color color;

  /// Fraction of this half the vehicle dot sits at, 0 at the top, or null when
  /// the vehicle is elsewhere.
  final double? vehicle;
  final Color vehicleColor;

  @override
  Widget build(BuildContext context) {
    final line = Center(
      child: Container(
        width: 3,
        color: visible ? color.withValues(alpha: 0.35) : Colors.transparent,
      ),
    );
    final at = vehicle;
    if (at == null) return line;

    return Stack(
      children: [
        Positioned.fill(child: line),
        Positioned.fill(
          // Ticks once a second, so a second of animation keeps the dot moving
          // smoothly between them.
          child: AnimatedAlign(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            alignment: Alignment(0, -1 + 2 * at),
            child: _VehicleDot(color: vehicleColor),
          ),
        ),
      ],
    );
  }
}

/// Where the vehicle is on its journey right now.
class _VehicleDot extends StatelessWidget {
  const _VehicleDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2.5,
        ),
      ),
    );
  }
}

/// Timeline dot: larger where the journey is boarded, starts and ends.
class _Node extends StatelessWidget {
  const _Node({required this.color, required this.big});

  final Color color;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final size = big ? 14.0 : 9.0;
    return SizedBox(
      width: 24,
      height: size,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: big ? color : Theme.of(context).colorScheme.surface,
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}

/// Stop names as they should be drawn.
///
/// Västtrafik qualifies some stop names with their municipality, as
/// `Göteborg, Brunnsparken`. When every call of the journey carries the same
/// qualification it says nothing about any one stop, so it is dropped. Names
/// that are not all qualified are left alone.
List<String> _displayNames(List<ServiceJourneyCall> calls) {
  final names = [for (final call in calls) call.name];
  final prefix = _sharedQualifier(names);
  if (prefix == null) return names;
  return [for (final name in names) name.substring(prefix.length)];
}

/// `Göteborg, ` when every name starts with it, otherwise null.
String? _sharedQualifier(List<String> names) {
  if (names.length < 2) return null;
  final separator = names.first.indexOf(', ');
  if (separator < 0) return null;
  final prefix = names.first.substring(0, separator + 2);
  for (final name in names.skip(1)) {
    if (!name.startsWith(prefix)) return null;
  }
  return prefix;
}
