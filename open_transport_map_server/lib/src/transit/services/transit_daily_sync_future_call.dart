import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../generated/future_calls.dart';
import 'transit_sync_service.dart';

/// Daily transit data sync. Schedules its own next run 24 hours later.
class TransitDailySyncFutureCall extends FutureCall {
  Future<void> sync(Session session) async {
    session.log('Running scheduled daily transit sync');
    try {
      await TransitSyncService.syncAgency(session, 'vasttrafik');
    } catch (e, st) {
      session.log(
        'Scheduled daily transit sync failed: $e',
        level: LogLevel.error,
        stackTrace: st,
      );
    }

    // Serverpod 4: schedule through the generated type-safe API
    // (`session.server.futureCallWithDelay` was removed).
    unawaited(
      session.serverpod.futureCalls
          .callWithDelay(const Duration(hours: 24))
          .transitDailySync
          .sync(),
    );
  }
}
