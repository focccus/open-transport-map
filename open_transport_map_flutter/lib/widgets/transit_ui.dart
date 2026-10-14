import 'package:flutter/material.dart';

/// Presentation shared by the departures list and the journey timeline, so a
/// stop looks the same in both: the line and platform chips, and the
/// realtime-aware time column.
///
/// Every departure or call within this window either side of its time reads
/// `now`; past the end of it the row is dropped. The upstream feed is
/// minute-resolution, so a finer distinction than this is noise.
const departureNowWindow = Duration(seconds: 30);

/// Chip showing a line designation on that line's own colors.
class LineChip extends StatelessWidget {
  const LineChip({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 40),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Chip showing a boarding platform.
class PlatformChip extends StatelessWidget {
  const PlatformChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Countdown plus clock time, with the timetable struck through when the
/// realtime estimate differs from it.
///
/// Both panes use this so a departure and the same stop in its journey read
/// identically. [alignment] is where the column hugs: the list right-aligns it,
/// the timeline left-aligns it. [stacked] puts the two clock times on separate
/// lines, for a pane too narrow to hold them side by side.
class DepartureTimeColumn extends StatelessWidget {
  const DepartureTimeColumn({
    super.key,
    required this.planned,
    required this.estimated,
    required this.isCancelled,
    this.alignment = CrossAxisAlignment.end,
    this.stacked = false,
  });

  /// Timetable time, and the realtime estimate when the upstream reports one.
  final DateTime? planned;
  final DateTime? estimated;
  final bool isCancelled;
  final CrossAxisAlignment alignment;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Locals, so the null checks below promote: widget fields do not.
    final plan = planned;
    final estimate = estimated;
    final shown = estimate ?? plan;
    final realtime =
        estimate != null && (plan == null || !sameMinute(plan, estimate));
    final remaining = shown?.difference(DateTime.now());
    // Behind by more than the `now` window: the call has been and gone, which
    // a live countdown would otherwise keep reporting as `now`.
    final passed = remaining != null && remaining < -departureNowWindow;
    // A past estimate is no longer worth highlighting as live.
    final live = realtime && !passed;

    final times = <Widget>[
      // The timetable is only struck through when there is one to strike: a
      // call whose plan is missing is known by its estimate alone.
      if (realtime && plan != null)
        Text(
          formatClock(plan),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      if (shown != null)
        Text(
          formatClock(shown),
          style: theme.textTheme.bodySmall?.copyWith(
            color: live
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: live ? FontWeight.w600 : null,
            decoration: isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (isCancelled)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              'Cancelled',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Text(
          remaining == null ? '--:--' : relativeTimeLabel(remaining),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: isCancelled
                ? theme.colorScheme.error
                : passed
                ? theme.colorScheme.onSurfaceVariant
                : live
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
        if (stacked)
          Column(crossAxisAlignment: alignment, children: times)
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < times.length; i++)
                if (i == 0)
                  times[i]
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: times[i],
                  ),
            ],
          ),
      ],
    );
  }
}

/// Centered icon, title, detail and optional action: the empty and error state
/// of both panes.
class TransitMessage extends StatelessWidget {
  const TransitMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.action,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}

/// Parses `#RRGGBB` / `#AARRGGBB` (with or without `#`) into a color.
Color parseLineColor(String? value, Color fallback) {
  if (value == null) return fallback;
  var hex = value.trim();
  if (hex.startsWith('#')) hex = hex.substring(1);
  if (hex.length == 6) hex = 'FF$hex';
  final parsed = int.tryParse(hex, radix: 16);
  return parsed == null ? fallback : Color(parsed);
}

String formatClock(DateTime time) {
  final local = time.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

bool sameMinute(DateTime a, DateTime b) =>
    a.year == b.year &&
    a.month == b.month &&
    a.day == b.day &&
    a.hour == b.hour &&
    a.minute == b.minute;

/// Relative time to a departure: `now` inside [departureNowWindow] either
/// side of its time, `passed` once it is further behind, whole minutes beyond
/// it, and never `0 min`.
String relativeTimeLabel(Duration remaining) {
  if (remaining.abs() <= departureNowWindow) return 'now';
  if (remaining.isNegative) return 'passed';
  final minutes = remaining.inMinutes;
  return '${minutes == 0 ? 1 : minutes} min';
}
