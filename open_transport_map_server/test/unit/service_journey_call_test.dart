import 'package:open_transport_map_server/src/transit/services/transit_departure_service.dart';
import 'package:test/test.dart';

/// One call entry of the departures details payload, with the fields the mapper
/// reads. `index` and `stopPoint` are the only ones it requires.
Map<String, dynamic> _call({
  String index = '1',
  String? name = 'Brunnsparken',
  String? gid = 'sp-1',
  Object? stopPointPlatform,
  Object? stopPointLatitude,
  Object? stopPointLongitude,
  Object? latitude,
  Object? longitude,
  Object? plannedPlatform,
  Object? estimatedPlatform,
  Object? plannedArrivalTime,
  Object? estimatedArrivalTime,
  Object? plannedDepartureTime,
  Object? estimatedDepartureTime,
  Object? estimatedOtherwisePlannedDepartureTime,
  Object? isCancelled,
  Object? isDepartureCancelled,
  Object? isArrivalCancelled,
}) {
  final call = <String, dynamic>{
    'stopPoint': {
      'gid': gid,
      'name': name,
      'platform': stopPointPlatform,
      'latitude': stopPointLatitude,
      'longitude': stopPointLongitude,
    },
    'index': index,
  };
  void put(String key, Object? value) {
    if (value != null) call[key] = value;
  }

  put('latitude', latitude);
  put('longitude', longitude);
  put('plannedPlatform', plannedPlatform);
  put('estimatedPlatform', estimatedPlatform);
  put('plannedArrivalTime', plannedArrivalTime);
  put('estimatedArrivalTime', estimatedArrivalTime);
  put('plannedDepartureTime', plannedDepartureTime);
  put('estimatedDepartureTime', estimatedDepartureTime);
  put(
    'estimatedOtherwisePlannedDepartureTime',
    estimatedOtherwisePlannedDepartureTime,
  );
  put('isCancelled', isCancelled);
  put('isDepartureCancelled', isDepartureCancelled);
  put('isArrivalCancelled', isArrivalCancelled);
  return call;
}

Map<String, dynamic> _details(List<Map<String, dynamic>> calls) => {
  'serviceJourneys': [
    {'callsOnServiceJourney': calls},
  ],
};

void main() {
  group('Given a departures details payload', () {
    test('when reading its calls then they come back in call order', () {
      final calls = TransitDepartureService.callsFromDetails(
        _details([
          _call(index: '3', name: 'Korsvägen', gid: 'sp-3'),
          _call(index: '1', name: 'Brunnsparken', gid: 'sp-1'),
          _call(index: '2', name: 'Valand', gid: 'sp-2'),
        ]),
      );

      expect(calls.map((c) => c.name), [
        'Brunnsparken',
        'Valand',
        'Korsvägen',
      ]);
      expect(calls.map((c) => c.stopPointGid), ['sp-1', 'sp-2', 'sp-3']);
    });

    test('when a call has times then arrival and departure are both read', () {
      final call = TransitDepartureService.callsFromDetails(
        _details([
          _call(
            plannedArrivalTime: '2026-09-28T10:04:00Z',
            estimatedArrivalTime: '2026-09-28T10:06:00Z',
            plannedDepartureTime: '2026-09-28T10:05:00Z',
            estimatedDepartureTime: '2026-09-28T10:07:00Z',
          ),
        ]),
      ).single;

      expect(call.plannedArrivalTime, DateTime.utc(2026, 9, 28, 10, 4));
      expect(call.estimatedArrivalTime, DateTime.utc(2026, 9, 28, 10, 6));
      expect(call.plannedDepartureTime, DateTime.utc(2026, 9, 28, 10, 5));
      expect(call.estimatedDepartureTime, DateTime.utc(2026, 9, 28, 10, 7));
    });

    test('when only the otherwise-planned estimate is given '
        'then it is used as the estimate', () {
      final call = TransitDepartureService.callsFromDetails(
        _details([
          _call(
            plannedDepartureTime: '2026-09-28T10:05:00Z',
            estimatedOtherwisePlannedDepartureTime: '2026-09-28T10:08:00Z',
          ),
        ]),
      ).single;

      expect(call.estimatedDepartureTime, DateTime.utc(2026, 9, 28, 10, 8));
    });

    test('when a call carries geometry then the call level point is used', () {
      final call = TransitDepartureService.callsFromDetails(
        _details([
          _call(
            latitude: 57.71,
            longitude: 11.98,
            stopPointLatitude: 57.70,
            stopPointLongitude: 11.97,
          ),
        ]),
      ).single;

      expect(call.latitude, 57.71);
      expect(call.longitude, 11.98);
    });

    test('when only the stop point carries geometry then it is used', () {
      final call = TransitDepartureService.callsFromDetails(
        _details([
          _call(stopPointLatitude: 57.70, stopPointLongitude: 11.97),
        ]),
      ).single;

      expect(call.latitude, 57.70);
      expect(call.longitude, 11.97);
    });

    test('when the platform is reported in several places '
        'then the realtime one wins', () {
      String? platformOf(Map<String, dynamic>? call) =>
          TransitDepartureService.callsFromDetails(
            _details([call!]),
          ).single.platform;

      // Realtime platform beats the planned one, which beats the stop point's.
      expect(
        platformOf(
          _call(
            stopPointPlatform: 'A',
            plannedPlatform: 'B',
            estimatedPlatform: 'C',
          ),
        ),
        'C',
      );
      expect(
        platformOf(_call(stopPointPlatform: 'A', plannedPlatform: 'B')),
        'B',
      );
      expect(platformOf(_call(stopPointPlatform: 'A')), 'A');
      expect(platformOf(_call()), isNull);
    });

    test('when either leg of a call is cancelled then so is the call', () {
      bool cancelledOf(Map<String, dynamic>? call) =>
          TransitDepartureService.callsFromDetails(
            _details([call!]),
          ).single.isCancelled;

      expect(cancelledOf(_call(isCancelled: true)), isTrue);
      expect(cancelledOf(_call(isDepartureCancelled: true)), isTrue);
      expect(cancelledOf(_call(isArrivalCancelled: true)), isTrue);
      expect(cancelledOf(_call(isCancelled: false)), isFalse);
    });

    test('when a call names no stop point then it is skipped', () {
      final calls = TransitDepartureService.callsFromDetails(
        _details([
          _call(index: '1', name: 'Brunnsparken'),
          _call(index: '2', name: null),
        ]),
      );

      expect(calls.map((c) => c.name), ['Brunnsparken']);
    });

    test('when the payload holds no journey then nothing is returned', () {
      expect(TransitDepartureService.callsFromDetails(null), isEmpty);
      expect(TransitDepartureService.callsFromDetails(const {}), isEmpty);
      expect(
        TransitDepartureService.callsFromDetails(const {
          'serviceJourneys': [
            {'callsOnServiceJourney': <Object>[]},
          ],
        }),
        isEmpty,
      );
    });
  });
}
