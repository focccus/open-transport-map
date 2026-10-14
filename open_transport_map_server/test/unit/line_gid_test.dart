import 'package:open_transport_map_server/src/transit/adapters/vasttrafik/vasttrafik_v3_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('Given lineGidForServiceJourney', () {
    test('when given a 16 character gid then the line gid is derived', () {
      expect(
        VasttrafikV3Adapter.lineGidForServiceJourney('9015014500604700'),
        '9011014500600000',
      );
    });

    test(
      'when given a gid shorter than 16 characters then it passes through',
      () {
        expect(
          VasttrafikV3Adapter.lineGidForServiceJourney('901501450060470'),
          '901501450060470',
        );
      },
    );

    test(
      'when given a gid longer than 16 characters then it passes through',
      () {
        expect(
          VasttrafikV3Adapter.lineGidForServiceJourney('90150145006047000'),
          '90150145006047000',
        );
      },
    );

    test('when given an empty gid then it passes through', () {
      expect(VasttrafikV3Adapter.lineGidForServiceJourney(''), '');
    });
  });
}
